var System = Java.type("java.lang.System");
var UUID = Java.type("java.util.UUID");

var uuidBase = System.getenv().get("FDK_CLIENT_SECRET") + user.getUsername();

exports = UUID.nameUUIDFromBytes(uuidBase.getBytes());
