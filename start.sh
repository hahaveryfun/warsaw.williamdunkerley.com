#!/bin/bash
DOCKER_CONTAINER_PORT='56733'
DOCKER_IMAGE_NAME='docker.test'
ENVIRONMENT=''
CONFIG_NAME='default.py'
MIGRATION_FOLDER='migrations-local'

while getopts n:p:e: option; do
	case "${option}" in
		n) DOCKER_IMAGE_NAME=${OPTARG};;
		p) DOCKER_CONTAINER_PORT=${OPTARG};;
		e) ENVIRONMENT=${OPTARG};;
	esac
done

case "${ENVIRONMENT}" in
	prod.)
		CONFIG_NAME="prod.config.py"
		MIGRATION_FOLDER="migrations-prod"
		;;

	qa.)
		CONFIG_NAME="qa.config.py"
		MIGRATION_FOLDER="migrations-qa"
		;;

	dev.)
		CONFIG_NAME="dev.config.py"
		MIGRATION_FOLDER="migrations-dev"
		;;
esac
echo ${CONFIG_NAME}
echo ${MIGRATION_FOLDER}

docker stop ${DOCKER_IMAGE_NAME} || echo 'Cannot stop container'
docker rm ${DOCKER_IMAGE_NAME} || echo 'Cannot remove container'
docker stop ${DOCKER_IMAGE_NAME}.migration || echo 'Cannot stop migration container'
docker rm ${DOCKER_IMAGE_NAME}.migration || echo 'Cannot remove migration container'
docker build -t ${DOCKER_IMAGE_NAME}.migration . -f ./Dockerfiles/migrate.Dockerfile --build-arg CONFIG_NAME=${CONFIG_NAME} --build-arg MIGRATION_FOLDER=${MIGRATION_FOLDER}
docker run -d --name=${DOCKER_IMAGE_NAME}.migration --user $(id -u):$(id -g) ${DOCKER_IMAGE_NAME}.migration
docker wait ${DOCKER_IMAGE_NAME}.migration
docker rm ${DOCKER_IMAGE_NAME}.migration || echo 'Cannot remove migration container'
docker build -t ${DOCKER_IMAGE_NAME} . -f ./Dockerfiles/Dockerfile --build-arg CONFIG_NAME=${CONFIG_NAME}
docker run -d -p ${DOCKER_CONTAINER_PORT}:5000 --name=${DOCKER_IMAGE_NAME} --user $(id -u):$(id -g) ${DOCKER_IMAGE_NAME}