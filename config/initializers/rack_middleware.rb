require 'rack/default_content_type'

# This is where we introduce custom middleware that interacts with Rack
# and Rails to change how requests are handled.
Rails.application.configure do

  # This configures which paths do and do not require token authentication.
  # Token authentication is optional for authn routes, and it's not applied at
  # all to authentication, host factories, or static assets (e.g. images, CSS)
  config.middleware.use(Conjur::Rack::Authenticator,
  optional: [
    /^\/authn-[^\/]+\//,
    /^\/authn\//,
    /^\/public_keys\//
  ],
  except: [
    /^\/authn-[^\/]+\/.*\/authenticate$/,
    /^\/authn\/.*\/authenticate$/,
    /^\/host_factories\/hosts$/,
    /^\/assets\/.*/,
    /^\/authenticators$/,
    /^\/$/
  ])

  # We want to ensure requests have an expected content type
  # before other middleware runs to make sure any body parsing
  # attempts are handled correctly. So we add this middleware
  # to the start of the Rack middleware chain.
  config.middleware.insert_before(0, ::Rack::DefaultContentType)

  # Deleting the RemoteIp middleware means that `request.remote_ip` will
  # always be the same as `request.ip`. This ensure that the Conjur request log
  # (using `remote_ip`) and the audit log (using `ip`) will have the same value
  # for each request.
  config.middleware.delete ActionDispatch::RemoteIp
end
