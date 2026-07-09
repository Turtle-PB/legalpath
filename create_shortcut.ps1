$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut("C:\Users\emupa\Desktop\LegalPath.lnk")
$sc.TargetPath = "C:\Users\emupa\LegalPath\index.html"
$sc.IconLocation = "C:\Windows\System32\shell32.dll,17"
$sc.Description = "LegalPath - Case Builder"
$sc.Save()
Write-Output "Shortcut created on Desktop"
