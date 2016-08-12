include ../util.mk
DOCKER_VERSION := 1.12.0
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
3dd07f65ea4a7b4c8829f311ab0213bca9ac551b5b24706f3e79a97e22097f8b))
