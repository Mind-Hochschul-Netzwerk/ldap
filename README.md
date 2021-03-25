# ldap
openldap server

## run development server

Edit env.sample and save it as .env

    $ make dev

Make sure the `traefik` container is running.

Go to [http://pla.docker.localhost](http://pla.docker.localhost) to open the PhpLDAPAdmin interface.

    login DN: cn=admin,dc=mind-hochschul-netzwerk,dc=de
    Password: admin

## run production server

Edit env.sample and save it as .env

    $ make prod

## test data

Use PhpLDAPAdmin (see above) to import the `test-data.ldif`.

Included users:

* `test.user` with password `MHNTest0#`
* `test.manager` with password `MHNTest0#`
* `webteam` with password `webteam`
