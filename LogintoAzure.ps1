$cred=Get-Credential
$sess = New-PSSession -Credential $cred -ComputerName host03.dre.com
Enter-PSSession $sess