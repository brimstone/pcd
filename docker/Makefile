include ../util.mk
DOCKER_VERSION := 18.05.0-ce

all: ../download/docker-${DOCKER_VERSION}.tar.gz
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
73bfe6b53949fa01168e9b5688d7a0f8ab7987b94911ca09e0cceb11aff14fab)) #docker
