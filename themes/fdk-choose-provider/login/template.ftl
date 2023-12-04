<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayWide=false>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="login-pf" lang="nb-NO">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
    <#list properties.meta?split(' ') as meta>
    <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
</#list>
</#if>
<title>${msg("loginTitle",(realm.displayName!''))}</title>
<link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
<#if properties.styles?has_content>
<#list properties.styles?split(' ') as style>
<link href="${url.resourcesPath}/${style}" rel="stylesheet" />
</#list>
</#if>
</head>


<body class="login-pf-body">
<div class="login-pf-page">

    <div id="kc-header">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xs-12 d-flex align-items-center">
                    <div id="kc-header-wrapper"></div>
                    <nav id="fdk-nav">
                        <ul class="nav navbar-nav">
                            <li class="navbar-nav__item">
                                <a href="${properties.fdkRegistrationUri}">Registrere data</a>
                            </li>
                            <li class="navbar-nav__item">
                                <a href="${properties.fdkAdminGuiUri}">Høste data</a>
                            </li>
                            <li class="navbar-nav__item">
                                <a class="external_icon" href="${properties.fdkCommunityUri}">Datalandsbyen</a>
                            </li>
                            <li class="navbar-nav__item">
                                <a class="external_icon" href="${properties.fdkPortalUri}">Gå til data.norge.no</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>


    <div id="kc-content" class="mb-5">

        <#nested "form">

    </div>

    <div id="fdk-footer">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xs-12 fdk-footer-wrapper">

                    <div class="fdk-footer-link-list">
                        <strong class="fdk-footer-link-header">Søk i kataloger</strong>
                        <ul class="fdk-footer-links">
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/search-all">Søk i alle kataloger</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/datasets">Søk i datasett</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/apis">Søk i API-er</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/concepts">Søk i begreper</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/informationmodels">Søk i informasjonsmodeller</a></li>
                        </ul>
                    </div>

                    <div class="fdk-footer-link-list">
                        <strong class="fdk-footer-link-header">Innhold</strong>
                        <ul class="fdk-footer-links">
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/guidance">Veiledere og standarder</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/reports">Rapporter</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/about">Om Felles datakatalog</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/about-registration">Hjelp til å registrere</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://fellesdatakatalog.digdir.no/news-archive">Aktuelt</a></li>
                        </ul>
                    </div>

                    <div class="fdk-footer-link-list">
                        <strong class="fdk-footer-link-header">Om nettstedet</strong>
                        <ul class="fdk-footer-links">
                            <li class="fdk-footer-link-list__item"><a href="https://www.digdir.no/om-oss/personvernerklaering/706">Informasjonskapsler og personvern</a></li>
                        </ul>
                    </div>

                    <div class="fdk-footer-link-list">
                        <strong class="fdk-footer-link-header">Kontakt</strong>
                        <ul class="fdk-footer-links">
                            <li class="fdk-footer-link-list__item"><a href="mailto:fellesdatakatalog@digdir.no"><span class="uu-invisible" aria-hidden="false">fellesdatakatalog@digdir.no</a></li>
                            <li class="fdk-footer-link-list__item"><a href="https://twitter.com/datakatalogen">Felles datakatalog på Twitter</a></li>
                        </ul>
                    </div>

                </div>
            </div>

        </div>
    </div>

</div>
</body>
</html>
</#macro>
