# SSO

This application provides single sign-on with identity and access management.
It's a based on [Keycloak](https://www.keycloak.org) with added custom mappers and themes.

For a broader understanding of the system’s context, refer to
the [architecture documentation](https://github.com/Informasjonsforvaltning/architecture-documentation) wiki. For more
specific context on this application, see the **IAM** subsystem section.

## Getting Started

These instructions will give you a copy of the project up and running on your local machine for development and testing
purposes.

### Prerequisites

Ensure you have the following installed:

- Docker

### Running locally

Clone the repository

```sh
git clone https://github.com/Informasjonsforvaltning/sso.git
cd sso
```

#### Start proxy and the application via CLI:

```sh
docker compose up -d
```

### API Documentation (OpenAPI)

The API documentation is available at ```https://www.keycloak.org/docs/latest/api_documentation/index.html```.
The OpenAPI definition is available at ```https://www.keycloak.org/docs-api/latest/rest-api/openapi.json```.

## Custom extensions

Everything under `modules/` is packaged into `/opt/keycloak/providers/` in the image.

- `rest-user-mapper` (Java)
  - `no.fdk.keycloak.restuser.RestUserAttributeMapper`: identity provider mapper that looks a brokered
    user up in a REST endpoint (user-api) and imports the returned fields.
  - `no.fdk.keycloak.rar.AnsattportenAuthorizationDetailsProcessor`: lets `authorization_details`
    entries of type `ansattporten:altinn:resource` through Keycloak's request validation so the
    Ansattporten identity provider can forward them (add `authorization_details` to the provider's
    "Forwarded query parameters"). Keycloak grants nothing itself; the chosen organisation comes back
    in the brokered id_token. Accepted Altinn resources come from `ANSATTPORTEN_ALTINN_RESOURCES`
    (comma separated ids, default: the three `datanorge-*` access resources). `actions` must be a
    JSON array, not the comma separated string in Ansattporten's docs. The type is advertised as
    `authorization_details_types_supported` in every realm's discovery document.
  - `no.fdk.keycloak.mapper.JsonClaimAttributeMapper`: identity provider mapper that imports a
    structured claim into a user attribute as JSON. Keycloak's built-in "Attribute Importer" calls
    `toString()` on the value first, which turns an object claim into `{a=[{b=c}]}`. That has no
    quoting, so a value containing a comma or an equals sign, such as an organisation name, becomes
    ambiguous, and no JSON parser accepts it. Use this mapper for object and array claims, in place
    of the built-in importer. Shown in the admin console as "JSON Claim To Attribute".
    - On the Ansattporten identity provider, configure it with claim `authorization_details` and
      user attribute `ansattporten_authorization_details`, which is the name
      `modules/fdk-scripts/authorities-mapper.js` reads.
    - The identity provider's sync mode must be `Force` or `Legacy`. Under `Import` Keycloak updates
      no mapper after the first login, so the attribute would keep the first login's organisations.
    - Array-of-object claims are read from the ID token and access token only. Keycloak's user info
      path keeps only the textual members of an array, so such a claim arrives empty from there.
    - When the claim is absent the attribute is set to an empty JSON array rather than left alone,
      so a login without representation cannot leave an earlier login's organisations behind.
- `fdk-scripts` (JavaScript): protocol and identity provider mappers deployed through the
  `scripts` feature.
