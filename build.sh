#!/bin/sh

echo_time() {
  date +"%R $*"
}

echo_time "Building octopi"
echo_time "Running mix deps.get"
mix deps.get --only prod

echo_time "Compiling mix"
MIX_ENV=prod mix compile

echo_time "Compling assets"
MIX_ENV=prod mix assets.deploy

echo_time "Migrating database"
MIX_ENV=prod mix ecto.migrate

echo_time "Building release version"
MIX_ENV=prod mix release --overwrite

echo_time "Creating tar file"
tar -zcf canary.tar.gz _build/prod/rel/canary

echo_time "Finished build!"
echo "If systemd is managing the service then:"
echo "  sudo service octopi.service restart"
echo " "
echo "If the app is running you'll need to kill it:"
echo "   lsof -i :5000 "
echo " "
echo "   kill $pid"
echo " "
echo "To start the server you have the pass PHX_HOST and PHX_SERVER"
echo " "
echo "PHX_HOST=192.168.10.92 PHX_SERVER=true _build/prod/rel/canary/bin/canary start"
echo " "
echo "To start as a daemon run" 
echo " "
echo "PHX_HOST=192.168.10.92 PHX_SERVER=true _build/prod/rel/canary/bin/canary daemon"
