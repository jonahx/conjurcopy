#!/bin/bash

# Script to run generate_report.rb within docker so that the gems don't
# need to be installed locally.
# generate_report.rb generates an html report from simplecov json output.

set -xeu

IMAGE="ruby:2.6.5-stretch"

REPO_ROOT=$(git rev-parse --show-toplevel)

# Use the first arg, or if not supplied use the simplecov default report location
REPORT_FILE="${1:-${REPO_ROOT}/coverage/.resultset.json}"

docker run \
    --rm \
    --volume "${REPO_ROOT}":"${REPO_ROOT}" \
    --workdir "${REPO_ROOT}/ci/coverage-report-generator" \
    "${IMAGE}" \
    bash -cex "
      gem install bundler -v 2.1.4 
      bundle config set path 'gems'
      bundle install
      bundle exec ./generate_report.rb '${REPO_ROOT}' '${REPORT_FILE}'"
