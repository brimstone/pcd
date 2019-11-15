include ../util.mk
DOCKER_VERSION := 19.03.5

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
50cdf38749642ec43d6ac50f4a3f1f7f6ac688e8d8b4e1c5b7be06e1a82f06e9)) #docker
