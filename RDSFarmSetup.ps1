New-RDSessionDeployment -ConnectionBroker RDSBRK01.DRE.COM `
                        -SessionHost RDSDESK01.DRE.COM `
                        -WebAccessServer RDSWEB01.DRE.COM

Add-RDServer -Server RDSAPP01.DRE.COM `
             -Role RDS-RD-SERVER `
             -ConnectionBroker RDSBRK01.DRE.COM
 
Add-RDServer -Server RDSBRK01.DRE.COM `
             -Role RDS-Licensing `
             -ConnectionBroker RDSBRK01.DRE.COM
 
Add-RDServer -Server RDSWEB01.DRE.COM `
             -Role RDS-Gateway `
             -ConnectionBroker RDSBRK01.DRE.COM `
             -GatewayExternalFqdn gateway.drgtech.com