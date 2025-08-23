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

* `webteam` with password `webteam1`
* `schorsch.testmeier` with password `123`
* `johnny.testmitglied` with password `123`
* `hugo.neumitglied` with password `123`

