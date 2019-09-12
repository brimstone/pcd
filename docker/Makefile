include ../util.mk
DOCKER_VERSION := 19.03.1

all: ../download/docker-${DOCKER_VERSION}.tar.gz root/etc/ssl/certs/docker.hub.pem root/etc/ssl/certs/docker.registry.pem root/etc/ssl/certs/k8s.gcr.io.pem
	tar xf ../download/docker-${DOCKER_VERSION}.tar.gz
	mkdir root/bin
	mv docker/* root/bin
	chown -R 0:0 root/bin
	tar -cf out.tar -C root .

# k8s.gcr.io
root/etc/ssl/certs/k8s.gcr.io.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect k8s.gcr.io:443 -showcerts \
		2>&1 </dev/null \
	| awk '/BEGIN/,/END/' > $@

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
6e7d8e24ee46b13d7547d751696d01607d19c8224c1b2c867acc8c779e77734b)) #docker
