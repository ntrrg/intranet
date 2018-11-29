## Services

* [DNS](#dns) ([Bind9][])
* [Reverse proxy](#reverse-proxy) ([NGINX][])
* [Status](#status) ([Visualizer][])
* [Site](#site) ([NGINX][])
* [Storage](#storage) ([NGINX][], [File Browser][])
* [Mirrors](#mirrors) ([NGINX][])
* [Git](#git) ([Gogs][])
* [CI](#continuos-integration) ([Drone][])
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
status     | nt.web.ve
storage    | nt.web.ve
test       | nt.web.ve
www        | nt.web.ve

#### Rewrites

* `deb.debian.org` -> `mirrors.nt.web.ve`
* `dl-cdn.alpinelinux.org` -> `mirrors.nt.web.ve`
* `httpredir.debian.org` -> `mirrors.nt.web.ve`

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

## Usage

**Requirements:**

* GNU Make

1\. Initialize the Swarm.

```shell-session
# docker swarm init
```

2\. Generate the secrets.

```shell-session
# HTPASSWD="PASSWORD" make secrets
```

3\. Deploy the services.

```shell-session
# make
#
# # Run services in multiples nodes (see Services section)
# DRONE_SECRET="SECRET" make deploy
#
# # Run services in one node
# DRONE_SECRET="SECRET" make deploy-single
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

