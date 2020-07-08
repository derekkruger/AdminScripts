# Define Path to the Windows Server 2019 ISO
$ISOFile = "D:\SCRIPTS\Server2019.iso"

# Get the USB Drive you want to use, copy the friendly name
Get-Disk | Where-Object BusType -eq "USB"

# Get the right USB Drive (You will need to change the FriendlyName)

$USBDrive = Get-Disk | Where-Object FriendlyName -eq "SanDisk Cruzer Glide"

# Replace the Friendly Name to clean the USB Drive (THIS WILL REMOVE EVERYTHING)
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru

# Convert Disk to GPT
$USBDrive | Initialize-Disk -PartitionStyle GPT

# Create partition primary and format to FAT32
$Volume = $USBDrive | New-Partition -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel WS2019

# Mount iso
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru

# Driver letter
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter

# Copy Files to USB (except install.wim)
Copy-Item -Path ($ISODriveLetter + ":\*") -Destination ($Volume.DriveLetter + ":\") -Recurse

# Dismount ISO
Dismount-DiskImage -ImagePath $ISOFile