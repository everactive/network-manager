# NOTE: you may need to tweak the ssh hey that is compatible with the image
ssh_opts=\
	-i $(HOME)/.ssh/id_rsa \
	-oStrictHostKeyChecking=no \
	-oUserKnownHostsFile=/dev/null \
	-oKbdInteractiveAuthentication=no

install:
	while sleep 10s; do ssh $(ssh_opts) -p 8022 ubuntu@localhost true && break; done
	scp $(ssh_opts) -P 8022 *.snap 'ubuntu@localhost:~/'
	ssh $(ssh_opts) -p 8022 ubuntu@localhost sudo snappy install '*.snap'

clean:
	git clean -fdx .
	rm -rf parts/modemmanager parts/networkmanager
