include ../util.mk
DOCKER_VERSION := 18.01.0-ce

all: ../download/docker-${DOCKER_VERSION}.tar.gz
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
c61ec5b86a721c65371a38e8fbf831e04b58c6e845289282dfa596790ccae8da))
