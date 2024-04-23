check-traefik:
ifeq (,$(shell docker ps -f name=^traefik$$ -q))
	$(error docker container traefik is not running)
endif

dev: check-traefik
	@echo "Starting DEV Server"
	docker compose up -d --force-recreate ldap phpldapadmin

prod: check-traefik
	@echo "Starting Production Server"
	docker compose up -d --force-recreate ldap
