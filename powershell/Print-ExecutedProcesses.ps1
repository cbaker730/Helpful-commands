#Set-ExecutionPolicy Bypass -Scope CurrentUser

Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4688
    StartTime=[datetime]::Today
} | Select-Object @{name='NewProcessName';expression={ $_.Properties[5].Value }} | select * -Unique
