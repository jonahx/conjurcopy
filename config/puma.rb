# frozen_string_literal: true

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

# [Added Aug 8, 2018]
# With large policy files, the request can exceed the 1
# minute default worker timeout. We've increased it to
# 10 minutes as a stopgap until we determine the root
# cause and implement a permanent solution.
worker_timeout 600

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

# Logging the FIPS mode needs to happen in the `before_fork` callback to ensure
# that the Rails and domain libraries have been loaded. Otherwise this will
# fail when started as a `puma` command, rather than using `rails server`.
before_fork do
  Rails.logger.info(LogMessages::Conjur::FipsModeStatus.new(OpenSSL.fips_mode))
end

on_worker_boot do
  # https://groups.google.com/forum/#!topic/sequel-talk/LBAtdstVhWQ
  Sequel::Model.db.disconnect
end

