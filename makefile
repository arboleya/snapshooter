.PHONY: build docs

COFFEE=node_modules/coffee-script/bin/coffee
TOASTER=node_modules/coffee-toaster/bin/toaster
VERSION=`$(COFFEE) build/bumper.coffee --version`

bump.minor:
	$(COFFEE) build/bumper.coffee --minor

bump.major:
	$(COFFEE) build/bumper.coffee --major

bump.patch:
	$(COFFEE) build/bumper.coffee --patch


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