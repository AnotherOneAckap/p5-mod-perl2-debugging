DIR=$(CURDIR)

BUILD_DIR=${DIR}/build

start:
	APACHE_LOG_DIR=${DIR} APACHE_PID_FILE=${DIR}/apache2.pid apache2 -DPERLDB -X -f ${DIR}/httpd.conf -e debug

stop:
	ps aux | grep apache2 | awk '{ print $$2 }' | xargs kill

test:
	curl "http://localhost:8080/"

install: install_apache2 install_mod_perl install_apache_db install_devel_debug_hooks

install_apache2:
	apt install -y apache2 apache2-dev;
	locale-gen ru_RU.UTF-8;
	update-locale;

install_mod_perl:
	if [ ! -d ${BUILD_DIR} ]; then mkdir ${BUILD_DIR}; fi; \
	cd ${BUILD_DIR}; \
	if [ ! -e mod_perl-2.0.10.tar.gz ]; then wget "http://apache-mirror.rbc.ru/pub/apache/perl/mod_perl-2.0.10.tar.gz";         fi;\
	if [ ! -d mod_perl-2.0.10 ];        then tar xvfz mod_perl-2.0.10.tar.gz;       fi;\
	cd ${BUILD_DIR}/mod_perl-2.0.10; \
	apt install -y libperl-dev; \
	ln -s /usr/lib/x86_64-linux-gnu/libgdbm.so.3.0.0 /usr/lib/x86_64-linux-gnu/libgdbm.so ;\
	perl Makefile.PL PERL_DEBUG=1 MP_DEBUG=1 MP_AP_CONFIGURE="--with-mpm=prefork"; \
	make && make install;

install_apache_db:
	cd ${BUILD_DIR}; \
	if [ ! -e Apache-DB-0.14.tar.gz ]; then wget "https://cpan.metacpan.org/authors/id/F/FW/FWILES/Apache-DB-0.14.tar.gz";     fi;\
	if [ ! -d Apache-DB-0.14 ];        then tar xvfz Apache-DB-0.14.tar.gz;        fi; \
	cd Apache-DB-0.14; \
	perl Makefile.PL; \
	make && make test && make install;

install_devel_debug_hooks:
	apt install -y libtest-output-perl libdata-section-simple-perl libtest-differences-perl libio-async-perl cpanminus
	cpanm Scope::Cleanup Sub::Metadata Test::CheckDeps Data::Dump
	cd ${BUILD_DIR}; \
	if [ ! -e Devel-DebugHooks-0.05.tar.gz ]; then wget "https://cpan.metacpan.org/authors/id/K/KE/KES/Devel-DebugHooks-0.05.tar.gz"; fi;\
	if [ ! -d Devel-DebugHooks-0.05 ];        then tar xvfz Devel-DebugHooks-0.05.tar.gz; fi;\
	cd Devel-DebugHooks-0.05; \
	touch bin/analizer.pl;\
	perl Makefile.PL; \
	make && make test && make install;
