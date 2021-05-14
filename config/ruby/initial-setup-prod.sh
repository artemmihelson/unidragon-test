#!/bin/bash

export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=true
export EDITOR="nano --wait"

cd /unidragon-service
cat /dev/null > tmp/pids/server.pid

bin/bundle check || bin/bundle install
bin/rails credentials:edit
bin/rails server --binding=unidragon-service-ruby --port 3001
