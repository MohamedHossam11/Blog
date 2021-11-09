#!/bin/bash
set -e

#Rails server.get rid of pid file
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate
echo "Done preparing database!"


#Run the main process of the container(What is set as CMD in the Dockerfile)。
exec "$@"
