IMAGE_NAME=echo_server
CONTAINER_NAME=echo_server
PORT=8000

build:
	docker build -f Dockerfile -t ${IMAGE_NAME} .

deploy:
	docker run --rm -d -p ${PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}

deploy-debug:
	docker run --rm -p ${PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}

down:
	docker stop ${CONTAINER_NAME}