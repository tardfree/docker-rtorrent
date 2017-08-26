#!/bin/sh

mkdir -p /config/rutorrent
mkdir -p /config/rtorrent

mkdir -p /downloads/incoming
mkdir -p /downloads/session
mkdir -p /downloads/drop


# check if config exists in /config, copy if not
if [ ! -e /config/rutorrent/config.php ]; then
    cp /usr/share/webapps/rutorrent/conf/config.php.backup /config/rutorrent/config.php
    sed -i \
        -e "/curl/ s/''/'\/usr\/bin\/curl'/" \
        -e "/php/ s/''/'\/usr\/bin\/php7'/" \
        /config/rutorrent/config.php
fi
cp -f /config/rutorrent/config.php /usr/share/webapps/rutorrent/conf/config.php

###Clean up needed here
###if [ ! -e /config/rtorrent/rtorrent.rc ]; then
###	cp /usr/share/doc/rtorrent/rtorrent.rc /config/rtorrent/rtorrent.rc
###	ln -s /config/rtorrent/rtorrent.rc /home/rtorrent/.rtorrent.rc
###
###    sed -i \
###        -e "s/^#directory = .\//directory = \.\//\/downloads/incoming" \
###        -e "s/^#session = .\/session/session = \.\//\/downloads\/session/" \
###        -e "s/^#session = .\/session/session = \.\//\/downloads\/session/" \
###        -e "s/^# encryption = .*/encryption = allow_incoming,try_outgoing,enable_retry/" \
###        -e "s/^#port_range = .*/port_range = 58331/" \
###        -e "s/^#port_range = .*/port_range = 58331/" \
###        /config/rtorrent/rtorrent.rc
###
####watchdir support comes in 0.9.7+ so could revise then
####        -e "s/^#directory.watch.added = .*/directory.watch.added = \.\//\/downloads\/drop/" \
###
###fi


## launch 
rm -f /downloads/session/rtorrent.lock
rtorrent
