include ../util.mk
DOCKER_VERSION := 17.06.0-ce

all: ../download/docker.tar.gz
	tar xf ../download/docker.tar.gz
	mkdir root/bin
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

$(eval $(call cache,\
https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker.tar.gz, \
e582486c9db0f4229deba9f8517145f8af6c5fae7a1243e6b07876bd3e706620))
