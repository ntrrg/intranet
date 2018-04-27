## Services

* [DNS](#dns) ([Bind9][]) - [See in docker-compose.yml](docker-compose.yml#L5)

* [Reverse proxy](#reverse-proxy) ([NGINX][]) - [See in docker-compose.yml](docker-compose.yml#L124)

* Status ([Visualizer][]) - [See in docker-compose.yml](docker-compose.yml#L21)

* Git ([Gogs][]) - [See in docker-compose.yml](docker-compose.yml#L35)

* Continuous integration ([Drone][]) - [See in docker-compose.yml](docker-compose.yml#L81)

* Private registry ([Docker Registry][]) - [See in docker-compose.yml](docker-compose.yml#L51)

* Docker registry cache proxy ([Docker Registry][]) - [See in docker-compose.yml](docker-compose.yml#L65)

### DNS

Domain | IP
-------|---
nt.web.ve | 192.168.0.50
blog | 192.168.0.50
ci | 192.168.0.50
docker | 192.168.0.50
git | 192.168.0.50
mirrors | 192.168.0.50
ns1 | 192.168.0.50
registry | 192.168.0.50
status | 192.168.0.50
www | 192.168.0.50

**Domain rewrites:**

From | To
-----|---
dl-cdn.alpinelinux.org | mirrors.nt.web.ve
httpredir.debian.org | mirrors.nt.web.ve

### Reverse proxy

VH | Protocol | Type | Target
---|----------|------|-------
nt.web.ve | `http`, `h2` | Static | `/srv/web`
ci.nt.web.ve | `http`, `h2` | Reverse proxy | `ci-server:8000`
docker.nt.web.ve | `http`, `h2` | Reverse proxy | `docker-registry:5000`
git.nt.web.ve | `http`, `h2` | Reverse proxy | `git:3000`
mirrors.web.ve | `http`, `h2` | Static | `/srv/mirrors`
registry.web.ve | `http`, `h2` | Reverse proxy | `registry:5000`
status.web.ve | `http` | Reverse proxy | `status:8080`

### Continuous integration

The easiest way to manage the Drone service is using the official
[CLI](http://docs.drone.io/cli-installation/).

```sh
docker run \
  -e DRONE_SERVER=https://ci.nt.web.ve
  -e DRONE_TOKEN=TOKEN
info
```

**Note:** `TOKEN` can be obtained from the
[web interface](https://ci.nt.web.ve/account/token).

Also there are some useful endpoints for getting information about the CI
services:

* https://ci.nt.web.ve/metrics
* https://ci.nt.web.ve/api/info/queue
* https://ci.nt.web.ve/api/builds

## Usage

1. Build/get all the required images

   ```sh
.bin/prepare.sh
   ```

2. Get/generate the necessary secrets

   **SSL/TLS:**

   ```sh
docker run --rm -it -p 80:80 -p 443:443 \
 -v "${SERVER}/etc/letsencrypt":/etc/letsencrypt \
   certbot/certbot certonly --standalone --expand \
     -nm ntrrgx@gmail.com --agree-tos \
     -d nt.web.ve \
     -d blog.nt.web.ve \
     -d ci.nt.web.ve \
     -d docker.nt.web.ve \
     -d git.nt.web.ve \
     -d mirrors.nt.web.ve \
     -d registry.nt.web.ve \
     -d www.nt.web.ve
   ```

   **HTPASSWD:**

   ```sh
docker run --rm \
 --entrypoint htpasswd \
registry:2 -bnB USER PASSWD \
 > "${SERVER}/etc/htpasswd"
   ```

3. Verify that all the volumes and secrets points to the right path

   **Git:**

   * `${SERVER}/srv/gogs`

   **Continuous integration:**

   * `${SERVER}/srv/drone`

   **Registry:**

   * `${SERVER}/srv/registry`

   **Docker registry cache proxy:**

   * `${SERVER}/srv/docker-registry`

   **Reverse proxy:**

   * `${SERVER}/srv/mirrors`
   * `${SERVER}/etc/letsencrypt/archive/nt.web.ve-0002/privkey2.pem`
   * `${SERVER}/etc/letsencrypt/archive/nt.web.ve-0002/fullchain2.pem`
   * `${SERVER}/etc/htpasswd`

4. Initialize the Swarm

   ```sh
docker swarm init
   ```

5. Set the node labels

   ```sh
.bin/labels.sh
   ```

6. Deploy the stack

   ```sh
SERVER="/media/ntrrg/NtServer/Server" \
docker stack deploy -c docker-compose.yml ntweb-intranet
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

[Bind9]: https://www.isc.org/downloads/bind/
[Gogs]: https://gogs.io/
[NGINX]: https://www.nginx.com/
[Visualizer]: https://github.com/dockersamples/docker-swarm-visualizer
[Docker Registry]: https://hub.docker.com/_/registry/
[Drone]: https://drone.io/

