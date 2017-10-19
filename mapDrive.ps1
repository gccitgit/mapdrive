Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Map Network Drive"
$Form.TopMost = $true
$Form.Width = 300
$Form.Height = 240

$labelPC = New-Object system.windows.Forms.Label
$labelPC.Text = "Which PC?"
$labelPC.AutoSize = $true
$labelPC.Width = 25
$labelPC.Height = 10
$labelPC.location = new-object system.drawing.point(10,20)
$labelPC.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($labelPC)

$textboxPC = New-Object system.windows.Forms.TextBox
$textboxPC.Width = 100
$textboxPC.Height = 20
$textboxPC.location = new-object system.drawing.point(10,44)
$textboxPC.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($textboxPC)

$labelUser = New-Object system.windows.Forms.Label
$labelUser.Text = "Username?"
$labelUser.AutoSize = $true
$labelUser.Width = 25
$labelUser.Height = 10
$labelUser.location = new-object system.drawing.point(10,90)
$labelUser.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($labelUser)

$textboxUser = New-Object system.windows.Forms.TextBox
$textboxUser.Width = 100
$textboxUser.Height = 20
$textboxUser.location = new-object system.drawing.point(10,113)
$textboxUser.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($textboxUser)

$labelLetter = New-Object system.windows.Forms.Label
$labelLetter.Text = "DriveLetter?"
$labelLetter.AutoSize = $true
$labelLetter.Width = 25
$labelLetter.Height = 10
$labelLetter.location = new-object system.drawing.point(170,19)
$labelLetter.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($labelLetter)

$textboxLetter = New-Object system.windows.Forms.TextBox
$textboxLetter.Width = 100
$textboxLetter.Height = 20
$textboxLetter.location = new-object system.drawing.point(170,43)
$textboxLetter.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($textboxLetter)

$labelPath = New-Object system.windows.Forms.Label
$labelPath.Text = "Share Path?"
$labelPath.AutoSize = $true
$labelPath.Width = 25
$labelPath.Height = 10
$labelPath.location = new-object system.drawing.point(170,89)
$labelPath.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($labelPath)

$textboxPath = New-Object system.windows.Forms.TextBox
$textboxPath.Width = 100
$textboxPath.Height = 20
$textboxPath.location = new-object system.drawing.point(170,114)
$textboxPath.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($textboxPath)

$buttonOK = New-Object system.windows.Forms.Button
$buttonOK.Text = "OK"
$buttonOK.Width = 60
$buttonOK.Height = 30
$buttonOK.location = new-object system.drawing.point(120,165)
$buttonOK.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($buttonOK)
$buttonOK.Add_Click({
    $cred=Get-Credential    
    $PC=$textboxPC.Text
    $User=$textboxUser.Text
    $Letter=$textboxLetter.Text.ToUpper()
    $Path=$textboxPath.Text
    $ntuser="\\"+$PC+"\C$\Users\"+$User+"\ntuser.dat"
    $load = "load HKLM\TempUser $ntuser"
    Start-Process C:\Windows\system32\reg.exe -ArgumentList $load -Credential $cred
    Push-Location
    Set-Location -Path "HKLM:\TempUser"
    New-Item -Path "HKLM:\TempUser\$Letter"
    Set-Location -Path "HKLM:\TempUser\$Letter"
    New-ItemProperty -Name "ConnectionType" -PropertyType "DWORD" -Value 1
    New-ItemProperty -Name "DeferFlags" -PropertyType "DWORD" -Value 4
    New-ItemProperty -Name "ProviderName" -PropertyType "String" -Value "Microsoft Windows Network"
    New-ItemProperty -Name "ProviderType" -PropertyType "DWORD" -Value 131072
    New-ItemProperty -Name "RemotePath" -PropertyType "String" -Value $Path
    New-ItemProperty -Name "UserName" -PropertyType "String"
    Pop-Location
    reg unload "HKLM\TempUser"
    [gc]::collect()
    $form.Close()
    })

$buttonCancel = New-Object system.windows.Forms.Button
$buttonCancel.Text = "Cancel"
$buttonCancel.Width = 60
$buttonCancel.Height = 30
$buttonCancel.location = new-object system.drawing.point(209,165)
$buttonCancel.Font = "Microsoft Sans Serif,10"
$Form.controls.Add($buttonCancel)
$buttonCancel.Add_Click({
    $form.Close()
    })

[void]$Form.ShowDialog()
$Form.Dispose()