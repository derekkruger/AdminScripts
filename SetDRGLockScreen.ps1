#SET THE DEFAULT LOGIN SCREEN BACKGROUND TO DRG BRANDED
function SetLockScreenBackground 
{
	$WindowsVersion = [System.Environment]::OSVersion.Version.Major
	# Copy relevant lockscreen backgrounds to the public user pictures folder
	$LockScreenSource = '\\superfast02\it\scripts\INSTALL\DRGBackgroup.jpg'
	$LockScreenDestination = 'C:\Users\Public\Pictures'
	Copy-Item $LockScreenSource $LockScreenDestination -Force
	# Figures out your primary monitor dimensions (hit or miss for me) and finds the file name you need
	Add-Type -AssemblyName System.Windows.Forms
	$ImageWithDimensions = "background{0}x{1}.jpg" -f [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width,[System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
	if ($WindowsVersion -eq 6) {
		$LockScreenSource = 'C:\Users\Public\Pictures\' + $ImageWithDimensions
		if (!(Test-Path $LockScreenSource)) {
			# If there's a non-standard screen resolution, just set it to 1080p
			$LockScreenSource = 'C:\Users\Public\Pictures\background1920x1080.jpg'
		}
		$LockScreenDestination = 'C:\Windows\System32\oobe\info\backgrounds\backgrounddefault.jpg'
		Copy-Item $LockScreenSource $LockScreenDestination -Force
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background" -Name "OEMBackground" -Value 1 -Force | Out-Null
	} elseif ($WindowsVersion -eq 10) {
		$LockScreenImage = "C:\Users\Public\Pictures\$ImageWithDimensions"
		if (!(Test-Path $LockScreenImage)) {
			# If there's a non-standard screen resolution, just set it to 1080p
			$LockScreenImage = "C:\Users\Public\Pictures\background1920x1080.jpg"
		}
		# Applicable only for Windows 10 v1703 and later build versions
		# https://docs.microsoft.com/en-us/windows/client-management/mdm/personalization-csp
		# https://docs.microsoft.com/en-us/windows/client-management/mdm/sharedpc-csp
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedPC" -Name "SetEduPolicies" -Value 1 -PropertyType DWORD -Force | Out-Null
		$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
		if (!(Test-Path $RegKeyPath)) {
			New-Item -Path $RegKeyPath -Force | Out-Null
		}
        New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageStatus" -Value 1 -PropertyType DWORD -Force | Out-Null
        New-ItemProperty -Path $RegKeyPath -Name "LockScreenImagePath" -Value $LockScreenImage -PropertyType STRING -Force | Out-Null
        New-ItemProperty -Path $RegKeyPath -Name "LockScreenImageUrl" -Value $LockScreenImage -PropertyType STRING -Force | Out-Null
	}
}

#SetLockScreenBackground