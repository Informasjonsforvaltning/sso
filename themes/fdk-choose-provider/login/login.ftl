<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo displayWide=(realm.password && social.providers??); section>
    <#if section = "form">
        <div class="choose_idp_container">
            <div id="kc-form" class="row">
                <div class="col-xs-12 col-sm-6 cell">
                    <div class="jumbotron h-100">
                        <#assign p = social.providers[1]>
                        <a href="${p.loginUrl}"
                           class="choose_idp_button">
                            <span>Logg inn via ID-porten</span></a>
                        <p>For deg som har fått tilgang til tjenesten "Registrere i datakatalog" i Altinn.</p>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-6 cell">
                    <div class="jumbotron h-100">
                        <#assign p = social.providers[2]>
                        <a href="${p.loginUrl}"
                           class="choose_idp_button">
                            <span>Logg inn via Felles brukerhåndtering</span></a>
                        <p>For deg som tidligere brukte registreringsløsningen på data.norge.no.</p>
                    </div>
                </div>
            </div>

            <div style="margin:3rem">
                <p>
                    <strong>Trenger du eller andre tilgang?</strong><br>
                    Du kan få tilgang eller gi andre tilgang til å registrere datasettbeskrivelser, API-beskrivelser og begreper
                    for din virksomhet. <a href="https://fellesdatakatalog.digdir.no/about-registration">Lær hvordan man får og gir tilgang.</a>
                </p>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>
