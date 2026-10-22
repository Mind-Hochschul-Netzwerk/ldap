.DEFAULT_GOAL := prod

.PHONY: check-traefik
check-traefik:
ifeq (,$(shell docker ps -f name=^traefik$$ -q))
	$(error docker container traefik is not running)
endif

.PHONY: dev
dev: check-traefik
	@echo "Starting DEV Server"
	docker compose up -d --force-recreate ldap phpldapadmin

.PHONY: prod
prod: check-traefik
	@echo "Starting Production Server"
	docker compose up -d --force-recreate ldap

.PHONY: pla
pla: check-traefik
	@echo "Starting phpldapadmin"
	docker compose up -d --force-recreate phpldapadmin
