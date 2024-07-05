<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <script>
            document.title =  "${msg("frontchannel-logout.title")}";
        </script>
        ${msg("frontchannel-logout.title")}
    <#elseif section = "form">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xs-12">
                    <p>Vi logger deg ut, vennligst vent et øyeblikk.</p>
                    <#list logout.clients as client>
                        <iframe src="${client.frontChannelLogoutUrl}" style="display:none;"></iframe>
                    </#list>                     
                </div>
            </div>
        </div>
        <#if logout.logoutRedirectUri?has_content>
            <script>
                setTimeout(() => {
                    window.location.replace('${logout.logoutRedirectUri}');
                }, 3000)
            </script>
        </#if> 
    </#if>
</@layout.registrationLayout>
