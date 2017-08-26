# docker-rtorrent
A basic rtorrent + nginx + rutorrent container, based on the latest Alpine Linux base image.

Some inspiration from these repos was involved

* https://github.com/vSense/docker-rtorrent
* https://github.com/chamunks/alpine-rtorrent

Includes the latest packaged verion of rtorrent/rutorrent/nginx at the time of image build.

Quick start (config files are created in config volume automatically):
```shell
docker run -d -p 80:80 -p 6881:6881 -p 58331:58331 -v /path/to/config:/config -v /path/to/downloads:/downloads --name rtorrent tardfree/docker-rtorrent
```

To have the container start when the host boots, add docker's restart policy:
```shell
docker run -d --restart=always -p 80:80 -p 6881:6881 -p 58331:58331 -v /path/to/config:/config -v /path/to/downloads:/downloads --name rtorrent tardfree/docker-rtorrent
```

