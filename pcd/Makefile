PWD = $(shell pwd)
export GOPATH = ${PWD}

export CC = ${PWD}/../include/bin/musl-gcc

all:
	mkdir root/bin
	[ -e pcd ] \
	|| ( go get -d -v -u github.com/brimstone/go-pcd \
	&& cd ${GOPATH}/src/github.com/brimstone/go-pcd \
	&& make \
	&& mv pcd ${PWD} )
	mv pcd ${PWD}/root/bin
	tar -cf out.tar -C root .

