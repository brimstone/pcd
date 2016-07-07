PWD = $(shell pwd)
export GOPATH = ${PWD}

#export CC = ${PWD}/../include/bin/musl-gcc

all:
	go get -d -v -u github.com/brimstone/go-pcd
	mkdir root/bin
	go build -v -a -installsuffix cgo \
		-ldflags="-linkmode external -extldflags \"-static\" -s -w" \
		-o root/bin/pcd \
		github.com/brimstone/go-pcd
	file root/bin/pcd
	tar -cf out.tar -C root .
	
