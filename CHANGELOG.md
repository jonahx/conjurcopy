# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `/whoami` API endpoint now produces audit events.
  [cyberark/conjur#2052](https://github.com/cyberark/conjur/issues/2052)
- When a user checks permissions of a non-existing role or a non-existing resource, Conjur now audits a failure message.
  [cyberark/conjur#2059](https://github.com/cyberark/conjur/issues/2059)
- Print login and authentication error stack trace to the log in INFO level.
  [cyberark/conjur#2080](https://github.com/cyberark/conjur/issues/2080)

### Changed
- The secrets batch retrieval endpoint now refers to the `Accept-Encoding` header rather than `Accept` to determine the response encoding
  [cyberark/conjur#2065](https://github.com/cyberark/conjur/pull/2065)

## [1.11.4] - 2021-03-09

### Security
- Updated Rails to 5.2.4.5 to address CVE-2021-22880.
  [cyberark/conjur#2056](https://github.com/cyberark/conjur/issues/2056)

## [1.11.3] - 2021-02-22

### Fixed
- Conjur now raises a new `ServiceIdMissing` error if the `service-id` param is
  missing in an authentication request for the OIDC authenticator.
  [cyberark/conjur#2004](https://github.com/cyberark/conjur/issues/2004)

### Changed
- Conjur now raises a `RoleNotFound` error when trying to authenticate a
  non-existent host in authn-k8s.
  [cyberark/conjur#2046](https://github.com/cyberark/conjur/issues/2046)

## [1.11.2] - 2021-02-02
### Added
- New `edge`-tagged images are published to DockerHub on every master branch
  build.
  [cyberark/conjur#1617](https://github.com/cyberark/conjur/issues/1617)

### Changed
- Conjur images are updated to use pinned versions of the public base images.
  Users can now determine exactly which dependencies in the
  [Conjur Base Image](https://github.com/cyberark/conjur-base-image) project
  are included in their Conjur image.
  [cyberark/conjur#1974](https://github.com/cyberark/conjur/issues/1974)
- When [batch secret retrieval](https://docs.conjur.org/Latest/en/Content/Developer/Conjur_API_Batch_Retrieve.htm)
  requests are sent with an `Accept: base64` header, the secret values in
  the response will all be Base64-encoded. Sending requests with this header
  allows users to retrieve binary secrets encoded in Base64.
  [cyberark/conjur#1962](https://github.com/cyberark/conjur/issues/1962)
- Conjur now verifies that the `offset` parameter is a valid integer value.
  The `GET /resources` request will fail if `offset` is not an integer greater
  than or equal to 0.
  [cyberark/conjur#1997](https://github.com/cyberark/conjur/issues/1997)

### Fixed
- Requests with empty body and `application/json` Content-Type Header will now
  return 400 error instead of 500 error.
  [cyberark/conjur#1968](https://github.com/cyberark/conjur/issues/1968)
- Users no longer receive 500 errors when loading policy after performing
  database backup and restore.
  [cyberark/conjur#1948](https://github.com/cyberark/conjur/issues/1948)
- The audit endpoint no longer incorrectly reports a 404 Not Found response
  when the resource ID used for retrieving audit events includes a period (.).
  With this change, the audit endpoint is now consistent with how other Conjur
  endpoints handle unencoded periods in resource IDs.
  [cyberark/conjur#2001](https://github.com/cyberark/conjur/issues/2001)
- Attempts to retrieve binary secret data in a
  [batch secret retrieval request](https://docs.conjur.org/Latest/en/Content/Developer/Conjur_API_Batch_Retrieve.htm)
  without using the `Accept: base64` header now returns a message with the 500
  response to explain that improper secret encoding is the cause of the error.
  [cyberark/conjur#1962](https://github.com/cyberark/conjur/issues/1962)
- `GET /resources` request with non-numeric delimiter (limit or offset) now
  returns `Error 422 Unprocessable Entity` instead of `Error 500`.
  [cyberark/conjur#1997](https://github.com/cyberark/conjur/issues/1997)
- `POST /host_factory_tokens` request with invalid ip address or CIDR range of
  `cidr` parameter now returns `Error 422 Unprocessable Entity` instead of `Error 500`.
  [cyberark/conjur#2011](https://github.com/cyberark/conjur/issues/2011)

### Security
- Kubernetes authenticator certificate injection process now performs certificate
  verification to prevent MitM attacks.
  [Security Bulletin](https://github.com/cyberark/conjur/security/advisories/GHSA-hvhv-f953-rwmv)

## [1.11.1] - 2020-11-19
### Added
- UBI-based Conjur image to support Conjur server running on OpenShift. Image
  will be published to RedHat Container Registry.
  [cyberark/conjur#1883](https://github.com/cyberark/conjur/issues/1883)

## [1.11.0] - 2020-11-06
### Added
- GCP authenticator (`authn-gcp`) supports authenticating from Google Cloud Function (GCF)
  using a GCE instance identity token.
  See [design](https://github.com/cyberark/conjur/blob/master/design/authenticators/authn_gcp/authn_gcp_solution_design.md)
  for details. [cyberark/conjur#1804](https://github.com/cyberark/conjur/issues/1804)

### Changed
- Conjur now raises an ExecCommandError error instead of a CertInstallationError
  error in case it failed to install the client certificate during authn-k8s.
  [cyberark/conjur#1860](https://github.com/cyberark/conjur/issues/1860)

### Fixed
- Conjur now raises an Unauthorized error when a user attempts to rotate the API key of a
  nonexistent role. Previously, the operation would result in a successful rotation of the
  existing user's API key, with no indication that the target of the operation had changed.
  [cybeark/conjur#1914](https://github.com/cyberark/conjur/issues/1914)

### Security
- Bumped Ruby version from 2.5.1 to 2.5.8 to address
  [CVE-2020-10663](https://nvd.nist.gov/vuln/detail/CVE-2020-10663).
  [cyberark/conjur#1906](https://github.com/cyberark/conjur/pull/1906)

## [1.10.0] - 2020-10-16
### Added
- [Documentation](https://github.com/cyberark/conjur/blob/master/UPGRADING.md)
  explaining how to upgrade a Conjur server deployed in a Docker Compose environment.
  [cyberark/conjur#1528](https://github.com/cyberark/conjur/issues/1528), [cyberark/conjur#1584](https://github.com/cyberark/conjur/issues/1584)
- When Conjur starts, we now convert blank environment variables to nil. This ensures we treat empty environment values as
  if the environment variable is not present, rather than attempting to use the empty string value. [cyberark/conjur#1841](https://github.com/cyberark/conjur/issues/1841)

### Changed
- The "inject_client_cert" request now returns 202 Accepted instead of 200 OK to
  indicate that the cert injection has started but not necessarily completed.
  [cyberark/conjur#1848](https://github.com/cyberark/conjur/issues/1848)

### Fixed
- Conjur now verifies that Kubernetes Authenticator variables exist and have value before retrieving them so that a
  proper error will be raised if they aren't.
  [cyberark/conjur#1315](https://github.com/cyberark/conjur/issues/1315)

## [1.9.0] - 2020-08-31
### Added
- A new authenticator for applications running in Google Cloud Platform (`authn-gcp`),
  which supports authenticating from Google Compute Engines (GCE) using a GCE instance
  identity token. See [design](design/authenticators/authn_gcp/authn_gcp_solution_design.md)
  for details. [cyberark/conjur#1711](https://github.com/cyberark/conjur/issues/1711)
- New `/whoami` API endpoint for improved supportability and debugging for access
  tokens and client IP address determination. [cyberark/conjur#1697](https://github.com/cyberark/conjur/issues/1697)
- `TRUSTED_PROXIES` is validated at Conjur startup to ensure that it contains
  valid IP addresses and/or address ranges in CIDR notation.
  [cyberark/conjur#1727](https://github.com/cyberark/conjur/issues/1727)
- The `/authenticate` endpoint now returns a text/plain base64 encoded access token
  if the `Accept-Encoding` request header includes `base64`.
  [cyberark/conjur#151](https://github.com/cyberark/conjur/issues/151)

### Changed
- The "inject_client_cert" request now returns 202 Accepted instead of 200 OK to
  indicate that the cert injection has started but not necessarily completed.
  [cyberark/conjur#1848](https://github.com/cyberark/conjur/issues/1848)
- The Conjur server request logs now records the same IP address used by audit
  logs and network authentication filters with the `restricted_to` attribute.
  [cyberark/conjur#1719](https://github.com/cyberark/conjur/issues/1719)
- Conjur now only trusts `127.0.0.1` to send the `X-Forwarded-For` header by
  default. Additional trusted IP addresses may be added with the `TRUSTED_PROXIES`
  environment variable. [cyberark/conjur#1725](https://github.com/cyberark/conjur/issues/1725)
- Invalid CIDR notation in `restricted_to` now returns a policy validation
  error, rather than an internal server error.
  [cyberark/conjur#1763](https://github.com/cyberark/conjur/issues/1763)

### Fixed
- The `TRUSTED_PROXIES` environment variable now works correctly again after the
  Rails 5 upgrade. This is to indicate trusted proxy IP addresses when using the
  `X-Forwarded-For` HTTP header to identity the true client IP address of a request.
  [cyberark/conjur#1689](https://github.com/cyberark/conjur/issues/1689)
- A new database migration step updates the fingerprints in slosilo. The FIPS compliance
  update in `v1.8.0` caused the previous fingerprints to be invalid.
  [cyberark/conjur#1584](https://github.com/cyberark/conjur/issues/1584)

### Security
- Replaces string comparison with Secure Compare to prevent timing attacks against
  the API authentication endpoint. [Security Bulletin](https://github.com/cyberark/conjur/security/advisories/GHSA-c7x2-6g4j-327p)
- Roles must use basic authentication to rotate their own API key, and can no longer
  rotate their API key using only an access token. [Security Bulletin](https://github.com/cyberark/conjur/security/advisories/GHSA-qhjf-g9gm-64jq)

## [1.8.1] - 2020-07-14
### Fixed
- Log the OpenSSL FIPS mode after Rails is initialized for both OSS and DAP.
  [cyberark/conjur#1684](https://github.com/cyberark/conjur/pull/1684)
- Bump `conjur-policy-parser` so `revoke (member)` and `deny (role)`
  can correctly utilize relative paths. [cyberark/conjur-policy-parser#23](https://github.com/cyberark/conjur-policy-parser/pull/23)

## [1.8.0] - 2020-07-10
### Changed
- Use OpenSSL 1.0.2u to support FIPS compliance.
  [cyberark/conjur#1527](https://github.com/cyberark/conjur/issues/1527)
- Conjur can be configured to run in FIPS compliant or Non-FIPS compliant mode depending on requirements.
  FIPS Compliant mode is slightly slower then non-FIPS compliant.
  [cyberark/conjur#1527](https://github.com/cyberark/conjur/issues/1527)
- Bump conjur-rack from 4.0.0 to 4.2.0 that consumes FIPS compliant slosilo.
  [cyberark/conjur#1527](https://github.com/cyberark/conjur/issues/1527)
- Print login and authentication error to the log in INFO level.
  [cyberark/conjur#1377](https://github.com/cyberark/conjur/issues/1377)
- Print proper message when user does not exist in authn or login request with
  default authenticator.
  [cyberark/conjur#1655](https://github.com/cyberark/conjur/issues/1655)

### Added
- Password changes (`PUT /authn/:account/password`) now produce audit events with
  message ID `password`. [cyberark/conjur#1548](https://github.com/cyberark/conjur/issues/1548)
- API key rotations (`PUT /:authenticator/:account/api_key`) now produce audit events with
  message ID `api-key`. [cyberark/conjur#1549](https://github.com/cyberark/conjur/issues/1549)
- All audit events now contain the IP address of the client that initiated the
  API request (e.g. `[client@43868 ip="172.24.0.5"]`).
  [cyberark/conjur#1550](https://github.com/cyberark/conjur/issues/1550)
- Print Conjur server FIPS mode status. [cyberark/conjur#1654](https://github.com/cyberark/conjur/issues/1654)

### Security
- Updated `rack` to `2.2.3` to resolve CVE-2020-8184. [cyberark/conjur#1643](https://github.com/cyberark/conjur/pull/1643)

## [1.7.4] - 2020-06-17

### Fixed
- The default content type for requests is now set at the beginning of the
  Rack middleware chain, so that the content type is available for
  subsequent middleware ([cyberark/conjur#1622](https://github.com/cyberark/conjur/issues/1622))
- The default content type middleware now correctly checks for the
  absence of the `Content-Type` header
  ([cyberark/conjur#1622](https://github.com/cyberark/conjur/issues/1622))

## [1.7.3] - 2020-06-11

### Fixed
- Host Factory Host creation no longer makes unecessary database queries, causing
  performance issues with large numbers of created hosts
  ([cyberark/conjur#1605](https://github.com/cyberark/conjur/issues/1605))

## [1.7.2] - 2020-06-08

### Fixed
- The Conjur version is now printed on server startup, after running `conjurctl server`
  ([cyberark/conjur#1590](https://github.com/cyberark/conjur/pull/1590))
- Raise proper error of an authn request with a non-existing user to the `authn`
  authenticator ([cyberark/conjur#1591](https://github.com/cyberark/conjur/pull/1591))

## [1.7.1] - 2020-06-03

### Added
- Print version on server startup ([cyberark/conjur#1531](https://github.com/cyberark/conjur/issues/1531))

### Fixed
- `rake policy:load` fails when loading policy ([cyberark/conjur#1581](https://github.com/cyberark/conjur/issues/1581))

## [1.7.0] - 2020-05-29

### Fixed
- The k8s authenticator correctly authenticates an app using the host ID to specify
  the k8s resource constraints and an annotation to specify the authenticator
  container name using the "authn-k8s" prefix ([cyberark/conjur#1535](https://github.com/cyberark/conjur/issues/1535), [conjurinc/dap-support#79](https://github.com/conjurinc/dap-support/issues/79)) - [PR](https://github.com/cyberark/conjur/pull/1499).
- Fixed exception in `conjurctl` when loading policy ([conjurinc/dap-support#80](https://github.com/conjurinc/dap-support/issues/80)) - [PR](https://github.com/cyberark/conjur/pull/1510).

### Changed
- Updated the title of status page to `Conjur Status` from `Conjur` ([conjurinc/dap-support](https://github.com/conjurinc/dap-support/issues/75)) - [PR](https://github.com/cyberark/conjur/pull/1499).
- Policy load API endpoints now default to the `application/x-yaml` content-type if no content type is provided in the request ([conjurinc/dap-support#74](https://github.com/conjurinc/dap-support/issues/74)) - [PR](https://github.com/cyberark/conjur/pull/1505).
- ActiveSupport uses SHA1 instead of MD5 ([cyberark/conjur#1418](https://github.com/cyberark/conjur/issues/1418)).
- Authentication audit events now use separate operations for `authenticate`,
  `login`, and `validate-status` workflows
  ([cyberark/conjur#1054](https://github.com/cyberark/conjur/issues/1054)).
- Authentication workflow checks origin before credentials to insure a request can authenticate before authenticating ([cyberark/conjur#1568](https://github.com/cyberark/conjur/issues/1568)).

### Added
- The Kubernetes authentication `/inject-client-cert` endpoint now generates
  an authentication audit event with the `k8s-inject-client-cert` operation
  ([cyberark/conjur#1538](https://github.com/cyberark/conjur/issues/1538)).
- Adds a `CertMissingCNEntry` error to improve visibility of Kubernetes authenticator failures ([cyberark/conjur#1278](cyberark/conjur/issues/1278)).
- Logs the authenticator used when the `authentication-container-name` annotation is missing ([conjurinc/dap-support#69](https://github.com/conjurinc/dap-support/issues/69)) - [PR](https://github.com/cyberark/conjur/pull/1526).

### Removed
- Images are no longer published to Quay.io.

## [1.6.0] - 2020-04-14

### Changed
- Use Ubuntu 18.04 LTS as the base image for Conjur to continue using Ruby 2.5
  ([cyberark/conjur#1456](https://github.com/cyberark/conjur/issues/1456)).
- Conjur image now performs a `dist-upgrade` as the first image build step to
  ensure the image includes all available vulnerability fixes in the base OS.
- Upgrade from Rails 4 to Rails 5

## [1.5.1] - 2020-03-25

### Fixed
- Status page details section now displays the Conjur version number
  [cyberark/conjur#1438](https://github.com/cyberark/conjur/issues/1438).

## [1.5.0] - 2020-03-23

### Added
- Hosts can authenticate from Azure VMs using an Azure access token. See
  [design](design/authenticators/authn_azure/authn_azure_solution_design.md) for details
  ([conjurinc/appliance#927](https://github.com/conjurinc/appliance/issues/927)).

### Changed
- Lock rotators to prevent multiple rotations from incurring simultaneously.

### Fixed
- Fix support for using deployment as K8s authentication resource type for Kubernetes >= 1.16
  ([#1440](https://github.com/cyberark/conjur/issues/1440))

## [1.4.7] - 2020-03-12

### Changed
- Improved flows and rules around user creation (#1272)
- Kubernetes authenticator now returns 403 on unpermitted hosts instead of a 401 (#1283)
- Conjur hosts can authenticate with authn-k8s from anywhere in the policy branch (#1189)

### Fixed
- Updated broken links on server status page (#1341)

## [1.4.6] - 2020-01-21

### Changed
- K8s hosts' resource restrictions is extracted from annotations or id. If it is
  defined in annotations it will taken from there and if not, it will be taken
  from the id.

## [1.4.5] - 2019-12-22

### Added
- Added API endpoint to enable and disable authenticators. See
  [design/authenticator_whitelist_api.md](design/authenticators/authenticator_whitelist_api.md)
  for details.

### Changed
- The k8s host id does not use the "{@account}:host:conjur/authn-k8s/#{@service_name}/apps"
  prefix and takes the full host-id from the CSR. We also handle backwards-compatibility and use
  the prefix in case of an older client.

## [1.4.4] - 2019-12-19

### Added
- Early validation of account existence during OIDC authentication
- Code coverage reporting and collection

### Changed
- Bumped `puma` from 3.12.0 to 3.12.2
- Bumped `rack` from 1.6.11 to 1.6.12
- Bumped `excon` from 0.62.0 to 0.71.0

### Fixed
- Fixed password rotation of blank password
- Fixed bug with multi-cert CA chains in Kubernetes service accounts
- Fixed build issues with creating namespaces with multiple values

### Removed
- Removed follower env configuration

## [1.4.3] - 2019-11-26

### Added
- Flattening of OSS container layers.

### Changed
- Upgraded Nokogiri to 1.10.5.
- Upgrade base image of OSS to `ubuntu:20.20`.
- Enablement work to get OSS container to work on OpenShift as-is.

## [1.4.2] - 2019-09-13

### Fixed
- An unset initContainer field in a deployment config pod spec will no
  longer cause the k8s authenticator to fail with `undefined method` ([#1182](https://github.com/cyberark/conjur/issues/1182)).

## [1.4.1] - 2019-06-24
### Fixed
- Make sure the authentication framework only caches Role lookups for the
  duration of a single request. Reusing stale lookups was leading to
  authentication failures.

## [1.4.0] - 2019-04-23
### Added
- Kubernetes authentication can now work externally from Kubernetes

### Changed
- Moved changelog validation up in CI pipeline

## [1.3.7] - 2019-03-27
### Changed
- Updated links to Policy & Cryptography reference in API documentation
- Updated conjur-policy-parser to
  [v3.0.3](https://github.com/conjurinc/conjur-policy-parser/blob/conjur-oss/CHANGELOG.md#v303).
- Replaced `changelog` entrypoint in `ci/test` with a separate script. Building
  the `conjur` and `conjur-test` images just to be able to install and run the
  `parse_a_changelog` gem seemed a little heavyweight.
- Renamed the old docs/ folder to design/

## [1.3.6] - 2019-02-19
### Changed
- Reduced IAM authentication logging
- Refactored authentication strategies

### Removed
- Removed OIDC APIs public access

## [1.3.5] - 2019-02-07
### Changed
- Rails version updated to v4.2.11.
- Updated Docker build to pre-compile Rails assets for Conjur image.

## [1.3.4] - 2018-12-19
### Changed
- Updated dependencies and Ruby version of Docker image
- Removed the cloudformation template in favor of the one found in the docs
  at https://docs.conjur.org/Latest/en/Content/Get%20Started/install-open-source.htm#h2-item-2

### Fixed
- Fixed the authn_restricted_to.feature so that it doesn't depend on the default docker
  network (172.0.0.0/8).
- Fixed Syslog formatting to properly escape the closing square bracket (]) per RFC 5424

## [1.3.3] - 2018-11-20
### Added
- Added support for secure LDAP connections in the LDAP authenticator.
- Added support to configure the LDAP authenticator with policy instead
   of environment variables.

## [1.3.2] - 2018-11-14
### Fixed
- Fixed request parameter parsing when creating or deleting a host factory token.
- Updated ffi and loofah dependencies to latest versions of each.

## [1.3.1] - 2018-10-19
### Fixed
- Fixed host factory `500` server response when a `Role` for a given host ID already
  exists but there is no corresponding `Resource` record.
- Improved authenticator error handling and logging.

## [1.3.0] - 2018-10-10
### Fixed
- Previously, loading a policy with a host factory that doesn't include
  any layers would cause a `nil` runtime exception. Now this case is checked
  specifically and raises a policy load error with a description of the problem.
- Added support for authenticators to implement `/login` in addition to `/authenticate`
- Implemented `/login` for `authn-ldap`.

## [1.2.0] - 2018-09-18
### Added
- Added support for issuing certificates to Hosts using CAs configured as
  Conjur services. More details are available [here](design/CERTIFICATE_SIGNING.md).
- Added support for Conjur CAs to use encrypted private keys
- Implemented keyword search for Role memberships
- Update Conjur issued certificates to include a SPIFFE SVID as a subject alternative
  name (SAN).

### Changed
- Change authn-k8s to expect the client cert (passed in `X-SSL-Client-Certificate`) to be
  url-escaped.
- Update Conjur issued certificates to use the common name derived from the authenticated
  host, rather than use the value from the CSR.

### Fixed
- Prevent anonymous (password-less) authentication with LDAP.

## [1.1.2] - 2018-08-22
### Fixed
- Substantial performance improvement when loading large policy files

### Security
- Fixes a vulnerability that could allow an authn-K8s request to bypass mutual TLS authentication. All Conjur users using authn-k8s within Kubernetes or OpenShift are strongly recommended to upgrade to this version.

## [1.1.1] - 2018-08-10
### Added
- `conjurctl export` now includes the account list to support migration
- `conjurctl export` allows the operator to specify the file name label using the `-l` or `--label` flag
- Update puma to a version that understands how to handle having ipv6 disabled
- Update puma worker timeout to allow longer requests to finish (from 1 minute to 10 minutes)

## [1.1.0] - 2018-07-30
### Added
- Adds `conjurctl export` command to provide a migration data package to Conjur EE

## [1.0.1] - 2018-07-23
### Fixed
- Handling of absolute user ids in policies.
- Attempts to fetch a secret from a nonexistent resource no longer cause 500.

## [1.0.0] - 2018-07-16
### Added
- Audit attempts to update and fetch an invisible secret.
- Updated license to LGPL

## [0.9.0] - 2018-07-11
### Added
- Adds CIDR restrictions to Host and User resources
- Adds Kubernete authentication
- Optimize audit database and responses, for a significant improvement of performance.

### Fixed
- `start` no longer fails to show Help information.

## [0.8.1] - 2018-06-29
### Added
- Audit events for failed variable fetches and updates.

## [0.8.0] - 2018-06-26
### Added
- Audit events for entitlements, variable fetches and updates, authentication and authorization.

## [0.7.0] - 2018-06-25
### Added
- Added AWS Secret Access Key Rotator

## [0.6.0] - 2018-06-25
### Added
- AWS Hosts can authenticate using their assigned AWS IAM role.
- Added variable rotation for Postgres databases
- Experimental audit querying engine mounted at /audit. It can be configured to work with
  an external audit database by using config.audit_database configuration entry.
- API endpoints for granting and revoking role membership
- API endpoint for the role graph
- Paging parameters (`offset` and `limit`) for audit API endpoints

### Changed
- RolesController#index now accepts `role` as a query parameter. If
  present, resources visible to that role are listed.
- Resources are now only visible if the user is a member of a role that owns them or has some
  permission on them.
- RolesController now implements #direct_memberships to return the
  direct members of a role, without recursive expansion.
- Updated Ruby version from 2.2, which is no longer supported, to version 2.5.
- RolesController now implements #members to return a searchable, pageable collection
  of members of a Role.

## [0.4.0] - 2018-04-10
### Added
- Policy changes now generate audit log messages. These can optionally be generated in RFC5424
  format and pushed to a UNIX socket for further processing.
- Code of Conduct

## [0.3.0] - 2018-01-11
### Added
- `conjurctl wait` command is added that can be used to check if the Conjur server is ready

### Removed
- Moved Conjur docs to a [separate repo](https://github.com/cyberark/conjur-org)

## [0.2.0] - 2017-12-07
### Added
- Add `authn-local` service which issues access tokens over a Unix domain socket.

### Changed
- CTA was updated

### Fixed
- Resolved bug: Policy replace can fail when user is deleted and removed from group

## [0.1.1] - 2017-12-04
### Changed
- Build scripts now look at git tags to determine version and tags to use.

### Fixed
- When a policy is loaded which references a non-existant object, that error is now reported as a JSON-formatted 404 error rather than an ugly 500 error.

## 0.1.0 - 2017-12-04
### Added
- The first tagged version.

[Unreleased]: https://github.com/cyberark/conjur/compare/v1.11.4...HEAD
[1.11.4]: https://github.com/cyberark/conjur/compare/v1.11.3...v1.11.4
[1.11.3]: https://github.com/cyberark/conjur/compare/v1.11.2...v1.11.3
[1.11.2]: https://github.com/cyberark/conjur/compare/v1.11.1...v1.11.2
[1.11.1]: https://github.com/cyberark/conjur/compare/v1.11.0...v1.11.1
[1.11.0]: https://github.com/cyberark/conjur/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/cyberark/conjur/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/cyberark/conjur/compare/v1.8.1...v1.9.0
[1.8.1]: https://github.com/cyberark/conjur/compare/v1.7.0...v1.8.1
[1.8.0]: https://github.com/cyberark/conjur/compare/v1.7.4...v1.8.0
[1.7.4]: https://github.com/cyberark/conjur/compare/v1.7.3...v1.7.4
[1.7.3]: https://github.com/cyberark/conjur/compare/v1.7.2...v1.7.3
[1.7.2]: https://github.com/cyberark/conjur/compare/v1.7.1...v1.7.2
[1.7.1]: https://github.com/cyberark/conjur/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/cyberark/conjur/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/cyberark/conjur/compare/v1.5.1...v1.6.0
[1.5.1]: https://github.com/cyberark/conjur/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/cyberark/conjur/compare/v1.4.7...v1.5.0
[1.4.7]: https://github.com/cyberark/conjur/compare/v1.4.6...v1.4.7
[1.4.6]: https://github.com/cyberark/conjur/compare/v1.4.5...v1.4.6
[1.4.5]: https://github.com/cyberark/conjur/compare/v1.4.4...v1.4.5
[1.4.4]: https://github.com/cyberark/conjur/compare/v1.4.3...v1.4.4
[1.4.3]: https://github.com/cyberark/conjur/compare/v1.4.2...v1.4.3
[1.4.2]: https://github.com/cyberark/conjur/compare/v1.4.1...v1.4.2
[1.4.1]: https://github.com/cyberark/conjur/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/cyberark/conjur/compare/v1.3.7...v1.4.0
[1.3.7]: https://github.com/cyberark/conjur/compare/v1.3.6...v1.3.7
[1.3.6]: https://github.com/cyberark/conjur/compare/v1.3.5...v1.3.6
[1.3.5]: https://github.com/cyberark/conjur/compare/v1.3.4...v1.3.5
[1.3.4]: https://github.com/cyberark/conjur/compare/v1.3.3...v1.3.4
[1.3.3]: https://github.com/cyberark/conjur/compare/v1.3.2...v1.3.3
[1.3.2]: https://github.com/cyberark/conjur/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/cyberark/conjur/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/cyberark/conjur/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/cyberark/conjur/compare/v1.1.2...v1.2.0
[1.1.2]: https://github.com/cyberark/conjur/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/cyberark/conjur/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/cyberark/conjur/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/cyberark/conjur/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/cyberark/conjur/compare/v0.9.0...v1.0.0
[0.9.0]: https://github.com/cyberark/conjur/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/cyberark/conjur/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/cyberark/conjur/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/cyberark/conjur/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/cyberark/conjur/compare/v0.3.0...v0.6.0
[0.3.0]: https://github.com/cyberark/conjur/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/cyberark/conjur/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/cyberark/conjur/compare/v0.1.0...v0.1.1
