Add-Content -Path C:\windows\System32\drivers\etc\hosts. -Value "10.10.1.60 CERM-ENGINE"
Add-Content -Path C:\windows\System32\drivers\etc\hosts. -Value "10.10.1.61 CERM-DATA"
msiexec.exe c:\scripts\install\cerm_drg.msi /passive
