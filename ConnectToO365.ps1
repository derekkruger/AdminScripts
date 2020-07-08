$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
