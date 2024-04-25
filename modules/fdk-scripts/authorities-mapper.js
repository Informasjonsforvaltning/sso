var System = Java.type("java.lang.System");
var JavaString = Java.type("java.lang.String");
var StringBuilder = Java.type("java.lang.StringBuilder");
var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");
var Collectors = Java.type("java.util.stream.Collectors");

var urlBuilder = new StringBuilder();

urlBuilder.append("http://user-api:8080/authorities/");

var loginType = user.getFirstAttribute("login_type");

if (loginType === "difi") {
    var roles = user.getAttributeStream("difi_roles")
        .map(function(role) { return role.replace("brukar ", ""); })
        .collect(Collectors.toUnmodifiableList());

    urlBuilder.append("difi?roles=");
    urlBuilder.append(JavaString.join(",", roles));

    var orgs = user.getAttributeStream("orgnr")
        .collect(Collectors.toUnmodifiableList());

    urlBuilder.append("&orgs=");
    urlBuilder.append(JavaString.join(",", orgs));
} else if (loginType === "brreg") {
    var brregGroups = user.getAttributeStream("brreg_groups")
        .collect(Collectors.toUnmodifiableList());

    urlBuilder.append("brreg?groups=");
    urlBuilder.append(JavaString.join(",", brregGroups));
} else if (loginType === "skatt") {
    var skattGroups = user.getAttributeStream("skatt_groups")
        .collect(Collectors.toUnmodifiableList());

    urlBuilder.append("skatt?groups=");
    urlBuilder.append(JavaString.join(",", skattGroups));
} else {
    urlBuilder.append("altinn/");
    urlBuilder.append(user.username);
}

var url = urlBuilder.toString();
var timeout = 30000;
var response = SimpleHttp.doGet(url, keycloakSession)
    .socketTimeOutMillis(timeout)
    .connectTimeoutMillis(timeout)
    .header("X-API-KEY", System.getenv().get("USER_API_KEY"))
    .asResponse();
if (response.getStatus() === 200) {
    exports = response.asString();
} else {
    throw new Error('User-api authorities status: ' + response.getStatus());
}
