include ../util.mk
DOCKER_VERSION := 1.13.0
DOCKER_CHANNEL := get

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://${DOCKER_CHANNEL}.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
fc194bb95640b1396283e5b23b5ff9d1b69a5e418b5b3d774f303a7642162ad6))
