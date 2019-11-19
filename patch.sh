#!/bin/bash

#if [ -f /autowx2/autowx2.py ]; then
#	sed -i 's/app, port/app, host="0.0.0.0", port/g' /autowx2/autowx2.py
#	echo Patch Flask Start Command successful.
#fi

sed -i 's/#gzip on/gzip on/g' /etc/nginx/nginx.conf

echo 'find $wwwDir/ -name "*.html" | xargs sed -i "s/\"\/\//\"\/lastlog\//g"' >> /autowx2/bin/gen-static-page.sh

sed -i '46 i<li class="nav-item"><a class="nav-link" href="/">Run Log</a></li>'  /autowx2/var/www/index.tpl 

sed -i 's/href="\/lastlog"/href="\/lastlog\/"/g' /autowx2/var/flask/templates/index.html

sed -i 's/text\/plain/text\/css/g' /etc/nginx/mime.types

sed -i 's/tempdir="\/tmp"/tempdir="\/dev\/shm"/g' /autowx2/bin/dump1090-draw_heatmap.sh

echo '$baseDir/bin/gen-static-page.sh' >> /autowx2/modules/iss/iss_voice_mp3.sh

#sed -i 's/heatmap-osm.jpg/heatmap-osm.png/g' /autowx2/bin/gen-static-page.sh

#sed -i 's/heatmap-osm2.jpg/heatmap-osm2.png/g' /autowx2/bin/gen-static-page.sh

echo "ls -1 \$ourdir/*.png | xargs -n 1 bash -c 'convert \"$0\" \"${0%.png}.jpg\"'" >> /autowx2/bin/dump1090-draw_heatmap.sh

echo "rm $outdir/*.png" >> /autowx2/bin/dump1090-draw_heatmap.sh

sed -i 's/database="\$baseDir\/recordings\/dump1090\/adsb_messages\.db"/database="\$baseDir\/var\/www\/recordings\/dump1090\/adsb_messages\.db"/g' /autowx2/bin/dump1090.sh

sed -i 's/database="\$baseDir\/recordings\/dump1090\/adsb_messages\.db"/database="\$baseDir\/var\/www\/recordings\/dump1090\/adsb_messages\.db"/g' /autowx2/bin/dump1090-draw_heatmap.sh

sed -i 's/outdir="\$baseDir\/recordings\/dump1090\/"/outdir="\$baseDir\/var\/www\/recordings\/dump1090\/"/g' /autowx2/bin/dump1090-draw_heatmap.sh

sed -i 's/^rm $recdir\/$fileNameCore\.wav/#rm $recdir\/$fileNameCore\.wav/g' /autowx2/modules/noaa/noaa_process.sh

find /root/mlrpt -name "*.cfg" | xargs sed -i "s/Default (\/home\/<user>\/mlrpt\/images\/)/Default (\/autowx2\/var\/www\/recordings\/meteor\/raw\/)/g"
find /root/mlrpt -name "*.cfg" | xargs sed -i "s/^#RTL-SDR/RTL-SDR/g" 
find /root/mlrpt -name "*.cfg" | xargs sed -i "s/^AIRSPY/#AIRSPY/g"
find /root/mlrpt -name "*.cfg" | xargs sed -i "s/^#288000/288000/g"
find /root/mlrpt -name "*.cfg" | xargs sed -i "s/^2500000/#2500000/g"
sed -i 's/rawImageDir="\/meteor\/img\/raw\/"/rawImageDir="\/autowx2\/var\/www\/recordings\/meteor\/raw\/"/g' /autowx2/modules/meteor-m2/meteor.conf.example

aaa=$(crontab -l | grep update-keps.sh | wc -l)
if [ $aaa -eq 0 ]; then
	echo "0 4 * * * /autowx2/bin/update-keps.sh 1> /dev/null 2>/dev/null" >> /var/spool/cron/root
	echo "0 0 * * * /autowx2/bin/crontab/daily.sh" >> /var/spool/cron/root
	echo "0 0 * * 1 /autowx2/bin/crontab/weekly.sh" >> /var/spool/cron/root
	crontab /var/spool/cron/root
fi

#echo "deb http://ftp.de.debian.org/debian sid main " >> /etc/apt/sources.list && apt-get update
#apt-get install -y dump1090-mutability 
#ln -s /usr/bin/dump1090-mutability /usr/bin/dump1090

#cd /tmp
#git clone https://github.com/mutability/dump1090.git -b unmaintained
#cd /tmp/dump1090
#apt-get install -y debhelper
#dpkg-buildpackage -b

cd /tmp
dpkg -i dump1090-mutability_1.15~dev_amd64.deb << EOF
no
EOF

rm -rf /tmp/dump1090*
ln -s /usr/bin/dump1090-mutability /usr/bin/dump1090

wxtoimg << EOF
YES
EOF

exit 0
