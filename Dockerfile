FROM maven:3.6.3-ibmjava-8-alpine AS MAVEN_BUILD_ENVIRONMENT

# use maven environment to build java modules

RUN mkdir /tmp/rest-user-mapper
RUN mkdir /tmp/fdk-scripts

COPY modules/rest-user-mapper/pom.xml /tmp/rest-user-mapper/
COPY modules/rest-user-mapper/src /tmp/rest-user-mapper/src/
COPY modules/fdk-scripts /tmp/fdk-scripts

WORKDIR /tmp/rest-user-mapper/
RUN mvn clean package --no-transfer-progress

WORKDIR /tmp/fdk-scripts
RUN jar -cvf fdk-scripts.jar *

###################################

FROM quay.io/keycloak/keycloak:19.0.0

# copy deployment modules from maven environment
COPY --from=MAVEN_BUILD_ENVIRONMENT /tmp/rest-user-mapper/target/rest-user-mapper.jar /opt/keycloak/providers/rest-user-mapper.jar
COPY --from=MAVEN_BUILD_ENVIRONMENT /tmp/fdk-scripts/fdk-scripts.jar /opt/keycloak/providers/fdk-scripts.jar

# copy keycloak theme as fdk theme.
RUN cp -r /opt/keycloak/themes/keycloak /opt/keycloak/themes/fdk
RUN cp -r /opt/keycloak/themes/keycloak /opt/keycloak/themes/fdk-choose-provider
RUN cp -r /opt/keycloak/themes/keycloak /opt/keycloak/themes/fdk-fbh

# copy modified files from host ( 3 files) - trying to copy only changed files...
COPY themes/fdk /opt/keycloak/themes/fdk
COPY themes/fdk-choose-provider /opt/keycloak/themes/fdk-choose-provider
COPY themes/fdk-fbh /opt/keycloak/themes/fdk-fbh

CMD ["-Dkeycloak.profile.feature.scripts=enabled", "-Dnashorn.args=--no-deprecation-warning"]
