# Stringing commands together using the Pipe | symbol

Get-Item -Path C:\Users\trmye\Documents
Get-Item -Path C:\Users\trmye\Documents | Get-ChildItem
Get-Item -Path C:\Users\trmye\Documents | Get-ChildItem | Get-Member
