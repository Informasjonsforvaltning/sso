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
    var groups = user.getAttributeStream("brreg_groups")
        .collect(Collectors.toUnmodifiableList());

    urlBuilder.append("brreg?groups=");
    urlBuilder.append(JavaString.join(",", groups));
} else {
    urlBuilder.append("altinn/");
    urlBuilder.append(user.username);
}

var url = urlBuilder.toString();
var response = SimpleHttp.doGet(url, keycloakSession).header("X-API-KEY", System.getenv().get("USER_API_KEY")).asResponse();
if (response.getStatus() === 200) {
    exports = response.asString();
} else {
    throw new Error('User-api authorities status: ' + response.getStatus());
}
