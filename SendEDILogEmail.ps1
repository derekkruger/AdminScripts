
$SmtpServer = 'smtp.office365.com'
$SmtpUser = 'Priyaranjan@SharePointChronicle.com'
$smtpPassword = ‘<Input Office 365 Password Here>’
$MailtTo = 'kspriyaranjan@gmail.com'
$MailFrom = 'Priyaranjan@SharePointChronicle.com'
$MailSubject = "Test using $SmtpServer"
$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $SmtpUser, $($smtpPassword | ConvertTo-SecureString -AsPlainText -Force)
Send-MailMessage -To "$MailtTo" -from "$MailFrom" -Subject $MailSubject -Body "$Body" -SmtpServer $SmtpServer -BodyAsHtml -UseSsl -Credential $Credentials
write-Output "Custom Message : REST Service JSON Data parsed and Email Sent to Business Users"