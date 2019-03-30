[![Travis build btatus](https://travis-ci.com/ntrrg/intranet.svg?branch=master)](https://travis-ci.com/ntrrg/intranet)

**intranet** is a tool that let you deploy common enterprise services in an
easy way. It includes:

* [DNS](#dns) ([Bind9][])
* [Reverse proxy](#reverse-proxy) ([NGINX][])
* [Site](#site) ([NGINX][])
* [Storage](#storage) ([NGINX][], [File Browser][])
* [Mirrors](#mirrors) ([NGINX][])
* [Git](#git) ([Gogs][])
* [CI](#continuous-integration) ([Drone][])
* [Container Registry](#container-registry) ([Docker Registry][])

And will include (hopefully) soon:

* Services monitoring
* Proxy server
* VPN server
* CD

## Usage

**Requirements:**

* GNU Make
* Docker >= 18.09

1\. Setup the parameters.

```shell-session
$ EDITOR config.env
```

2\. Initialize Swarm.

```shell-session
# docker swarm init
```

3\. (Optional) Download the needed images.

```shell-session
# docker pull certbot/certbot
# docker pull drone/agent:0.8.6
# docker pull drone/cli:0.8.6
# docker pull drone/drone:0.8.6
# docker pull filebrowser/filebrowser:v2.0.3
# docker pull gogs/gogs:0.11.53
# docker pull ntrrg/bind:private
# docker pull ntrrg/htpasswd
# docker pull ntrrg/nginx:http
# docker pull ntrrg/nginx:rproxy
# docker pull registry:2
```

4\. Generate secrets.

```shell-session
# make secrets
```

5\. Deploy services.

```shell-session
# make
#
# # Run services in multiples nodes (see Services section)
# make deploy
#
# # Run services in one node
# make deploy-single
```

## Services

### DNS

**Constraints:** `node.role == manager`

**Ports:** `53/tcp`, `53/upd`

**Domain**  | **IP/Alias**
------------|--------------
example.com | 192.168.0.50
blog        | example.com
ci          | example.com
docker      | example.com
git         | example.com
home        | example.com
mirrors     | example.com
ns1         | example.com
registry    | example.com
s6          | example.com
status      | example.com
storage     | example.com
test        | example.com
www         | example.com

#### Rewrites

* `deb.debian.org` -> `mirrors.example.com`
* `dl-cdn.alpinelinux.org` -> `mirrors.example.com`

### Reverse proxy

**Constraints:** `node.role == manager`

**Ports:** `80/tcp`, `443/tcp`

**Name**           | **Protocol** | **Target**
-------------------|--------------|-------------------------------
example.com        | `h2`         | `site:80`
blog.example.com   | `h2`         | `site:80`
ci.example.com     | `h2`         | `ci-server:8000`
docker.example.com | `h2`         | `docker-registry:5000`
git.example.com    | `h2`         | `git:3000`
mirrors.web.ve     | `http`, `h2` | `mirrors:80`
registry.web.ve    | `h2`         | `registry:5000`
status.web.ve      | `h2`         | `status:8080`
storage.web.ve     | `http`, `h2` | `storage:80`, `filebrowser:80`
www.example.com    | `h2`         | `site:80`

### Status

**Constraints:** `node.role == manager`

### Site

**Constraints:** `node.labels.site == true`

### Storage

**Constraints:** `node.labels.storage == true`

### Mirrors

**Constraints:** `node.labels.mirrors == true`

### Git

**Constraints:** `node.labels.git == true`

### Continuous Integration

The easiest way to manage the Drone service is using the official
[CLI](http://docs.drone.io/cli-installation/).

```shell-session
# docker run \
  -e DRONE_SERVER=https://ci.example.com \
  -e DRONE_TOKEN=TOKEN \
  drone/cli:0.8.6 info
```

**Note:** `TOKEN` should be obtained from the
[web interface](https://ci.example.com/account/token).

Also there are some useful endpoints for getting information about the CI
services:

* <https://ci.example.com/metrics>
* <https://ci.example.com/api/info/queue>
* <https://ci.example.com/api/builds>

### Container Registry

#### Private Registry

**Constraints:** `node.labels.registry == true`

#### Docker Registry Cache

**Constraints:** `node.labels.docker-registry == true`

## Distributed

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

* [Vim](https://www.vim.org/)

* [GNU make](https://www.gnu.org/software/make/)

* [File Browser][]

[Bind9]: https://www.isc.org/downloads/bind/
[Gogs]: https://gogs.io/
[NGINX]: https://www.nginx.com/
[Visualizer]: https://github.com/dockersamples/docker-swarm-visualizer
[Docker Registry]: https://hub.docker.com/_/registry/
[Drone]: https://drone.io/
[File Browser]: https://filebrowser.github.io/

