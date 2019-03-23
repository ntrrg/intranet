**intranet** is a tool that let you deploy common enterprise services in 4
steps.

## Usage

**Requirements:**

* GNU Make
* Docker >= 18.09

1\. Setup the parameters.

```shell-session
$ EDITOR config.env
```

`config.env`:

```sh
IN_ROOT="/path/to/server"
IN_ORG="Example"
IN_DOMAIN="example.com"
IN_USER="user"
IN_EMAIL="user@exaple.com"

# DNS

IN_DNS_ADDR="192.168.1.25"
IN_DNS_ADDR_INV="1"
IN_DNS_REVERSE_ZONE="1.168.192"
IN_DNS_WHITELIST="192.168.1.0/24"
IN_DNS_SERIAL="$(date +%Y%m%d)01"

# Reverse proxy

IN_PASSWORD="1234"

# CI

IN_DRONE_SECRET="aJKSnd-sadasd123h1-123h1h2g"
```

2\. Initialize the Swarm.

```shell-session
# docker swarm init
```

3\. (Optional) Download the needed images.

```shell-session
# docker pull certbot/certbot
# docker pull drone/agent:0.8.6
# docker pull drone/cli:0.8.6
# docker pull drone/drone:0.8.6
# docker pull filebrowser/filebrowser:v1.10.0
# docker pull gogs/gogs:0.11.53
# docker pull ntrrg/bind:private
# docker pull ntrrg/htpasswd
# docker pull ntrrg/nginx:rproxy
# docker pull ntrrg/site
# docker pull registry:2
```

4\. Generate the secrets.

```shell-session
# make secrets
```

5\. Deploy the services.

```shell-session
# make
#
# # Run services in multiples nodes (see Distributed section)
# make deploy
#
# # Run services in one node
# make deploy-single
```

## Services

* [DNS](#dns) ([Bind9][])
* [Reverse proxy](#reverse-proxy) ([NGINX][])
* [Status](#status) (TODO)
* [Site](#site) ([NGINX][])
* [Storage](#storage) ([NGINX][], [File Browser][])
* [Mirrors](#mirrors) ([NGINX][])
* [Git](#git) ([Gogs][])
* [CI](#continuous-integration) ([Drone][])
* [Container Registry](#container-registry) ([Docker Registry][])

### DNS

**Constraints:** `node.role == manager`

**Ports:** `53/tcp`, `53/upd`

**Domain** | **IP/Alias**
-----------|--------------
nt.web.ve  | 192.168.0.50
blog       | nt.web.ve
ci         | nt.web.ve
docker     | nt.web.ve
git        | nt.web.ve
home       | nt.web.ve
mirrors    | nt.web.ve
ns1        | nt.web.ve
registry   | nt.web.ve
s6         | nt.web.ve
status     | nt.web.ve
storage    | nt.web.ve
test       | nt.web.ve
www        | nt.web.ve

#### Rewrites

* `deb.debian.org` -> `mirrors.nt.web.ve`
* `dl-cdn.alpinelinux.org` -> `mirrors.nt.web.ve`

### Reverse proxy

**Constraints:** `node.role == manager`

**Ports:** `80/tcp`, `443/tcp`

**Name**         | **Protocol** | **Target**
-----------------|--------------|-------------------------------
nt.web.ve        | `h2`         | `site:80`
blog.nt.web.ve   | `h2`         | `site:80`
ci.nt.web.ve     | `h2`         | `ci-server:8000`
docker.nt.web.ve | `h2`         | `docker-registry:5000`
git.nt.web.ve    | `h2`         | `git:3000`
mirrors.web.ve   | `http`, `h2` | `mirrors:80`
registry.web.ve  | `h2`         | `registry:5000`
status.web.ve    | `h2`         | `status:8080`
storage.web.ve   | `http`, `h2` | `storage:80`, `filebrowser:80`
www.nt.web.ve    | `h2`         | `site:80`

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
  -e DRONE_SERVER=https://ci.nt.web.ve \
  -e DRONE_TOKEN=TOKEN \
  drone/cli:0.8.6 info
```

**Note:** `TOKEN` should be obtained from the
[web interface](https://ci.nt.web.ve/account/token).

Also there are some useful endpoints for getting information about the CI
services:

* <https://ci.nt.web.ve/metrics>
* <https://ci.nt.web.ve/api/info/queue>
* <https://ci.nt.web.ve/api/builds>

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

