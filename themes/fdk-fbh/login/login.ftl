<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo displayWide=(realm.password && social.providers??); section>
  <#assign p = social.providers[2]>
  <p>Please follow <a href="${p.loginUrl}">this link</a>.</p>
</@layout.registrationLayout>
