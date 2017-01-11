include ../util.mk
DOCKER_VERSION := 1.12.6
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
cadc6025c841e034506703a06cf54204e51d0cadfae4bae62628ac648d82efdd))
