package no.fdk.keycloak.mapper;

import org.keycloak.broker.oidc.KeycloakOIDCIdentityProviderFactory;
import org.keycloak.broker.oidc.OIDCIdentityProviderFactory;
import org.keycloak.broker.oidc.mappers.AbstractClaimMapper;
import org.keycloak.broker.provider.BrokeredIdentityContext;
import org.keycloak.models.IdentityProviderMapperModel;
import org.keycloak.models.IdentityProviderSyncMode;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.util.JsonSerialization;
import org.jboss.logging.Logger;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;

/**
 * Imports a structured claim into a user attribute as JSON.
 *
 * <p>Keycloak's built-in "Attribute Importer" calls {@code toString()} on the claim value before storing it, so an
 * object claim such as Ansattporten's {@code authorization_details} is written as {@code {a=[{b=c}]}}. That form has
 * no quoting, which makes it ambiguous for any value containing a comma or an equals sign, such as an organisation
 * name, and no JSON parser accepts it. This mapper serialises the parsed claim back to JSON instead, so a consumer
 * of the attribute gets what the identity provider actually sent.
 *
 * <p>Array-of-object claims are read from the ID token and the access token only. The user info endpoint is served by
 * a Keycloak helper that keeps just the textual members of an array, so a claim like {@code authorization_details}
 * would arrive empty from there.
 *
 * <p>When the claim is absent the attribute is set to an empty JSON array rather than left alone. Leaving it would
 * keep a value from an earlier login, and for {@code authorization_details} that means a user would keep
 * representing an organisation they did not choose this time. This only holds where the effective sync mode is
 * {@code Force} or {@code Legacy}; under {@code Import} Keycloak updates no mapper after the first login.
 */
public class JsonClaimAttributeMapper extends AbstractClaimMapper {

    public static final String PROVIDER_ID = "json-claim-attribute-idp-mapper";
    public static final String USER_ATTRIBUTE = "user.attribute";

    static final String EMPTY = "[]";

    private static final Logger logger = Logger.getLogger(JsonClaimAttributeMapper.class);

    private static final String[] COMPATIBLE_PROVIDERS = {
        OIDCIdentityProviderFactory.PROVIDER_ID,
        KeycloakOIDCIdentityProviderFactory.PROVIDER_ID,
    };

    /**
     * Keycloak maps these four attribute names onto user properties rather than the attribute table, so writing JSON
     * to one of them would rename the user or overwrite their email address. The built-in importer handles them
     * deliberately; this mapper has no business touching them.
     */
    private static final Set<String> RESERVED_ATTRIBUTES = Set.of(
        UserModel.USERNAME.toLowerCase(Locale.ROOT),
        UserModel.EMAIL.toLowerCase(Locale.ROOT),
        UserModel.FIRST_NAME.toLowerCase(Locale.ROOT),
        UserModel.LAST_NAME.toLowerCase(Locale.ROOT)
    );

    // Declared so Keycloak does not warn about an unsupported sync mode. It does not decide whether the mapper runs:
    // Keycloak calls updateBrokeredUser under Force, updateBrokeredUserLegacy under Legacy, and neither under Import.
    private static final Set<IdentityProviderSyncMode> SYNC_MODES =
            new HashSet<>(Arrays.asList(IdentityProviderSyncMode.values()));

    private static final List<ProviderConfigProperty> configProperties = new ArrayList<>();

    static {
        ProviderConfigProperty claim = new ProviderConfigProperty();
        claim.setName(CLAIM);
        claim.setLabel("Claim");
        claim.setHelpText("Name of the claim to import, read from the ID token or the access token. Nested claims are "
                + "referenced with dots, for example 'a.b'. To use a dot literally, escape it with a backslash.");
        claim.setType(ProviderConfigProperty.STRING_TYPE);
        claim.setDefaultValue("authorization_details");
        configProperties.add(claim);

        ProviderConfigProperty attribute = new ProviderConfigProperty();
        attribute.setName(USER_ATTRIBUTE);
        attribute.setLabel("User Attribute Name");
        attribute.setHelpText("Name of the user attribute to store the claim in, as JSON. Cannot be username, email, "
                + "firstName or lastName.");
        attribute.setType(ProviderConfigProperty.STRING_TYPE);
        configProperties.add(attribute);
    }

    @Override
    public boolean supportsSyncMode(IdentityProviderSyncMode syncMode) {
        return SYNC_MODES.contains(syncMode);
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return configProperties;
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public String[] getCompatibleProviders() {
        return COMPATIBLE_PROVIDERS;
    }

    @Override
    public String getDisplayCategory() {
        return "Attribute Importer";
    }

    @Override
    public String getDisplayType() {
        return "JSON Claim To Attribute";
    }

    @Override
    public String getHelpText() {
        return "Import a structured claim from the ID token or access token into a user attribute, keeping it as "
                + "JSON. Use this instead of the built-in attribute importer for object and array claims, which that "
                + "one flattens into an unparseable string.";
    }

    @Override
    public void preprocessFederatedIdentity(KeycloakSession session, RealmModel realm,
                                            IdentityProviderMapperModel mapperModel, BrokeredIdentityContext context) {
        String attribute = attributeName(mapperModel);
        if (attribute == null || claimName(mapperModel) == null) {
            return;
        }
        context.setUserAttribute(attribute, claimAsJson(mapperModel, context));
    }

    @Override
    public void updateBrokeredUser(KeycloakSession session, RealmModel realm, UserModel user,
                                   IdentityProviderMapperModel mapperModel, BrokeredIdentityContext context) {
        String attribute = attributeName(mapperModel);
        if (attribute == null || claimName(mapperModel) == null) {
            return;
        }
        String json = claimAsJson(mapperModel, context);
        if (!Objects.equals(json, user.getFirstAttribute(attribute))) {
            user.setSingleAttribute(attribute, json);
        }
    }

    /**
     * @return the configured claim name, or null when it is missing. Without this guard Keycloak's claim lookup
     *         throws on a null claim name and the user sees an error page instead of a login.
     */
    private String claimName(IdentityProviderMapperModel mapperModel) {
        String claim = mapperModel.getConfig().get(CLAIM);
        if (claim == null || claim.isBlank()) {
            logger.warnf("Mapper '%s' has no claim configured, skipping", mapperModel.getName());
            return null;
        }
        return claim;
    }

    private String attributeName(IdentityProviderMapperModel mapperModel) {
        String attribute = mapperModel.getConfig().get(USER_ATTRIBUTE);
        if (attribute == null || attribute.isBlank()) {
            return null;
        }
        attribute = attribute.trim();
        if (RESERVED_ATTRIBUTES.contains(attribute.toLowerCase(Locale.ROOT))) {
            logger.warnf("Mapper '%s' targets reserved attribute '%s', which Keycloak maps onto a user property. "
                    + "Skipping to avoid overwriting it.", mapperModel.getName(), attribute);
            return null;
        }
        return attribute;
    }

    private String claimAsJson(IdentityProviderMapperModel mapperModel, BrokeredIdentityContext context) {
        Object value = getClaimValue(mapperModel, context);
        if (value == null) {
            return EMPTY;
        }
        try {
            return JsonSerialization.writeValueAsString(value);
        } catch (Exception e) {
            // Fail closed: an unreadable claim must not leave an earlier login's value in place. Logged at error
            // because the user ends up logged in with none of the authorities this claim grants.
            logger.errorf(e, "Could not serialise claim '%s' to JSON, storing an empty value instead",
                    mapperModel.getConfig().get(CLAIM));
            return EMPTY;
        }
    }
}
