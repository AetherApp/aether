#!/bin/bash

DOCKER_ORG="aethercloud"

if [[ -z "${CI}" ]]; then
	echo "This script is for running in the CI only!"
	exit 1
fi

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Build images
docker build -t $DOCKER_ORG/aether .
retVal=$?
if [ $retVal -ne 0 ]; then
	echo "Failed to build aether."
	exit $retVal
fi

docker build -t $DOCKER_ORG/frontend ./frontend
retVal=$?
if [ $retVal -ne 0 ]; then
	echo "Failed to build aether frontend."
	exit $retVal
fi

# Push them to the docker hub
docker push $DOCKER_ORG/aether
retVal=$?
if [ $retVal -ne 0 ]; then
	echo "Failed to push aether."
	exit $retVal
fi

docker push $DOCKER_ORG/frontend
retVal=$?
if [ $retVal -ne 0 ]; then
	echo "Failed to push aether frontend."
	exit $retVal
fi
