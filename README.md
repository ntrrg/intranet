This is the NtWeb intranet project, built with Docker (specifically Docker
Swarm) in mind, what makes it super portable and incredibly easy to scale.

## Services

* Status ([Visualizer][]) - [See in docker-compose.yml](docker-compose.yml#L3)
* [DNS ([Bind9][])](#dns) - [See in docker-compose.yml](docker-compose.yml#L13)
* [Reverse proxy ([NGINX][])](#reverse-proxy) - [See in docker-compose.yml](docker-compose.yml#L33)
* [Git ([Gogs][])](#git) - [See in docker-compose.yml](docker-compose.yml#L24)

### DNS

Dominio | IP
--------|---
nt.web.ve | 192.168.0.50
blog | 192.168.0.50
git | 192.168.0.50
mirrors | 192.168.0.50
ns1 | 192.168.0.50
status | 192.168.0.50
www | 192.168.0.50

**Domain rewrites:**

From | To
-----|---
dl-cdn.alpinelinux.org | mirrors.nt.web.ve.
httpredir.debian.org | mirrors.nt.web.ve.

### Reverse proxy

VH | Protocol | Type | Target
---|----------|------|-------
nt.web.ve | `http`, `h2` | Static | `/srv/web`
git.nt.web.ve | `http`, `h2` | Reverse proxy | `git:3000`
mirrors.web.ve | `http`, `h2` | Static | `/srv/mirrors`
status.web.ve | `http`, `h2` | Reverse proxy | `status:8080`

### Git

**SSH port:** 22

## Usage

Some services use/require HTTP2, so it is recommended to generate the SSL/TLS
certificates before initializing the Swarm:

```sh
docker run --rm -it -p 80:80 -p 443:443 \
  -v /media/ntrrg/NtServer/Work/NtWeb/Certs:/etc/letsencrypt \
    certbot/certbot certonly --standalone --expand
      -nm ntrrgx@gmail.com --agree-tos \
      -d nt.web.ve \
      -d git.nt.web.ve \
      -d mirrors.nt.web.ve \
      -d www.nt.web.ve
```

```sh
chown -R ntrrg: /media/ntrrg/NtServer/Work/NtWeb/Certs/
```

## Acknowledgment

Working on this project I use/used:

* [Debian](https://www.debian.org/)

* [XFCE](https://xfce.org/)

* [st](https://st.suckless.org/)

* [Zsh](http://www.zsh.org/)

* [GNU Screen](https://www.gnu.org/software/screen)

* [Git](https://git-scm.com/)

* [EditorConfig](http://editorconfig.org/)

* [Sublime Text 3](https://www.sublimetext.com/3)

* [Chrome](https://www.google.com/chrome/browser/desktop/index.html)

* [Docker](https://docker.com)

* [Bind9][]

* [NGINX][]

* [Gogs][]

* [Github](https://github.com)

* [Travis CI](https://travis-ci.org)

[Bind9]: https://www.isc.org/downloads/bind/
[Gogs]: https://gogs.io/
[NGINX]: https://www.nginx.com/
[Visualizer]: https://github.com/dockersamples/docker-swarm-visualizer
