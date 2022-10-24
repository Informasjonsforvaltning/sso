var System = Java.type("java.lang.System");
var StringBuilder = Java.type("java.lang.StringBuilder");
var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");

var forEach = Array.prototype.forEach;

var urlBuilder = new StringBuilder();

urlBuilder.append("http://user-api:8080/authorities/");

var isDifiLogin = false;
var isBrregLogin = false;
forEach.call(user.getAttribute("login_type"), function(type){
    if (type === "difi") {
        isDifiLogin = true;
    }
    if (type === "brreg") {
        isBrregLogin = true;
    }
});

if (isDifiLogin) {
    var orgs = user.getAttribute("orgnr");
    var roles = user.getAttribute("difi_roles");

    urlBuilder.append("difi?roles=");

    forEach.call(roles, function(role, index) {
        if (index !== 0) {
            urlBuilder.append(",");
        }

        urlBuilder.append(role.replace("brukar ", ""));
    });

    urlBuilder.append("&orgs=");

    forEach.call(orgs, function(org, index) {
        if (index !== 0) {
            urlBuilder.append(",");
        }

        urlBuilder.append(org);
    });

} else if (isBrregLogin) {
    urlBuilder.append("brreg");
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
