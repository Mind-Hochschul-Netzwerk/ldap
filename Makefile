check-traefik:
ifeq (,$(shell docker ps -f name=^traefik$$ -q))
	$(error docker container traefik is not running)
endif

.env:
	$(error .env is missing)

dev: .env check-traefik
	@echo "Starting DEV Server"
	./ensurevolumes.sh
	docker-compose up -d --force-recreate ldap phpldapadmin

prod: .env check-traefik
	@echo "Starting Production Server"
	./ensurevolumes.sh
	docker-compose up -d --force-recreate ldap
