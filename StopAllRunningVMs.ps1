# This is a simple script to stop all the currently running VMs on the local # Hyper-V host. It could easily be extended to accept a command line # argument of the name of a remote Hyper-V hosts or a list of hosts into an array 
$VMs = Get-WmiObject MSVM_ComputerSystem -computer "." -namespace "root\virtualization" 
foreach ($vm in $VMs) 
{ if ( $vm.name -ne $vm.elementname ) { # skip the parent's name 
if ( $vm.EnabledState -eq 2 ) 
{ 
    If the VM is running $shutdown = Get-WmiObject MSVM_ComputerSystem ` -namespace "root\virtualization" ` –query “Associators of {$vm} where ResultClass=Msvm_ShutdownComponent” $shutdown.iniateShutdown($true,”System Maintenance”) sleep 5 } 
} 
}