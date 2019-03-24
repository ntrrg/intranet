include config.env

.PHONY: all
all: build

.PHONY: build
build:
	@bin/prepare.sh
	@bin/build-docker.sh

.PHONY: deploy
deploy:
	cd "$(IN_ROOT)/var/server" && \
		docker stack deploy -c docker-swarm.yml intranet

.PHONY: deploy-single
deploy-single:
	mkdir -p \
		"$(IN_ROOT)/srv/docker-registry" \
		"$(IN_ROOT)/srv/drone" \
		"$(IN_ROOT)/srv/gogs" \
		"$(IN_ROOT)/srv/mirrors" \
		"$(IN_ROOT)/srv/registry" \
		"$(IN_ROOT)/srv/storage" \
		"$(IN_ROOT)/srv/storage/data"
	touch "$(IN_ROOT)/srv/storage/database.db" \
		&& chown 1000:1000 "$(IN_ROOT)/srv/storage/database.db"
	docker node update \
		--label-add ci-builder=true \
		--label-add ci-server=true \
		--label-add docker-registry=true \
		--label-add git=true \
		--label-add mirrors=true \
		--label-add registry=true \
		--label-add site=true \
		--label-add storage=true \
		"$$(hostname)"
	@$(MAKE) -s deploy

.PHONY: secrets
secrets:
	@bin/secrets.sh || rm -rf "$(IN_ROOT)/etc/letsencrypt"

# Development

srcfiles := $(shell find . -iname "*.sh" -type f)
srcfiles := $(filter-out ./services/%, $(srcfiles))

.PHONY: lint
lint:
	shellcheck -s sh $(srcfiles)

