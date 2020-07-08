Get-ADGroupMember -Identity "DRE CRC USERS" |
ForEach {

    Get-ADUser -Filter "EmailAddress -eq '$($_.email)'" -Properties EmailAddress

}