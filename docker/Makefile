include ../util.mk
DOCKER_VERSION := 18.02.0-ce

all: ../download/docker-${DOCKER_VERSION}.tar.gz
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
435f6f234a7f92a70630ee6c199a71663a8f8bf8d101d0f921f2ed457817ba04))
