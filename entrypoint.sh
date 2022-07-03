#!/bin/bash

cd ${RAILS_ROOT}

echo "========== Start: `date` =========="

rm -f tmp/pids/server.pid


echo "========== bundle install =========="
unset BUNDLE_APP_CONFIG BUNDLE_PATH BUNDLE_BIN
bundle install

cd ./frontend

echo "========== yarn install =========="
yarn install

echo "========== yarn watch =========="
yarn watch &

cd ..

echo "========== Start rails server =========="
bundle exec rails server -p 3012 -b '0.0.0.0'

echo "========== Done: `date` =========="
touch log/development.log
tail -f log/development.log
