.PHONY: build

CS=node_modules/coffee-script/bin/coffee
VERSION=`$(CS) build/bumper.coffee --version`

bump.minor:
	@$(CS) build/bumper.coffee --minor

bump.major:
	@$(CS) build/bumper.coffee --major

bump.patch:
	@$(CS) build/bumper.coffee --patch

watch:
	$(CS) -wmco lib src

build:
	$(CS) -mco lib src

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