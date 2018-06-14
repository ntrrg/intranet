## Services

* [DNS](#dns) ([Bind9][]) - [docker-compose.yml](docker-compose.yml#L5)

* [Reverse proxy](#reverse-proxy) ([NGINX][]) - [docker-compose.yml](docker-compose.yml#L134)

* Status ([Visualizer][]) - [docker-compose.yml](docker-compose.yml#L21)

* Git ([Gogs][]) - [docker-compose.yml](docker-compose.yml#L35)

* Continuous integration ([Drone][]) - [docker-compose.yml](docker-compose.yml#L81)

* Private registry ([Docker Registry][]) - [docker-compose.yml](docker-compose.yml#L51)

* Docker registry cache proxy ([Docker Registry][]) - [docker-compose.yml](docker-compose.yml#L65)

* Site ([Hugo][]) - [docker-compose.yml](docker-compose.yml#L124)

### DNS

**Domain** | **IP/Alias**
-----------|--------------
nt.web.ve  | 192.168.0.50
blog       | nt.web.ve
ci         | 192.168.0.50
docker     | 192.168.0.50
git        | 192.168.0.50
home       | 192.168.0.50
mirrors    | 192.168.0.50
ns1        | 192.168.0.50
registry   | 192.168.0.50
status     | 192.168.0.50
storage    | 192.168.0.50
test       | 192.168.0.50
www        | nt.web.ve

#### Domain rewrites

**From**               | **To**
-----------------------|-------------------
deb.debian.org         | mirrors.nt.web.ve
dl-cdn.alpinelinux.org | mirrors.nt.web.ve
httpredir.debian.org   | mirrors.nt.web.ve

### Reverse proxy

**VS**           | **Protocol** | **Type**      | **Target**
-----------------|--------------|---------------|------------------------
nt.web.ve        | `http`, `h2` | Reverse proxy | `site:80`
ci.nt.web.ve     | `http`, `h2` | Reverse proxy | `ci-server:8000`
docker.nt.web.ve | `http`, `h2` | Reverse proxy | `docker-registry:5000`
git.nt.web.ve    | `http`, `h2` | Reverse proxy | `git:3000`
mirrors.web.ve   | `http`, `h2` | Static        | `/srv/mirrors`
registry.web.ve  | `http`, `h2` | Reverse proxy | `registry:5000`
status.web.ve    | `http`, `h2` | Reverse proxy | `status:8080`

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

1. Initialize the Swarm

    ```sh
    docker swarm init
    ```

2. Prepare the node for the services

    ```sh
    SERVER="/media/ntrrg/NtServer" .bin/prepare.sh
    ```

3. Deploy the stack

    ```sh
    SERVER="/media/ntrrg/NtServer" .bin/deploy.sh
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

[Bind9]: https://www.isc.org/downloads/bind/
[Gogs]: https://gogs.io/
[NGINX]: https://www.nginx.com/
[Visualizer]: https://github.com/dockersamples/docker-swarm-visualizer
[Docker Registry]: https://hub.docker.com/_/registry/
[Drone]: https://drone.io/
[Hugo]: https://gohugo.io

