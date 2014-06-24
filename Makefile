srcfiles = $(wildcard src/*.json)
stylfiles = $(patsubst src/%.json, stylesheets/%.styl, ${srcfiles})
sassfiles = $(patsubst src/%.json, stylesheets/%.sass, ${srcfiles})
lessfiles = $(patsubst src/%.json, stylesheets/%.less, ${srcfiles})
stylus = ./node_modules/.bin/stylus
lessc = ./node_modules/.bin/lessc

all: ${stylfiles} ${sassfiles} ${lessfiles} support/icons.json

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

test: test-sass test-stylus test-less

test-stylus: stylesheets/ionicons.styl
	@npm install
	@echo test-stylus : works
	@( cat $< ) | ${stylus} >/dev/null
	@echo test-stylus : expect font-face to work
	@( cat $< ; echo "ion-font()" ) | ${stylus} | grep "src: url(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.eot" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | ${stylus} | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.woff" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | ${stylus} | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.ttf" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | ${stylus} | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.svg" >/dev/null
	@echo test-stylus : expect content to be set
	@( cat $< ; echo "div\n  ion-icon('plus')" ) | ${stylus} | grep "content: \".f2" >/dev/null

test-sass: stylesheets/ionicons.sass
	@echo test-sass : works
	@( cat $< ) | sass >/dev/null
	@echo test-sass : expect font-face to work
	@( cat $< ; echo "+ion-font()" ) | sass | grep -E "src: url(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.eot" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | sass | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.woff" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | sass | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.ttf" >/dev/null
	@( cat $< ; echo "+ion-font()" ) | sass | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.svg" >/dev/null
	@echo test-sass : expect content to be set
	@( cat $< ; echo "div\n  +ion-icon('plus')" ) | sass | grep "content: \".f2" >/dev/null

test-less: stylesheets/ionicons.less
	@echo test-less : works
	@( cat $< ) | ${lessc} - >/dev/null
	@echo test-less : expect font-face to work
	@( cat $< ; echo ".ion-font();" ) | ${lessc} - | grep -E "src: url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.eot" >/dev/null
	@( cat $< ; echo ".ion-font();" ) | ${lessc} - | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.woff" >/dev/null
	@( cat $< ; echo ".ion-font();" ) | ${lessc} - | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.ttf" >/dev/null
	@( cat $< ; echo ".ion-font();" ) | ${lessc} - | grep -E "url\(\"//code.ionicframework.com/ionicons/...../fonts/ionicons.svg" >/dev/null
	@echo test-less : expect content to be set
	@( cat $< ; echo "div:before { .ion-icon('plus'); }" ) | ${lessc} - | grep "content: \".f2" >/dev/null
