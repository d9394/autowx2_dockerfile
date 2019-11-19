#!/bin/bash
set -euo pipefail
export PYTHONIOENCODING=utf-8

if [[ ! -f /config/autowx2_conf.py ]] ; then
  cp /autowx2/autowx2_conf.py /config/autowx2_conf.py
fi
rm -f /autowx2/autowx2_conf.py
ln -s /config/autowx2_conf.py /autowx2/autowx2_conf.py

if [[ ! -f /config/satellites.conf ]] ; then
  cp /autowx2/satellites.conf /config/satellites.conf
fi
rm -f /autowx2/satellites.conf
ln -s /config/satellites.conf /autowx2/satellites.conf

if [[ ! -f /config/noaa.conf ]] ; then
  cp -f /autowx2/modules/noaa/noaa.conf.example /config/noaa.conf
fi
rm -f /autowx2/modules/noaa/noaa.conf
ln -s /config/noaa.conf /autowx2/modules/noaa/noaa.conf

if [[ ! -f /config/meteor.conf ]] ; then
  cp -f /autowx2/modules/meteor-m2/meteor.conf.example /config/meteor.conf
fi
rm -f /autowx2/modules/meteor-m2/metero.conf
ln -s /config/meteor.conf /autowx2/modules/meteor-m2/meteor.conf

aaa=$(cat /autowx2/autowx2_conf.py | grep "aprs_freq" | grep -Eo '[0-9]{9}')
if [ "$aaa" != "" ]; then
	sed -i "s/144800000/$aaa/g" /autowx2/bin/aprs.sh
	echo Patch aprs.sh successful.
fi

aaa=$(cat /autowx2/autowx2_conf.py | grep "webInterfacePort" | grep -Eo '[0-9]{1,5}')
if [ "$aaa" == "" ]; then
	aaa="5010"
	echo "webInterfacePort = $aaa" >> /config/autowx2_conf.py
fi
sed -i "s/%WebInterface%/$aaa/g" /etc/nginx/sites-enabled/default
echo Patch nginx webinterfaceport successful.

aaa=$(cat /autowx2/autowx2_conf.py | grep "NginxListenPort" | grep -Eo '[0-9]{1,5}')
if [ "$aaa" == "" ]; then
	aaa="5050"
	echo "NginxListenPort = $aaa" >> /config/autowx2_conf.py
fi
sed -i "s/%NginxPort%/$aaa/g" /etc/nginx/sites-enabled/default
echo Patch nginx port successful.

mkdir -p /autowx2/var/www/recordings/noaa/img
mkdir -p /autowx2/var/www/recordings/iss/rec
mkdir -p /autowx2/var/www/recordings/meteor/raw
mkdir -p /autowx2/var/www/recordings/dump1090
#touch /autowx2/var/www/recordings/index.html
chmod 755 -R /autowx2/var/www/recordings/iss/rec

#. /autowx2/bin/update-keps.sh
/etc/init.d/nginx restart
/etc/init.d/cron restart
cd /autowx2/bin
./gen-static-page.sh

if [ "$1" != "test" ]; then
	_term() {
	  echo "Caught signal!" 
	  kill -TERM "$child" 2>/dev/null
	}
		
	trap _term SIGTERM SIGINT

	cd /autowx2
	python ./autowx2.py &

	child=$! 
	wait "$child"
else
	echo You are now in test mode.
fi    
