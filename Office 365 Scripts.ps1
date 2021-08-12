# New Domain for Tenant - https://docs.microsoft.com/en-us/powershell/module/msonline/new-msoldomain?view=azureadps-1.0
New-MsolDomain -Name "contoso.com"

# New Domain DNS Records - https://docs.microsoft.com/en-us/powershell/module/msonline/get-msoldomainverificationdns?view=azureadps-1.0
Get-MsolDomainVerificationDNS -DomainName "contoso.com"

# Domain Verification - https://docs.microsoft.com/en-us/powershell/module/msonline/confirm-msoldomain?view=azureadps-1.0
Confirm-MsolDomain -DomainName "contoso.com"

#Set Default Domain - https://docs.microsoft.com/en-us/powershell/module/msonline/set-msoldomain?view=azureadps-1.0
Set-MsolDomain -Name "contoso.com" -IsDefault

#Add Users via Powershell using csv file - https://docs.microsoft.com/en-us/microsoft-365/enterprise/create-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
Import-Csv -Path <Input CSV File Path and Name> | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId [-Password $_.Password]} | Export-Csv -Path <Output CSV File Path and Name>

# Assign License to Office 365 User - https://docs.microsoft.com/en-us/microsoft-365/enterprise/assign-licenses-to-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
# Gets list of SKUs available for Tenant
Get-AzureADSubscribedSku | Select SkuPartNumber
# Check Location
Get-AzureADUser -ObjectID <user sign-in name (UPN)> | Select DisplayName, UsageLocation
# Set Users License
Set-MsolUserLicense -UserPrincipalName "<Account>" -AddLicenses "<AccountSkuId>"

# Reset User Password - https://docs.microsoft.com/en-us/powershell/module/msonline/set-msoluserpassword?view=azureadps-1.0
# Force Password Change with Random Password
Set-MsolUserPassword -UserPrincipalName "davidchew@contoso.com" -ForceChangePassword
# Specify Password
Set-MsolUserPassword -UserPrincipalName "davidchew@consoso.com" -NewPassword "pa$$word"

# Office 365 Groups - https://docs.microsoft.com/en-us/microsoft-365/enterprise/manage-microsoft-365-groups-with-powershell?view=o365-worldwide

# Office 365 Distribution Group - https://docs.microsoft.com/en-us/powershell/module/exchange/get-distributiongroupmember?view=exchange-ps
Get-DistributionGroupMember -Identity "Marketing USA"
# Export to CSV
$DGName = "TestDG"
Get-DistributionGroupMember -Identity $DGName | Select Name, PrimarySMTPAddress |
Export-CSV "C:\Distribution-List-Members.csv" -NoTypeInformation -Encoding UTF8
# Export All Distribution Groups to CSV
$Groups = Get-DistributionGroup
$Groups | ForEach-Object {
$group = $_.Name
$members = ''
Get-DistributionGroupMember $group | ForEach-Object {
        If($members) {
              $members=$members + ";" + $_.Name
           } Else {
              $members=$_.Name
           }
  }
New-Object -TypeName PSObject -Property @{
      GroupName = $group
      Members = $members
     }
} | Export-CSV "C:\Distribution-Group-Members.csv" -NoTypeInformation -Encoding UTF8

# O365 Get Contacts - https://docs.microsoft.com/en-us/powershell/module/msonline/new-msoldomain?view=azureadps-1.0
Get-Contact -Identity MarkusBreyer | Format-List
# O365 Create Contacts - https://docs.microsoft.com/en-us/powershell/module/exchange/new-mailcontact?view=exchange-ps
New-MailContact -Name "Chris Ashton" -ExternalEmailAddress "chris@tailspintoys.com"
# O365 - Create via CSV - https://docs.microsoft.com/en-us/microsoft-365/compliance/bulk-import-external-contacts?view=o365-worldwide
Import-Csv .\ExternalContacts.csv|%{New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress -FirstName $_.FirstName -LastName $_.LastName}

# O365 / Azure Setup Guest User - https://docs.microsoft.com/en-us/azure/active-directory/external-identities/b2b-quickstart-invite-powershell
Connect-AzureAD -TenantDomain "<Tenant_Domain_Name>"
New-AzureADMSInvitation -InvitedUserDisplayName "Sanda" -InvitedUserEmailAddress sanda@fabrikam.com -InviteRedirectURL https://myapps.microsoft.com -SendInvitationMessage $true
# Delete Guest User
Remove-AzureADUser -ObjectId "<UPN>"
