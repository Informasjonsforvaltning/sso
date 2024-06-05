<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo displayWide=(realm.password && social.providers??); section>
    <#if section = "form">
        <div class="container-fluid">
            <div id="kc-form" class="row">
                <div class="col-xs-12 col-sm-6 pd-r">
                    <div class="fdk-card h-100 mb-5">
                        <p>For deg som har fått tilgang til tjenesten "Registrere i datakatalog" i Altinn.</p>
                        <#assign p = social.providers[0]>
                        <a href="${p.loginUrl}"
                           class="choose_idp_button">
                            <span>Logg inn via ID-porten</span>
                        </a>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6">
                    <div class="fdk-card h-100  mb-5">
                        <p>For deg som tidligere brukte registreringsløsningen på data.norge.no.</p>
                        <#assign p = social.providers[1]>
                        <a href="${p.loginUrl}"
                           class="choose_idp_button">
                            <span>Logg inn via Felles brukerhåndtering</span>
                        </a>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 pd-r">
                    <div class="fdk-card h-100 mb-5">
                        <span class="logo-wrapper-brreg">
                            <img src="${url.resourcesPath}/img/logo-brreg.svg" alt="Brønnøysundregistrene">
                        </span>
                        <#assign p = social.providers[2]>
                        <a href="${p.loginUrl}"
                            class="choose_idp_button choose_brreg_idp_button"
                            aria-label="Logg inn som ansatt i Brønnøysundregistrene">
                            <span>Logg inn som ansatt</span>
                        </a>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6">
                    <div class="fdk-card h-100 mb-5">
                        <span class="logo-wrapper-skatt">
                            <img src="${url.resourcesPath}/img/logo-skatt.svg" alt="Skatteetaten">
                        </span>
                        <#assign p = social.providers[3]>
                        <a href="${p.loginUrl}"
                            class="choose_idp_button choose_skatt_idp_button"
                            aria-label="Logg inn som ansatt i Skatteetaten">
                            <span>Logg inn som ansatt</span>
                        </a>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <p>
                        <strong>Trenger du eller andre tilgang?</strong><br>
                        Du kan få tilgang til eller gi andre tilgang til å registrere behandlingsaktiviteter, datasett-, begrep-, tjeneste- og API-beskrivelser og administrere høsting
                        for din virksomhet. <a href="https://samarbeid.digdir.no/felles-datakatalog/ta-i-bruk-felles-datakatalog/1619">Lær mer om hvordan man får og gir tilgang.</a>
                    </p>
                </div>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
