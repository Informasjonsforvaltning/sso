FROM maven:3.8-openjdk-17-slim AS build

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


FROM quay.io/keycloak/keycloak:25.0.5

# copy deployment modules from maven environment
COPY --from=build /tmp/rest-user-mapper/target/rest-user-mapper.jar /opt/keycloak/providers/rest-user-mapper.jar
COPY --from=build /tmp/fdk-scripts/fdk-scripts.jar /opt/keycloak/providers/fdk-scripts.jar

# copy modified files from host ( 3 files) - trying to copy only changed files...
COPY themes/fdk /opt/keycloak/themes/fdk
COPY themes/fdk-choose-provider /opt/keycloak/themes/fdk-choose-provider
COPY themes/fdk-fbh /opt/keycloak/themes/fdk-fbh

ENV KC_HOSTNAME_STRICT="false" \
    KC_PROXY="edge"

RUN sh opt/keycloak/bin/kc.sh build \
    --db postgres \
    --http-relative-path /auth \
    --health-enabled true \
    --metrics-enabled true \
    --features scripts

CMD ["--verbose", "start", "--optimized"]
