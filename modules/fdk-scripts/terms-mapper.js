var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");

var url = "http://terms-and-conditions:8080/terms/latest/version";
var timeout = 30000;

exports = SimpleHttp.doGet(url, keycloakSession)
    .socketTimeOutMillis(timeout)
    .connectTimeoutMillis(timeout)
    .asString();
