include ../util.mk
DOCKER_VERSION := 1.12.0-rc4
DOCKER_CHANNEL := test

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
fca3e76267d5dc9f6f9d42341c7daf525032a322e2ae16f0e69d71541abb6b6d))
