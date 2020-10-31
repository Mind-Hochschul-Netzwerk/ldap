# ldap
openldap server

## run

Edit env.sample and save it as .env

    $ docker-compose up -d ldap

Start PhpLDAPAdmin:

    $ docker-compose up -d phpldapadmin

Make sure the `traefik` container is running.

Go to [http://pla.docker.localhost](http://pla.docker.localhost) to open the PhpLDAPAdmin interface.

    login DN: cn=admin,dc=mind-hochschul-netzwerk,dc=de
    Password: admin

## test data

Use PhpLDAPAdmin (see above) to import the `test-data.ldif`.

Included users (use them to login to Moodle): `test.user` and `test.manager`, both with password `test`.

