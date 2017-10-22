include ../util.mk
DOCKER_VERSION := 17.10.0-ce

all: ../download/docker-${DOCKER_VERSION}.tar.gz
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
db10b851c793845ec42d1af7be28c6cb2844d9345246607de990f429064a623e))
