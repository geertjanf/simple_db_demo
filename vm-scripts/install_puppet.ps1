Write-Output "Installing Puppet..."
cd c:\vagrant\modules\software\files
Start-Process C:\Windows\System32\msiexec.exe -ArgumentList "/qn /norestart /i puppet-agent-6.0.4-x64.msi INSTALLDIR=C:\puppetlabs" -wait
Write-Output "Puppet installed"
