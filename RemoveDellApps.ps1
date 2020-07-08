$apps = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name like '%Dell%'"

foreach ($app in $apps) {
    "Name = " + $app.name
    $app.Uninstall()
}