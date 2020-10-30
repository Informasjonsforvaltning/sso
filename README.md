When there is no client registered for sso, the configuration can be tested with the account page as client:

xxxx/auth/realms/fdk/account
f.eks: 
https://sso.ut1.fellesdatakatalog.brreg.no/auth/realms/fdk/account/

Here you can use the 4 test users
Michelle Westlie  = username mw  and password mw  and so on

Admin permissinos to test Additional info regarding permissions
https://sso.ut1.fellesdatakatalog.brreg.no

Select admin console 
Select realm = fdk
Select sessions
select client account
show sessions
select a session
open attributes
verify fdk _access values

# Themes - Developing on host with docker volume
1) Build container:
- docker build --no-cache -t fdk/sso .

2) Run container:
- docker run -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e SSO_HOST=http://localhost:8084 -e IDPORTEN_OIDC_ROOT=http://localhost:8084/auth/realms/idporten-mock -e IDPORTEN_CLIENT_ID=oidc_brreg_fellesdatakatalog -e IDPORTEN_CLIENT_SECRET=29a2cfe1-1a61-4a04-bf84-64d70a340d04 -p 8084:8084 -t fdk/sso

3) Verify keycloak running:
http://localhost:8084/auth/realms/fdk/protocol/openid-connect/auth?client_id=fdk-registration-public&redirect_uri=http%3A%2F%2Flocalhost%3A8084%2Fauth%2Frealms%2Ffdk-local%2Faccount%2Flogin-redirect&state=0%2F54726072-b7e3-40fe-b4b9-a55d76bf24dd&response_type=code&scope=openid

and admin-console:
http://localhost:8084/auth/admin/master/console/#/realms (admin / admin)

4) Stop the container, get container-id from docker ps:
- docker stop <CONTAINER_ID>

5) Uncomment this line in Dockerfile:
- COPY themes/fdk-choose-provider /opt/jboss/keycloak/themes/fdk-choose-provider

6) Copy the fdk theme folder from container:
First get the sso container id (docker ps), then go to your local themes folder and run:
docker cp <CONTAINER_ID>:/opt/jboss/keycloak/themes/fdk-choose-provider ./fdk-choose-provider 

7) Then run container with local volume, use id-porten-mock (secrets from idporten-mock-realm.template.json):
- docker run -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e SSO_HOST=http://localhost:8084 -e IDPORTEN_OIDC_ROOT=http://localhost:8084/auth/realms/idporten-mock -e IDPORTEN_CLIENT_ID=oidc_brreg_fellesdatakatalog -e IDPORTEN_CLIENT_SECRET=29a2cfe1-1a61-4a04-bf84-64d70a340d04 -d -v <PATH_TO_LOCAL_THEME>:/opt/jboss/keycloak/themes/fdk-choose-provider -p 8084:8084 -t fdk/sso

8) Open browser:
- http://localhost:8084/auth/realms/fdk/protocol/openid-connect/auth?client_id=fdk-registration-public&redirect_uri=http%3A%2F%2Flocalhost%3A8084%2Fauth%2Frealms%2Ffdk-local%2Faccount%2Flogin-redirect&state=0%2F54726072-b7e3-40fe-b4b9-a55d76bf24dd&response_type=code&scope=openid

Now you can change theme files in ./themes/fdk and see the changes in keycloak. (NB: Shift+Ctrl+R for reloading cached css).