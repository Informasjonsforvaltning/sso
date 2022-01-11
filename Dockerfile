FROM maven:3.6.3-ibmjava-8-alpine AS MAVEN_BUILD_ENVIRONMENT

# use maven environment to build java modules

RUN mkdir /tmp/rest-user-mapper
RUN mkdir /tmp/scripts

COPY modules/rest-user-mapper/pom.xml /tmp/rest-user-mapper/
COPY modules/rest-user-mapper/src /tmp/rest-user-mapper/src/
COPY modules/scripts/deployment /tmp/scripts/deployment

WORKDIR /tmp/rest-user-mapper/
RUN mvn clean package --no-transfer-progress

WORKDIR ../scripts/deployment
RUN jar -cvf scripts.jar *

###################################

FROM jboss/keycloak:16.1.0

# copy deployment modules from maven environment
COPY --from=MAVEN_BUILD_ENVIRONMENT /tmp/rest-user-mapper/target/rest-user-mapper.jar /opt/jboss/keycloak/standalone/deployments/rest-user-mapper.jar
COPY --from=MAVEN_BUILD_ENVIRONMENT /tmp/scripts/deployment/scripts.jar /opt/jboss/keycloak/standalone/deployments/scripts.jar

# copy keycloak theme as fdk theme.
RUN cp -r /opt/jboss/keycloak/themes/keycloak /opt/jboss/keycloak/themes/fdk
RUN cp -r /opt/jboss/keycloak/themes/keycloak /opt/jboss/keycloak/themes/fdk-choose-provider
RUN cp -r /opt/jboss/keycloak/themes/keycloak /opt/jboss/keycloak/themes/fdk-fbh

# copy modified files from host ( 3 files) - trying to copy only changed files...
COPY themes/fdk /opt/jboss/keycloak/themes/fdk
COPY themes/fdk-choose-provider /opt/jboss/keycloak/themes/fdk-choose-provider
COPY themes/fdk-fbh /opt/jboss/keycloak/themes/fdk-fbh

CMD ["-Dkeycloak.profile.feature.upload_scripts=enabled", "-Dkeycloak.profile.feature.scripts=enabled", "-Dnashorn.args=--no-deprecation-warning"]
