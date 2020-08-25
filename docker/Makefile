include ../util.mk
DOCKER_VERSION := 19.03.9

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
	| tac \
	| awk '/END/ {f=1} f==1 {print} NR>1 && /BEGIN/ {exit}' \
	| tac > $@

root/etc/ssl/certs/docker.hub.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect production.cloudflare.docker.com:443 -showcerts \
		2>&1 </dev/null \
	| tac \
	| awk '/END/ {f=1} f==1 {print} NR>1 && /BEGIN/ {exit}' \
	| tac > $@

root/etc/ssl/certs/docker.registry.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect registry-1.docker.io:443 -showcerts \
		2>&1 </dev/null \
	| tac \
	| awk '/END/ {f=1} f==1 {print} NR>1 && /BEGIN/ {exit}' \
	| tac > $@

$(eval $(call cache,\
https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_VERSION}.tgz, \
../download/docker-${DOCKER_VERSION}.tar.gz, \
1c03c78be198d9085e7dd6806fc5d93264baaf0c7ea17f584d00af48eae508ee)) #docker
