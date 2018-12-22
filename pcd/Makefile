PWD = $(shell pwd)
export GOPATH = ${PWD}

export CC = ${PWD}/../include/bin/musl-gcc

all: root/etc/ssl/certs/sprinkle.cloud.pem
	mkdir root/bin
	[ -e pcd ] \
	|| ( go get -d -v -u github.com/brimstone/go-pcd \
	&& cd ${GOPATH}/src/github.com/brimstone/go-pcd \
	&& make \
	&& mv pcd ${PWD} )
	mv pcd ${PWD}/root/bin
	tar -cf out.tar -C root .

root/etc/ssl/certs/sprinkle.cloud.pem:
	mkdir -p root/etc/ssl/certs/
	openssl s_client -connect sprinkle.cloud:443 -showcerts \
		2>&1 </dev/null \
	| awk '/BEGIN/,/END/' > root/etc/ssl/certs/sprinkle.cloud.pem

