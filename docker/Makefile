include ../util.mk
DOCKER_VERSION := 1.12.1
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
05ceec7fd937e1416e5dce12b0b6e1c655907d349d52574319a1e875077ccb79))
