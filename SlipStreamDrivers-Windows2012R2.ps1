Get-WindowsImage -ImagePath .\ISO\sources\install.wim 
Mount-WindowsImage -Path .\Mount -ImagePath .\ISO\sources\install.wim -Index 2 
Add-WindowsDriver -Path .\Mount -Driver .\Drivers -Recurse
Dismount-WindowsImage -Path .\Mount -Commit

Get-WindowsImage -ImagePath .\ISO\sources\boot.wim 
Mount-WindowsImage -Path .\Mount -ImagePath .\ISO\sources\boot.wim -Index 2 
Add-WindowsDriver -Path .\Mount -Driver .\Drivers -Recurse
Dismount-WindowsImage -Path .\Mount -Save 

C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\oscdimg.exe -n -m -bc:\tmp\ISO\boot\etfsboot.com C:\tmp\ISO C:\tmp\win12.iso 