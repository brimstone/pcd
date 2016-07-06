all: docker.tar.gz
	tar xf docker.tar.gz
	mv docker/docker* root/bin
	tar -cf out.tar -C root .

docker.tar.gz:
	wget https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz \
		--progress=bar:force:noscroll -O docker.tar.gz
