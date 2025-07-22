# <eBrownOutBackup> #
# ==============================
# Backup Active Users Time v1.0a
# by: Chloe Renae & Edmar Lozada
# ------------------------------
if ([len [ip hotspot active find session-time-left>0]]>0) do={
  local obBackup "<eBrownOutBackup>"
  system scheduler set [find name=$obBackup] disabled=yes
  local aHSU; local aHSA;
  foreach i in=[ip hotspot active find session-time-left>0] do={ do {
    set aHSA [ip hotspot active get $i]
    set aHSU [ip hotspot user get [find name=($aHSA->"user")]]
    if ([system scheduler find name=($aHSA->"user")]!="") do={
      system scheduler set [find name=($aHSA->"user")] comment="- active -,$($aHSA->"user"),$($aHSU->"uptime"),$($aHSA->"uptime")";
    } else={ log warning "( $obBackup ) ERROR: [ $($aHSA->"user") ] scheduler not found!" }
  } on-error={ log warning "( $obBackup ) ERROR: [ $1 ] invalid data!" } }
  system scheduler set [find name=$obBackup] disabled=no
}
# ------------------------------
