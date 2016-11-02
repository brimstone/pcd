include ../util.mk
DOCKER_VERSION := 1.12.3
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f))
