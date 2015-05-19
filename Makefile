build: clean
	mkdir -p tmp/puppet
	cp -r manifests tmp/puppet
	cp -r files tmp
	cp Puppetfile* tmp/puppet
	cd tmp/; tar czf puppet-code.tgz puppet/
	cd tmp/; tar czf files.tgz files/

deploy: build
	scp bootstrap.sh root@$(HOST):/tmp
	scp tmp/puppet-code.tgz root@$(HOST):/tmp
	scp tmp/files.tgz root@$(HOST):/tmp

dev-deploy: build
	bash dev-deploy.sh

clean:
	rm -rf tmp/
