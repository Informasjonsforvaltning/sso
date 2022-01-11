var System = Java.type("java.lang.System");
var StringBuilder = Java.type("java.lang.StringBuilder");
var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");

var forEach = Array.prototype.forEach;

var urlBuilder = new StringBuilder();

urlBuilder.append("http://user-api:8080/authorities/");

var isDifiLogin = false;
var isOkLogin = false;
forEach.call(user.getAttribute("login_type"), function(type){
    if (type === "difi") {
        isDifiLogin = true;
    }
    if (type === "ok") {
        isOkLogin = true;
    }
});

if (isDifiLogin) {
    var orgs = user.getAttribute("orgnr");
    var roles = user.getAttribute("difi_roles");

    var firstInList = true;
    urlBuilder.append("difi?roles=");

    forEach.call(roles, function(role) {
        if (firstInList !== true) {
            urlBuilder.append(",");
        } else {
            firstInList = false;
        }

        urlBuilder.append(role.replace("brukar ", ""));
    });

    firstInList = true;
    urlBuilder.append("&orgs=");

    forEach.call(orgs, function(org) {
        if (firstInList !== true) {
            urlBuilder.append(",");
        } else {
            firstInList = false;
        }

        urlBuilder.append(org);
    });

} else if (isOkLogin) {
    var roles = user.getAttribute("ok_roles");
    var orgnames = user.getAttribute("ok_orgnames");

    var firstInList = true;
    urlBuilder.append("oslokommune?roles=");
    forEach.call(roles, function(role) {
        if (firstInList !== true) {
            urlBuilder.append(",");
        } else {
            firstInList = false;
        }

        urlBuilder.append(role);
    });

    var firstInList = true;
    urlBuilder.append("&orgnames=");
    forEach.call(orgnames, function(orgname) {
        if (firstInList !== true) {
            urlBuilder.append(",");
        } else {
            firstInList = false;
        }

        urlBuilder.append(orgname);
    });

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
