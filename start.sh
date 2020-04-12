#!/bin/bash
DOCKER_CONTAINER_PORT='56733'
DOCKER_IMAGE_NAME='docker.test'

while getopts n:p: option; do
	case "${option}" in
		n) DOCKER_IMAGE_NAME=${OPTARG};;
		p) DOCKER_CONTAINER_PORT=${OPTARG};;
	esac
done

docker stop ${DOCKER_IMAGE_NAME} || echo 'Cannot stop container'
docker rm ${DOCKER_IMAGE_NAME} || echo 'Cannot remove container'
docker build -t ${DOCKER_IMAGE_NAME} .
docker run -d -p ${DOCKER_CONTAINER_PORT}:80 --name=${DOCKER_IMAGE_NAME} -v $PWD:/app ${DOCKER_IMAGE_NAME}