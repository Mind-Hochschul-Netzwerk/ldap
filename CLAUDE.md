# CLAUDE.md

OpenLDAP server (Docker Compose) for the Mind-Hochschul-Netzwerk (MHN) web infrastructure. It is the central user/group directory for other MHN services (member tool, Moodle, mail relay, Listmonk newsletter export, ...). There is no application code here, only infrastructure config and test data.

## Layout

- `docker-compose.yml` – services `ldap` (`osixia/openldap:1.5.0`, container `ldap`) and `phpldapadmin` (`phpldapadmin/phpldapadmin:latest`, container `phpldapadmin`). Networks: `ldap` (named, created here) and `traefik` (external, must exist).
- `Makefile` – `make dev` (ldap + phpldapadmin), `make prod` (ldap only; default goal) and `make pla` (phpldapadmin only). All fail if the `traefik` container is not running, and use `up -d --force-recreate`.
- `env.sample` → copy to `.env` (gitignored): `DOMAINNAME`, `VOLUMES_DIR`, `LDAP_ADMIN_PASSWORD`, `LDAP_CONFIG_PASSWORD`.
- `ensurevolumes.sh` – creates `${VOLUMES_DIR}/ldap` and `${VOLUMES_DIR}/slapd.d`; not called by the Makefile.
- `config.ldif` – cn=config changes: loads `pw-crypt` module, sets `olcPasswordHash {CRYPT}` with SHA-512 salt format (`$6$rounds=100000$%.16s`). Not referenced by compose or Makefile; it is applied manually (e.g. `ldapmodify`/`ldapadd` against cn=config). Note that `test-data.ldif` users have `{CRYPT}$5$...` hashes (SHA-256).
- `test-data.ldif` – phpLDAPadmin export for dev; import via the phpLDAPadmin UI.
- `docker/volumes/` – persistent LDAP data (`ldap/` mdb files, `slapd.d/` config). Gitignored, owned by the container user; `cn=config` inside is unreadable for the host user (expect "Keine Berechtigung"). Do not touch or commit.

## Configuration facts

- Base DN `dc=mind-hochschul-netzwerk,dc=de` (derived from `LDAP_DOMAIN`; `LDAP_BASE_DN` is intentionally empty). Admin: `cn=admin,<base>`.
- Backend mdb, TLS enabled (`LDAP_TLS=true`, client certs not verified), no replication, RFC2307bis off, `LDAP_REMOVE_CONFIG_AFTER_SETUP=true`, log level 256.
- The `ldap` service publishes no ports; other containers reach it via the `ldap` Docker network.
- phpLDAPadmin (new `phpldapadmin/phpldapadmin` image, configured via `LDAP_HOST`, `APP_TIMEZONE`) listens on port 8080 (set via Traefik label) behind Traefik at `pla.${DOMAINNAME}` (dev default `pla.docker.localhost`) with the `forwardauth@file` middleware (defined in the separate Traefik setup, not in this repo).
- Env vars `LDAP_ADMIN_PASSWORD`/`LDAP_CONFIG_PASSWORD` are only applied on first initialization of the volumes; later changes need a password change in LDAP or fresh volumes.

## Directory model (from test-data.ldif)

- `ou=people`: `inetOrgPerson` entries with `cn=<firstname.lastname>`, `employeeNumber` (member ID), `mail`, `givenName`, `sn`, `userPassword` (`{CRYPT}`). Special account `cn=Webteam` (employeeNumber 1, uid 1).
- `ou=groups`: `groupOfNames` entries with `member` DNs; some also use the custom `mailGroup` objectClass (with `mail`, `owner`; description holds a JSON blob for mailing-list settings). Groups used as permissions: `aktivierung`, `aufnahme`, `coursecreator`, `datenschutz`, `manager`, `mvedit`, `mvread`, `newsletter-export`, `rechte`, `wahlleitung`; plus `alleMitglieder`, `listen`, `testliste`.
- The `ou=groups` description documents the `businessCategory` convention (system / self-service / private / managed) that controls who may edit entries.
- Dev logins: `cn=admin,...` / `admin`; `webteam` / `webteam1`; `schorsch.testmeier`, `johnny.testmitglied`, `hugo.neumitglied` / `123`.

## Gotchas

- `mailGroup` is not a standard schema; it is defined elsewhere (not in this repo). Test-data import may fail on a fresh server without it.
- `description::` values in the LDIF are base64 (multi-line); decode before editing.
- README documents `make dev`/`make prod` and the test accounts; keep it in sync when changing those.

## Working notes

- No tests or build step. Validate by `docker compose config` and, if Docker is available, `make dev` (requires a running `traefik` container).
- Git: branch `master`, remote under the `Mind-Hochschul-Netzwerk` GitHub org. Commit messages are short, lowercase, imperative.
- Record notable code/config changes below (brief, no file lists).

## Change log

- Switched phpLDAPadmin to the new `phpldapadmin/phpldapadmin` image; added `make pla`, `.PHONY` targets and `prod` as default goal.
- Fixed corrupted `cn=mvedit` entry in `test-data.ldif` (truncated member DN had swallowed the `objectclass` line).
