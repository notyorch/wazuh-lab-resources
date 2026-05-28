@ECHO OFF
"C:\Program Files\PowerShell\7\pwsh.exe" -ExecutionPolicy Bypass -File "C:\Program Files (x86)\ossec-agent\active-response\bin\wfblock.ps1" %*
EXIT /B
