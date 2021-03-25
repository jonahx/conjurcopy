# frozen_string_literal: true

module Authentication
  module AuthnK8s

    AUTHENTICATOR_NAME = 'authn-k8s'

    module Restrictions

      NAMESPACE = "namespace"
      SERVICE_ACCOUNT = "service-account"
      POD = "pod"
      DEPLOYMENT = "deployment"
      STATEFUL_SET = "stateful-set"
      DEPLOYMENT_CONFIG = "deployment-config"

      # This is not exactly a restriction, because it only validates container existence and not requesting container name.
      AUTHENTICATION_CONTAINER_NAME = "authentication-container-name"

      REQUIRED = [NAMESPACE].freeze
      RESOURCE_TYPE_EXCLUSIVE = [DEPLOYMENT, DEPLOYMENT_CONFIG, STATEFUL_SET].freeze
      OPTIONAL = [SERVICE_ACCOUNT, POD, AUTHENTICATION_CONTAINER_NAME].freeze
      PERMITTED = REQUIRED + RESOURCE_TYPE_EXCLUSIVE + OPTIONAL

      CONSTRAINTS = Constraints::MultipleConstraint.new(
        Constraints::RequiredConstraint.new(required: REQUIRED),
        Constraints::PermittedConstraint.new(permitted: PERMITTED),
        Constraints::ExclusiveConstraint.new(exclusive: RESOURCE_TYPE_EXCLUSIVE)
      )

    end
  end
end
