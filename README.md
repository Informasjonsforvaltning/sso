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
