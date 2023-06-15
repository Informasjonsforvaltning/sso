<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayWide=false>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}" lang="nb-NO">

<head>
    <#assign p = social.providers[1]>
    <meta http-equiv="refresh" content="0; url='${p.loginUrl}'" />
</head>

<body class="${properties.kcBodyClass!}">
    <#nested "form">
</body>
</html>
</#macro>
