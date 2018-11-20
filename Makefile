COMPOSER_VERSION ?= `curl -s https://getcomposer.org/ | awk -F'class="|"' '/class/ && /'"latest"'/  {print $4}' | sed 's/<[^>]*>//g' | awk '{print $$2}' | sed 's/v//g'`

latest:
	curl -s https://getcomposer.org/ | awk -F'class="|"' '/class/ && /'"latest"'/  {print $4}' | sed 's/<[^>]*>//g' | awk '{print $$2}' | sed 's/v//g'

default: composer package

composer: clean
	@curl -sS https://getcomposer.org/installer | php -- --version=$(COMPOSER_VERSION)$
	@mkdir -p debian/usr/bin
	@cp composer.phar debian/usr/bin/composer

package:
	@sed "s/{{ VERSION }}/$(COMPOSER_VERSION)-4/g" debian/DEBIAN/control.default > debian/DEBIAN/control
	@fakeroot make finish

finish:
	@chown -R root:root debian
	@dpkg-deb --build debian .

clean:
	@rm -rf debian/usr
	@rm -f *.deb
	@rm -f composer.phar

.PHONY: default
