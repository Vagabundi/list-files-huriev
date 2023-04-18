#!/bin/bash

ACTION=$1
APP_NAME="web"
WAR_FILE="web.war"
TOMCAT="/opt/tomcat"

# tomcat existance check
if [[ ! -d "$TOMCAT" ]]; then
  echo "Tomcat directory not found: $TOMCAT"
  exit 1
fi

# action check 
if [[ -z "$ACTION" ]]; then
  echo "Usage: $0 <dep|undep> "
  exit 1
fi

# check for war file existance
if [[ ! -f "$WAR_FILE" ]]; then
  echo "War file $WAR_FILE not found"
  exit 1
fi

# script deploying scenario with command sudo bash deployer.sh dep 
if [[ "$ACTION" == "dep" ]]; then
  if [[ $(ps aux | grep tomcat | wc -l) -gt 1 ]]; then
    echo "Tomcat is already running"
  else
    echo "Starting Tomcat..."
    "$TOMCAT/bin/startup.sh"
    if [[ $(ps aux | grep tomcat | wc -l) -gt 1 ]]; then
      echo "Tomcat started successfully"
    else
      echo "Tomcat startup failed"
      exit 1
    fi
  fi

  if [[ ! -d "$TOMCAT/webapps" ]]; then
    echo "Tomcat webapps directory not found: $TOMCAT/webapps"
    exit 1
  fi


  CONTEXT_NAME=$(echo "$APPNAME" | sed 's/[^A-Za-z0-9.-]/_/g')
  cp "$WAR_FILE" "$TOMCAT/webapps/$CONTEXT_NAME.war"
  sleep 5

  if [[ -d "$TOMCAT/webapps/$CONTEXT_NAME" ]]; then
    echo "Application deployed successfully at http://localhost:8080/$CONTEXT_NAME/"
  else
    echo "Application deployed unsuccessfully"
    exit 1
  fi
  
# script undeploying scenario with command sudo bash deployer.sh undep 
elif [[ "$ACTION"=="undep" ]]; then
  CONTEXT_NAME=$(echo "$APPNAME" | sed 's/[^A-Za-z0-9.-]/_/g')
  
  rm -rf "$TOMCAT/webapps/$CONTEXT_NAME" "$TOMCAT/webapps/$CONTEXT_NAME.war"
  if [[ ! -d "$TOMCAT/webapps/$CONTEXT_NAME" ]]; then
    echo "Application undeployed successfully"
  else
    echo "Application undeployment failed"
    exit 1
  fi
fi
