package no.fdk.keycloak.rar;

import org.keycloak.Config;
import org.keycloak.models.KeycloakSession;
import org.keycloak.protocol.oidc.rar.AuthorizationDetailsProcessor;
import org.keycloak.protocol.oidc.rar.AuthorizationDetailsProcessorFactory;
import org.keycloak.representations.AuthorizationDetailsJSONRepresentation;
import org.keycloak.util.AuthorizationDetailsParser;

import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

public class AnsattportenAuthorizationDetailsProcessorFactory implements AuthorizationDetailsProcessorFactory {

    public static final String PROVIDER_ID = AnsattportenAuthorizationDetailsProcessor.TYPE;

    static final String RESOURCES_ENV = "ANSATTPORTEN_ALTINN_RESOURCES";
    static final String DEFAULT_RESOURCES = "datanorge-lesetilgang,datanorge-skrivetilgang,datanorge-virksomhetsadministrator";

    private Set<String> allowedResourceIds;

    @Override
    public AuthorizationDetailsProcessor<?> create(KeycloakSession session) {
        return new AnsattportenAuthorizationDetailsProcessor(allowedResourceIds);
    }

    @Override
    public void init(Config.Scope config) {
        String configured = System.getenv(RESOURCES_ENV);
        String resources = configured == null || configured.isBlank() ? DEFAULT_RESOURCES : configured;
        allowedResourceIds = Arrays.stream(resources.split(","))
                .map(String::trim)
                .filter(id -> !id.isEmpty())
                .collect(Collectors.toUnmodifiableSet());

        // Keycloak requires a parser per type before it can cast an entry to the processor's response type.
        // Our response type is the generic representation, so the parser is a plain cast.
        AuthorizationDetailsParser.registerParser(PROVIDER_ID, new AuthorizationDetailsParser() {
            @Override
            public <T extends AuthorizationDetailsJSONRepresentation> T asSubtype(AuthorizationDetailsJSONRepresentation authzDetail, Class<T> clazz) {
                return clazz.cast(authzDetail);
            }
        });
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }
}
