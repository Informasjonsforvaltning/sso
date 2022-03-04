var System = Java.type("java.lang.System");
var StringBuilder = Java.type("java.lang.StringBuilder");
var SimpleHttp = Java.type("org.keycloak.broker.provider.util.SimpleHttp");

var forEach = Array.prototype.forEach;

var urlBuilder = new StringBuilder();

urlBuilder.append("http://user-api:8080/terms/");

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
    urlBuilder.append("difi?orgs=");

    forEach.call(orgs, function(org, index) {
        if (index !== 0) {
            urlBuilder.append(",");
        }

        urlBuilder.append(org);
    });

} else if (isOkLogin) {
    var orgnames = user.getAttribute("ok_orgnames");
    urlBuilder.append("oslokommune?orgnames=");

    forEach.call(orgnames, function(org, index) {
        if (index !== 0) {
            urlBuilder.append(",");
        }

        urlBuilder.append(org);
    });

} else {
    urlBuilder.append("altinn/");
    urlBuilder.append(user.username);
}

var url = urlBuilder.toString()

exports = SimpleHttp.doGet(url, keycloakSession).header("X-API-KEY", System.getenv().get("USER_API_KEY")).asString();