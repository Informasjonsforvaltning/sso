package no.fdk.keycloak.rar;

import org.keycloak.models.ClientSessionContext;
import org.keycloak.models.UserSessionModel;
import org.keycloak.protocol.oidc.rar.AuthorizationDetailsProcessor;
import org.keycloak.protocol.oidc.rar.InvalidAuthorizationDetailsException;
import org.keycloak.representations.AuthorizationDetailsJSONRepresentation;

import java.util.Collections;
import java.util.List;
import java.util.Set;

/**
 * Pass-through processor for the Ansattporten RAR type {@code ansattporten:altinn:resource}.
 *
 * <p>Its only job is to let an {@code authorization_details} entry of this type through Keycloak's request
 * validation so that the entry is stored on the authentication session and forwarded to the Ansattporten
 * identity provider. Keycloak never grants anything itself here; what the user actually chose to represent
 * comes back from Ansattporten in the brokered id_token and is handled by identity provider mappers. For that
 * reason the token endpoint methods return nothing, so Keycloak's own token response carries no
 * {@code authorization_details}.
 *
 * <p>Only resources on the configured allowlist are accepted, because Ansattporten does no access control of
 * its own on RAR types and any client of the realm can start a login. Note that Keycloak parses every entry
 * into its generic representation before this class sees it, and that representation declares {@code actions}
 * as a list. Ansattporten's documentation shows {@code "actions": "write,report"}; clients must send a JSON
 * array instead, {@code "actions": ["write","report"]}, or Keycloak rejects the request before it gets here.
 *
 * <p>Request model, see https://docs.digdir.no/docs/ansattporten/ansattporten_rar.html
 */
public class AnsattportenAuthorizationDetailsProcessor implements AuthorizationDetailsProcessor<AuthorizationDetailsJSONRepresentation> {

    public static final String TYPE = "ansattporten:altinn:resource";

    static final String RESOURCE_CLAIM = "resource";
    static final String RESOURCE_PREFIX = "urn:altinn:resource:";

    private final Set<String> allowedResourceIds;

    public AnsattportenAuthorizationDetailsProcessor(Set<String> allowedResourceIds) {
        this.allowedResourceIds = allowedResourceIds;
    }

    @Override
    public boolean isSupported() {
        return true;
    }

    @Override
    public String getSupportedType() {
        return TYPE;
    }

    @Override
    public Class<AuthorizationDetailsJSONRepresentation> getSupportedResponseJavaType() {
        return AuthorizationDetailsJSONRepresentation.class;
    }

    @Override
    public AuthorizationDetailsJSONRepresentation validateAuthorizationDetail(AuthorizationDetailsJSONRepresentation authzDetail)
            throws InvalidAuthorizationDetailsException {
        // Keycloak dispatches by type, so this only guards against being called directly.
        if (!TYPE.equals(authzDetail.getType())) {
            throw new InvalidAuthorizationDetailsException("authorization_details entry has the wrong type for this processor");
        }
        Object resource = authzDetail.getCustomData().get(RESOURCE_CLAIM);
        if (!(resource instanceof String) || !((String) resource).startsWith(RESOURCE_PREFIX)) {
            throw new InvalidAuthorizationDetailsException(
                    "authorization_details of type " + TYPE + " requires '" + RESOURCE_CLAIM + "' starting with " + RESOURCE_PREFIX);
        }
        String resourceId = ((String) resource).substring(RESOURCE_PREFIX.length());
        if (!allowedResourceIds.contains(resourceId)) {
            throw new InvalidAuthorizationDetailsException("Altinn resource is not allowed for representation requests");
        }
        return authzDetail;
    }

    @Override
    public AuthorizationDetailsJSONRepresentation process(UserSessionModel userSession, ClientSessionContext clientSessionCtx,
                                                          AuthorizationDetailsJSONRepresentation authorizationDetailsMember) {
        // Sent directly on the token request. Nothing is granted by Keycloak, so nothing goes in the token response.
        return null;
    }

    @Override
    public List<AuthorizationDetailsJSONRepresentation> handleMissingAuthorizationDetails(UserSessionModel userSession,
                                                                                          ClientSessionContext clientSessionCtx) {
        return Collections.emptyList();
    }

    @Override
    public AuthorizationDetailsJSONRepresentation processStoredAuthorizationDetails(UserSessionModel userSession,
                                                                                    ClientSessionContext clientSessionCtx,
                                                                                    AuthorizationDetailsJSONRepresentation storedAuthDetailsMember) {
        // Stored from the authorize request. Same reasoning as process().
        return null;
    }

    @Override
    public void afterAuthorizationDetailsProcessed(UserSessionModel userSession, ClientSessionContext clientSessionCtx,
                                                   AuthorizationDetailsJSONRepresentation authorizationDetailsResponse) {
        // nothing to do
    }

    @Override
    public void close() {
        // nothing to do
    }
}
