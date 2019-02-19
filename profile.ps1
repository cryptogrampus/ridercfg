function syncCfg {
  Set-Location ~/github.com/cfg
  git pull
  $status = (git status --porcelain) | Out-String
  if ($status.Length -gt 0) {
      git add --all
      $status = (git status --porcelain) | Out-String
      $status.Replace("`n", ", ")
      git commit -am $status
      git push
      }
  }

syncCfg

function cdg ($repo) {
  cd ~/github.com/$repo
}


Import-Module posh-git
Set-Location ~/jet-tfs.visualstudio.com/superman
Set-Alias g -Value git
Set-Alias p -Value .paket/paket.exe
Push-Location "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools"
cmd /c "VsDevCmd.bat&set" |
ForEach-Object {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
Pop-Location
Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow
function cobspm ($srcBranch,$branchName) {
    g co $srcBranch
    g pull
    g cob $branchName
    g push -u origin $branchName
    g cob aaron/$branchName
    g push -u origin aaron/$branchName
}

function spm_mm ($branch) {
    g co master
    g pull
    g co $branch
    g merge master
    g push
    g co aaron/$branch
    g merge master
    g push
}

Register-EngineEvent PowerShell.Exiting -Action { syncCfg }
$appCurrentDomain = [System.AppDomain]::CurrentDomain
Register-ObjectEvent -Action { syncCfg } ` -InputObject $appCurrentDomain -EventName DomainUnload -SourceIdentifier App.DomainUnload