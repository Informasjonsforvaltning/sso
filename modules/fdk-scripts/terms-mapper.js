var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");

var url = "http://terms-and-conditions:8080/terms/latest/version"

exports = SimpleHttp.doGet(url, keycloakSession).asString();
