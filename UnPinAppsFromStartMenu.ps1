function Pin-App { param(
[string]$appname,
[switch]$unpin
)
try{
if ($unpin.IsPresent){
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name}).Verbs() | ?{$_.Name.replace('&','') -match 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}
return "App '$appname' unpinned from Start"
}else{
((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'To "Start" Pin|Pin to Start'} | %{$_.DoIt()}
return "App '$appname' pinned to Start"
}
}catch{
Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
}
}

Pin-App "Mail" -unpin
Pin-App "Store" -unpin
Pin-App "Calendar" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Weather" -unpin
Pin-App "Phone Companion" -unpin
Pin-App "Music" -unpin
Pin-App "xbox" -unpin
Pin-App "movies & tv" -unpin
Pin-App "microsoft solitaire collection" -unpin
Pin-App "money" -unpin
Pin-App "get office" -unpin
Pin-App "onenote" -unpin
Pin-App "news" -unpin