include ../util.mk
DOCKER_VERSION := 1.12.2
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
cb30ad9864f37512c50db725c14a22c3f55028949e4f1e4e585a6b3c624c4b0e))
