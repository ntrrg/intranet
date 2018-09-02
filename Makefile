server := /media/ntrrg/NtServer
domain := nt.web.ve
admin_email := ntrrgx@gmail.com

.PHONY: all
all: build deploy

.PHONY: build
build:
	@.make/scripts/build.sh

.PHONY: ci
ci: lint

.PHONY: deploy
deploy:
	SERVER="$(server)" docker stack deploy -c docker-compose.yml intranet

.PHONY: deploy-single
deploy-single:
	docker pull drone/agent
	docker pull drone/cli
	docker pull drone/drone
	docker pull filebrowser/filebrowser
	docker pull gogs/gogs
	docker pull ntrrg/site
	docker pull registry:2
	mkdir -p \
		"$(server)/srv/docker-registry" \
		"$(server)/srv/drone" \
		"$(server)/srv/gogs" \
		"$(server)/srv/mirrors" \
		"$(server)/srv/registry" \
		"$(server)/srv/storage"
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

.PHONY: deps
deps:
	docker pull dockersamples/visualizer
	docker pull ntrrg/bind:private
	docker pull ntrrg/nginx:rproxy

.PHONY: secrets
secrets: .make/scripts/certs.sh
	@\
		DOMAIN="$(domain)" \
		ROOT="$(server)/etc/letsencrypt" \
		EMAIL="$(admin_email)" \
		$< @ www blog
	@\
		DOMAIN="$(domain)" \
		ROOT="$(server)/etc/letsencrypt" \
		EMAIL="$(admin_email)" \
		$< home ci docker git mirrors registry status storage
	@\
		DOMAIN="$(domain)" \
		ROOT="$(server)/etc/letsencrypt" \
		EMAIL="$(admin_email)" \
		$< test
	docker run --rm \
		ntrrg/htpasswd -bB ntrrg "$$HTPASSWD" \
		> "$(server)/etc/htpasswd"

# Development

shellcheck_release := 0.4.7

.PHONY: deps-dev
deps-dev: .make/bin/shellcheck

.PHONY: lint
lint: .make/bin/shellcheck
	$< -s sh $$(find .make/scripts/ -name "*.sh" -exec echo {} +)

.PHONY: lint-md
lint-md:
	@docker run --rm -it -v "$$PWD":/files/ ntrrg/md-linter

.make/bin/shellcheck: .make/scripts/install-shellcheck.sh
	@RELEASE=$(shellcheck_release) DEST=$@ $<
