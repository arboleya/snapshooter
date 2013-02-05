.PHONY: build docs

TOASTER=node_modules/coffee-toaster/bin/toaster
CODO=node_modules/codo/bin/codo
VERSION=`coffee build/bumper --version`

watch:
	$(TOASTER) . -wd

build:
	$(TOASTER) . -c

test: build
	# TODO: add testing routine

docs.cli:
	rm -rf docs-cli
	$(CODO) cli/src -o docs-cli --title Snapshoot CLI Documentation
	cd docs-cli && python -m SimpleHTTPServer 8080

bump.minor:
	coffee build/bumper.coffee --minor

bump.major:
	coffee build/bumper.coffee --major

bump.patch:
	coffee build/bumper.coffee --patch

publish:
	git tag $(VERSION)
	git push origin $(VERSION)
	git push origin master
	npm publish

re-publish:
	git tag -d $(VERSION)
	git tag $(VERSION)
	git push origin :$(VERSION)
	git push origin $(VERSION)
	git push origin master -f
	npm publish -f