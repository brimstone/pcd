all:
	echo "NAME=PCD" > root/etc/os-release
	echo "VERSION=${PCD_VERSION}" >> root/etc/os-release
	echo "ID=pcd" >> root/etc/os-release
	echo "VERSION_ID=${PCD_VERSION}" >> root/etc/os-release
	echo "PRETTY_NAME=\"PCD ${PCD_VERSION}\"" >> root/etc/os-release
	tar -cf out.tar -C root .
