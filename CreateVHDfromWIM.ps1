Get-Module Convert-WindowsImage
$iso = 'D:\VHDS\install.wim'
$workdir = 'D:\VHDS\'
$vhdpath = 'D:\VHDS\thevhd.vhdx'

# Made the script a module and loaded it that way
# Load (aka "dot-source) the Function 
#. .\Convert-WindowsImage.ps1 
# Prepare all the variables in advance (optional) 
$ConvertWindowsImageParam = @{  
    SourcePath          = $iso 
    RemoteDesktopEnable = $True  
    Passthru            = $True  
    Edition    = "Windows10Pro"
    VHDFormat = "VHDX"
    SizeBytes = 60GB
    WorkingDirectory = $workdir
    VHDPath = $vhdpath
    VHDPartitionStyle = 'GPT'
}

$VHDx = Convert-WindowsImage @ConvertWindowsImageParam