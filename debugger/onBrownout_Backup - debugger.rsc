# <eBrownOutBackup> #
# ==============================
# Backup Active Users Time v1.0a
# by: Chloe Renae & Edmar Lozada
# ------------------------------
{
if ([len [ip hotspot active find session-time-left>0]]>0) do={
  local obBackup "<eBrownOutBackup>"
  log info ("( $obBackup ) Beg => $[system clock get time]")
  system scheduler set [find name=$obBackup] disabled=yes
  local aHSU; local aHSA;
  foreach i in=[ip hotspot active find session-time-left>0] do={ do {
    set aHSA [ip hotspot active get $i]
    set aHSU [ip hotspot user get [find name=($aHSA->"user")]]
    if ([system scheduler find name=($aHSA->"user")]!="") do={
      system scheduler set [find name=($aHSA->"user")] comment="- active -,$($aHSA->"user"),$($aHSU->"uptime"),$($aHSA->"uptime")";
      log info "( $obBackup ) User:[ $($aHSA->"user") ] UsrLT:[ $($aHSU->"limit-uptime") ] UsrUT:[ $($aHSU->"uptime") ] ActUT:[ $($aHSA->"uptime") ]"
    } else={ log warning "( $obBackup ) ERROR: [ $($aHSA->"user") ] scheduler not found!" }
  } on-error={ log warning "( $obBackup ) ERROR: [ $1 ] invalid data!" } }
  system scheduler set [find name=$obBackup] disabled=no
  log info ("( $obBackup ) End => $[system clock get time]")
}
}

# ------------------------------

execute [system scheduler get [find name=<eBrownOutBackup>] on-event]

# ------------------------------

put [ip hotspot active find session-time-left>0]
put [len [ip hotspot active find session-time-left>0]]
put ([len [ip hotspot active find session-time-left>0]]>0)

  foreach i in=[ip hotspot active find session-time-left>0] do={ do {
    local aHSA [ip hotspot active get $i]
    local aHSU [ip hotspot user get [find name=($aHSA->"user")]]
    put ($aHSA->"user")
    put [system scheduler find name=($aHSA->"user")]
    put ([system scheduler find name=($aHSA->"user")]!="")
  }}
