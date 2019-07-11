include ../util.mk
DOCKER_VERSION := 18.09.7

all: ../download/docker-${DOCKER_VERSION}.tar.gz root/etc/ssl/certs/docker.hub.pem root/etc/ssl/certs/docker.registry.pem
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/* root/bin
	chown -R 0:0 root/bin
	tar -cf out.tar -C root .

root/etc/ssl/certs/docker.hub.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect production.cloudflare.docker.com:443 -showcerts \
		2>&1 </dev/null \
	| awk '/BEGIN/,/END/' > root/etc/ssl/certs/docker.hub.pem

root/etc/ssl/certs/docker.registry.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect registry-1.docker.io:443 -showcerts \
		2>&1 </dev/null \
	| awk '/BEGIN/,/END/' > root/etc/ssl/certs/docker.registry.pem

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
e106ccfa2b1f60794faaa6bae57a2dac9dc4cb33e5541fad6a826ea525d01cc4)) #docker
