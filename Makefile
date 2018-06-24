DIR=$(CURDIR)

start:
	APACHE_LOG_DIR=${DIR} APACHE_PID_FILE=${DIR}/apache2.pid apache2 -X -f ${DIR}/httpd.conf -e debug

stop:
	ps aux | grep apache2 | awk '{ print $$2 }' | xargs kill

test:
	curl "http://localhost:9000/"
