#!/bin/bash
waitingForKeycloakEndpoint=true

while $waitingForKeycloakEndpoint; do
  if [[ $(curl --head --write-out %{http_code} --silent --output /dev/null http://localhost:8084/auth) != 303 ]]
  then
    echo "wait 30 seconds before potentially continuing init scripts"
    sleep 30
  else
    waitingForKeycloakEndpoint=false

    /opt/fdk/tools/update-realms.sh

  fi

done &