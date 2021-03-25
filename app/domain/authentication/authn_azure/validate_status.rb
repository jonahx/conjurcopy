module Authentication
  module AuthnAzure

    ValidateStatus = CommandClass.new(
      dependencies: {
        fetch_authenticator_secrets: Authentication::Util::FetchAuthenticatorSecrets.new,
        discover_identity_provider:  Authentication::OAuth::DiscoverIdentityProvider.new
      },
      inputs:       %i[account service_id]
    ) do

      def call
        validate_secrets
        validate_provider_is_responsive
      end

      private

      def validate_secrets
        azure_authenticator_secrets
      end

      def azure_authenticator_secrets
        @azure_authenticator_secrets ||= @fetch_authenticator_secrets.(
          service_id: @service_id,
          conjur_account: @account,
          authenticator_name: "authn-azure",
          required_variable_names: required_variable_names
        )
      end

      def required_variable_names
        @required_variable_names ||= %w[provider-uri]
      end

      def validate_provider_is_responsive
        @discover_identity_provider.(
          provider_uri: provider_uri
        )
      end

      def provider_uri
        @azure_authenticator_secrets["provider-uri"]
      end
    end
  end
end
