FROM alpine:latest
LABEL maintainer="robert@splat.cx" description="basic rtorrent container" 

#notes:
#some input from: 
# https://github.com/vSense/docker-rtorrent
# https://github.com/chamunks/alpine-rtorrent

RUN \
	apk add --no-cache \
	    ca-certificates \
	    rtorrent \
	    rtorrent-doc \
#doc package has the rc file template in it
	    rutorrent \
	    tmux \
	    nginx \
	    unrar \
	    curl \
	    php7 \
	    php7-fpm \
	    php7-json \
	    supervisor && \

# basic
	mkdir -p /app /config /downloads && \

# add user
	addgroup -g 1000 rtorrent && \
	adduser -D -G rtorrent -s /bin/false -u 1000 rtorrent && \
	#with home dir

# setup some config bits
	cp /usr/share/webapps/rutorrent/conf/config.php /usr/share/webapps/rutorrent/conf/config.php.backup && \

# configure web server
    sed -i \
        -e 's/group =.*/group = rtorrent/' \
        -e 's/user =.*/user = rtorrent/' \
        -e 's/listen\.owner.*/listen\.owner = rtorrent/' \
        -e 's/listen\.group.*/listen\.group = rtorrent/' \
        -e 's/error_log =.*/error_log = \/dev\/stdout/' \
        /etc/php7/php-fpm.d/www.conf  && \
    sed -i \
        -e '/open_basedir =/s/^/\;/' \
        /etc/php7/php.ini && \

# permissions
	chown -R rtorrent:rtorrent /app /config /downloads /usr/share/webapps/rutorrent/conf/config.php* && \
	addgroup rtorrent rutorrent  && \
	chmod g+x /usr/share/webapps/rutorrent/share && \

# cleanup
	rm -rf /tmp/*

COPY apprun.sh /app/apprun.sh
COPY supervisord-rtorrent.ini /etc/supervisor.d/supervisord-rtorrent.ini
COPY nginx.conf /etc/nginx/nginx.conf
COPY rtorrent.rc /home/rtorrent/.rtorrent.rc

# volume mappings
VOLUME /config /downloads
EXPOSE 80 6881 58331

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
