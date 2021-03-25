# frozen_string_literal: true

class AuthenticateController < ApplicationController
  include BasicAuthenticator
  include AuthorizeResource

  def index
    authenticators = {
      # Installed authenticator plugins
      installed: installed_authenticators.keys.sort,

      # Authenticator webservices created in policy
      configured:
        Authentication::InstalledAuthenticators.configured_authenticators.sort,

      # Authenticators white-listed in CONJUR_AUTHENTICATORS
      enabled: enabled_authenticators.sort
    }

    render json: authenticators
  end

  def status
    Authentication::ValidateStatus.new.(
      authenticator_status_input: status_input,
      enabled_authenticators: Authentication::InstalledAuthenticators.enabled_authenticators_str(ENV)
    )
    render json: { status: "ok" }
  rescue => e
    log_backtrace(e)
    render status_failure_response(e)
  end

  def update_config
    body_params = Rack::Utils.parse_nested_query(request.body.read)

    Authentication::UpdateAuthenticatorConfig.new.(
      account: params[:account],
      authenticator_name: params[:authenticator],
      service_id: params[:service_id],
      username: ::Role.username_from_roleid(current_user.role_id),
      enabled: body_params['enabled'] || false
    )

    head :no_content
  rescue => e
    handle_authentication_error(e)
  end

  def status_input
    Authentication::AuthenticatorStatusInput.new(
      authenticator_name: params[:authenticator],
      service_id: params[:service_id],
      account: params[:account],
      username: ::Role.username_from_roleid(current_user.role_id),
      client_ip: request.ip
    )
  end

  def login
    result = perform_basic_authn
    raise Unauthorized, "Client not authenticated" unless authentication.authenticated?
    render plain: result.authentication_key
  rescue => e
    handle_login_error(e)
  end

  def authenticate(input = authenticator_input)
    authn_token = Authentication::Authenticate.new.(
      authenticator_input: input,
      authenticators: installed_authenticators,
      enabled_authenticators: Authentication::InstalledAuthenticators.enabled_authenticators_str(ENV)
    )
    content_type = :json
    if encoded_response?
      logger.debug(LogMessages::Authentication::EncodedJWTResponse.new)
      content_type = :plain
      authn_token = ::Base64.strict_encode64(authn_token.to_json)
      response.set_header("Content-Encoding", "base64")
    end
    render content_type => authn_token
  rescue => e
    handle_authentication_error(e)
  end

  # Update the input to have the username from the token and authenticate
  def authenticate_oidc
    params[:authenticator] = "authn-oidc"
    input = Authentication::AuthnOidc::UpdateInputWithUsernameFromIdToken.new.(
      authenticator_input: authenticator_input
    )
  rescue => e
    handle_authentication_error(e)
  else
    authenticate(input)
  end

  def authenticate_gcp
    params[:authenticator] = "authn-gcp"
    input = Authentication::AuthnGcp::UpdateAuthenticatorInput.new.(
      authenticator_input: authenticator_input
    )
  rescue => e
    handle_authentication_error(e)
  else
    authenticate(input)
  end

  def authenticator_input
    Authentication::AuthenticatorInput.new(
      authenticator_name: params[:authenticator],
      service_id:         params[:service_id],
      account:            params[:account],
      username:           params[:id],
      credentials:        request.body.read,
      client_ip:          request.ip,
      request:            request
    )
  end

  def k8s_inject_client_cert
    # TODO: add this to initializer
    Authentication::AuthnK8s::InjectClientCert.new.(
      conjur_account:   ENV['CONJUR_ACCOUNT'],
      service_id:       params[:service_id],
      client_ip:        request.ip,
      csr:              request.body.read,

      # The host-id is split in the client where the suffix is in the CSR
      # and the prefix is in the header. This is done to maintain backwards-compatibility
      host_id_prefix:   request.headers["Host-Id-Prefix"]
    )
    head :accepted
  rescue => e
    handle_authentication_error(e)
  end

  private

  def handle_login_error(err)
    login_error = LogMessages::Authentication::LoginError.new(err.inspect)
    logger.info(login_error)
    log_backtrace(err)

    case err
    when Errors::Authentication::Security::AuthenticatorNotWhitelisted,
      Errors::Authentication::Security::WebserviceNotFound,
      Errors::Authentication::Security::AccountNotDefined,
      Errors::Authentication::Security::RoleNotFound
      raise Unauthorized
    else
      raise err
    end
  end

  def handle_authentication_error(err)
    authentication_error = LogMessages::Authentication::AuthenticationError.new(err.inspect)
    logger.info(authentication_error)
    log_backtrace(err)

    case err
    when Errors::Authentication::Security::AuthenticatorNotWhitelisted,
      Errors::Authentication::Security::WebserviceNotFound,
      Errors::Authentication::Security::RoleNotFound,
      Errors::Authentication::Security::AccountNotDefined,
      Errors::Authentication::AuthnOidc::IdTokenClaimNotFoundOrEmpty,
      Errors::Authentication::Jwt::TokenVerificationFailed,
      Errors::Authentication::Jwt::TokenDecodeFailed,
      Errors::Conjur::RequiredSecretMissing,
      Errors::Conjur::RequiredResourceMissing
      raise Unauthorized

    when Errors::Authentication::Security::RoleNotAuthorizedOnResource
      raise Forbidden

    when Errors::Authentication::RequestBody::MissingRequestParam
      raise BadRequest

    when Errors::Authentication::Jwt::TokenExpired
      raise Unauthorized.new(err.message, true)

    when Errors::Authentication::OAuth::ProviderDiscoveryTimeout
      raise GatewayTimeout

    when Errors::Util::ConcurrencyLimitReachedBeforeCacheInitialization
      raise ServiceUnavailable

    when Errors::Authentication::OAuth::ProviderDiscoveryFailed,
      Errors::Authentication::OAuth::FetchProviderKeysFailed
      raise BadGateway

    when Errors::Authentication::AuthnK8s::CSRMissingCNEntry,
      Errors::Authentication::AuthnK8s::CertMissingCNEntry
      raise ArgumentError

    else
      raise Unauthorized
    end
  end

  def log_backtrace(err)
    err.backtrace.each do |line|
      # We want to print a minimal stack trace in INFO level so that it is easier
      # to understand the issue. To do this, we filter the trace output to only
      # Conjur application code, and not code from the Gem dependencies.
      # We still want to print the full stack trace (including the Gem dependencies
      # code) so we print it in DEBUG level.
      line.include?(ENV['GEM_HOME']) ? logger.debug(line) : logger.info(line)
    end
  end

  def status_failure_response(error)
    logger.debug("Status check failed with error: #{error.inspect}")

    payload = {
      status: "error",
      error: error.inspect
    }

    status_code = case error
                  when Errors::Authentication::Security::RoleNotAuthorizedOnResource
                    :forbidden
                  when Errors::Authentication::StatusNotSupported
                    :not_implemented
                  when Errors::Authentication::AuthenticatorNotSupported
                    :not_found
                  else
                    :internal_server_error
                  end

    { :json => payload, :status => status_code }
  end

  def installed_authenticators
    @installed_authenticators ||= Authentication::InstalledAuthenticators.authenticators(ENV)
  end

  def enabled_authenticators
    Authentication::InstalledAuthenticators.enabled_authenticators(ENV)
  end

  def encoded_response?
    return false unless request.accept_encoding
    encodings = request.accept_encoding.split(",")
    encodings.any? { |encoding| encoding.squish.casecmp?("base64") }
  end
end
