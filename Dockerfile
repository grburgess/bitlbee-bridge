FROM debian:buster
MAINTAINER Daniel da Silva <mail@danieldasilva.org>

# Make & install
RUN apt-get update
RUN apt-get install bitlbee-dev bitlbee-libpurple bitlbee-plugin-otr git autoconf build-essential autoproject libtool glib2.0 glib2.0-dev cmake libpurple-dev libjson-glib-dev -y
RUN cd tmp && git clone https://github.com/sm00th/bitlbee-discord.git && cd bitlbee-discord && ./autogen.sh && ./configure && make && make install


RUN git clone --recurse-submodules https://github.com/hoehermann/purple-signald.git purple-signald && mkdir -p purple-signald/build && cd purple-signald/build && cmake .. && make && make install

RUN mkdir -p /var/signald/run && chown -R bitlbee /var/signald/run
VOLUME ["/var/signald/run"]

# Bitlbee config
EXPOSE 6667
VOLUME ["/var/lib/bitlbee"]
COPY config/bitlbee.conf /etc/bitlbee/bitlbee.conf
WORKDIR /
RUN chown -R bitlbee /var/lib/bitlbee/

ENTRYPOINT chown -R bitlbee /var/lib/bitlbee && /usr/sbin/bitlbee -n -c /etc/bitlbee/bitlbee.conf

