var System = Java.type("java.lang.System");
var JavaString = Java.type("java.lang.String");
var StringBuilder = Java.type("java.lang.StringBuilder");
var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");
var Collectors = Java.type("java.util.stream.Collectors");

var urlBuilder = new StringBuilder();

urlBuilder.append("http://user-api:8080/terms/");

var loginType = user.getFirstAttribute("login_type");

if (loginType === "difi") {
    var orgs = user.getAttributeStream("orgnr")
        .collect(Collectors.toUnmodifiableList());
    urlBuilder.append("difi?orgs=");
    urlBuilder.append(JavaString.join(",", orgs));

} else if (loginType === "brreg") {
    urlBuilder.append("brreg");
} else {
    urlBuilder.append("altinn/");
    urlBuilder.append(user.username);
}

var url = urlBuilder.toString()

exports = SimpleHttp.doGet(url, keycloakSession).header("X-API-KEY", System.getenv().get("USER_API_KEY")).asString();
