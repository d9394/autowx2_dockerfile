#This file is also on building and testing, Not complete.
FROM debian:stretch-slim

RUN apt-get update -y
RUN apt-get install -y git wget sudo make gcc python python-pip qt5-default cron nginx-light
WORKDIR /
RUN git clone --depth 1 https://github.com/filipsPL/autowx2.git -b devel-new-config
WORKDIR /autowx2
RUN chmod +x ./*.sh ./bin/*.sh
RUN ./install.sh

RUN git clone https://github.com/asdil12/pymultimonaprs.git
WORKDIR /autowx2/pymultimonaprs
RUN python setup.py install
#https://github.com/filipsPL/autowx2/wiki/meteor-m2
RUN wget -P /tmp http://www.5b4az.org/pkg/lrpt/mlrpt-1.6.2.tar.bz2
WORKDIR /tmp
RUN tar -xvf mlrpt-1.6.2.tar.bz2
WORKDIR /tmp/mlrpt-1.6.2
RUN ./autogen.sh && ./configure && make && make install
#./configure CFLAGS="-g -O2"
RUN cp -r mlrpt /root
WORKDIR /tmp
RUN rm -rf mlrtp-1.6.2

RUN apt-get install -y cmake doxygen debhelper
WORKDIR /tmp
RUN git clone https://github.com/merbanan/rtl_433.git
WORKDIR /tmp/rtl_433/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN rm -rf rtl_433

RUN git clone https://github.com/mutability/dump1090.git -b unmaintained
WORKDIR /tmp/dump1090
#RUN apt-get install debhelper
RUN dpkg-buildpackage -b

RUN wget -P /autowx2/bin https://raw.githubusercontent.com/andrewl/autowx2/master/bin/dump1090-draw_heatmap.sh
RUN wget -P /autowx2/bin https://raw.githubusercontent.com/andrewl/autowx2/master/bin/dump1090-stream-parser.py
RUN wget -P /autowx2/bin https://raw.githubusercontent.com/andrewl/autowx2/master/bin/dump1090.sh
RUN chmod +x /autowx2/bin/*.*

RUN pip install tendo osmviz

RUN apt-get install -y vim-tiny procps net-tools

ADD ./default /etc/nginx/sites-enabled/

ADD ./patch.sh /
RUN /patch.sh
#RUN rm -f /patch.sh

VOLUME [ "/config" ]
ADD ./autowx2.sh /
CMD [ "/autowx2.sh","run" ]
EXPOSE 5050
