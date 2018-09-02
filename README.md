## Services

* [DNS](#dns) ([Bind9][])

* [Load balancer](#load-balancer) ([NGINX][])
* Status ([Visualizer][])
* Site ([Hugo][])
* Git ([Gogs][])
* Continuous integration ([Drone][])
* Private registry ([Docker Registry][])
* Docker registry cache proxy ([Docker Registry][])

### DNS

---

**Constraints:** `node.role == manager`
**Mode:** `replicated`
**Ports:** `53/tcp`, `53/upd`

---

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

### Load balancer

**VS**           | **Protocol** | **Type**      | **Target**
-----------------|--------------|---------------|------------------------
nt.web.ve        | `http`, `h2` | Reverse proxy | `site:80`
ci.nt.web.ve     | `http`, `h2` | Reverse proxy | `ci-server:8000`
docker.nt.web.ve | `http`, `h2` | Reverse proxy | `docker-registry:5000`
git.nt.web.ve    | `http`, `h2` | Reverse proxy | `git:3000`
mirrors.web.ve   | `http`, `h2` | Static files  | `/srv/mirrors`
registry.web.ve  | `http`, `h2` | Reverse proxy | `registry:5000`
status.web.ve    | `http`, `h2` | Reverse proxy | `status:8080`
storage.web.ve   | `http`, `h2` | Static files  | `/srv/storage`

### Continuous integration

The easiest way to manage the Drone service is using the official
[CLI](http://docs.drone.io/cli-installation/).

```sh
docker run \
  -e DRONE_SERVER=https://ci.nt.web.ve \
  -e DRONE_TOKEN=TOKEN \
drone/cli info
```

**Note:** `TOKEN` should be obtained from the
[web interface](https://ci.nt.web.ve/account/token).

Also there are some useful endpoints for getting information about the CI
services:

* https://ci.nt.web.ve/metrics
* https://ci.nt.web.ve/api/info/queue
* https://ci.nt.web.ve/api/builds

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
# # Run services in multiples nodes (see Services section)
# DRONE_SECRET="SECRET" make
#
# # Run services in one node
# make build
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

* [Hugo][]

* [GNU make](https://www.gnu.org/software/make/)

[Bind9]: https://www.isc.org/downloads/bind/
[Gogs]: https://gogs.io/
[NGINX]: https://www.nginx.com/
[Visualizer]: https://github.com/dockersamples/docker-swarm-visualizer
[Docker Registry]: https://hub.docker.com/_/registry/
[Drone]: https://drone.io/
[Hugo]: https://gohugo.io

