# frozen_string_literal: true

# Utility methods for OIDC authenticator

module AuthnOidcHelper
  include AuthenticatorHelpers

  SERVICE_ID = 'keycloak'
  ACCOUNT = 'cucumber'

  def authenticate_id_token_with_oidc(service_id:, account:, id_token: parsed_id_token)
    service_id_part = service_id ? "/#{service_id}" : ""
    path = "#{conjur_hostname}/authn-oidc#{service_id_part}/#{account}/authenticate"

    payload = {}
    unless id_token.nil?
      payload["id_token"] = id_token
    end

    post(path, payload)
  end

  def create_oidc_secret(variable_name, value, service_id_suffix = "/keycloak")
    path = "cucumber:variable:conjur/authn-oidc#{service_id_suffix}"
    Secret.create(resource_id: "#{path}/#{variable_name}", value: value)
  end

  def parsed_id_token
    @oidc_id_token.to_s
  end

  def invalid_id_token
    "invalididtoken"
  end

  private

  def oidc_client_id
    @oidc_client_id ||= validated_env_var('KEYCLOAK_CLIENT_ID')
  end

  def oidc_client_secret
    @oidc_client_secret ||= validated_env_var('KEYCLOAK_CLIENT_SECRET')
  end

  def oidc_provider_uri
    @oidc_provider_uri ||= validated_env_var('PROVIDER_URI')
  end

  def oidc_provider_internal_uri
    @oidc_provider_internal_uri ||= validated_env_var('PROVIDER_INTERNAL_URI')
  end

  def oidc_id_token_user_property
    @oidc_id_token_user_property ||= validated_env_var('ID_TOKEN_USER_PROPERTY')
  end

  def oidc_scope
    @oidc_scope ||= validated_env_var('KEYCLOAK_SCOPE')
  end

  def parse_oidc_id_token
    @oidc_id_token = (JSON.parse @response_body)["id_token"]
  rescue => err
    raise "Failed to fetch id_token from HTTP response: #{@response_body} with Reason: #{err}"
  end
end

World(AuthnOidcHelper)
