function Remove-AutoMapping {
  param ($usrs = "")
  $mbxs = Get-Mailbox -ResultSize unlimited
  $mbxp = $mbxs |%{Get-MailboxPermission -Identity $_.identity  |?{$_.AccessRights -eq "FullAccess" -and $_.IsInherited -eq $false -and $_.user -ne "NT AUTHORITY\SELF"}}
  foreach ($usr in $usrs){
  $perms = $mbxp |?{$_.user -eq $usr}
    if ($perms){
      foreach ($perm in $perms){
        Remove-MailboxPermission -AccessRights $perm.AccessRights -User $usr -Identity $perm.identity -Confirm:$false
        Add-MailboxPermission -Identity $perm.identity -User $usr -AccessRights:FullAccess -AutoMapping $false
      }
    }
  }
}
