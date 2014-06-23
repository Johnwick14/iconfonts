srcfiles = $(wildcard src/*.json)
stylfiles = $(patsubst src/%.json, stylesheets/%.styl, ${srcfiles})
sassfiles = $(patsubst src/%.json, stylesheets/%.sass, ${srcfiles})
lessfiles = $(patsubst src/%.json, stylesheets/%.less, ${srcfiles})

all: ${stylfiles} ${sassfiles} support/icons.json

stylesheets/%.styl: src/%.json
	@echo + $@
	@node support/build.js "$<" support/stylus.tpl > $@

stylesheets/%.sass: src/%.json
	@echo + $@
	@node support/build.js "$<" support/sass.tpl > $@

stylesheets/%.less: src/%.json
	@echo + $@
	@node support/build.js "$<" support/less.tpl > $@

support/icons.json: ${srcfiles}
	@echo + $@
	@node support/merge.js $^ > $@
