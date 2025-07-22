# <eBrownOutUpdate> #
# ==============================
# Update User Limit-Uptime v1.0a
# by: Chloe Renae & Edmar Lozada
# ------------------------------
{
local obBackup "<eBrownOutBackup>"
local obUpdate "<eBrownOutUpdate>"
log info ("( $obUpdate ) Beg => $[system clock get time]")
system scheduler set [find name=$obBackup] disabled=yes

local aSSC; local aHSU; local iNewLT;
foreach i in=[system scheduler find comment~"- active -"] do={ do {
  set aSSC [toarray [system scheduler get $i comment]]
  system scheduler set [find name=($aSSC->1)] comment=""
  if ([ip hotspot user find name=($aSSC->1)]!="") do={
    set aHSU [ip hotspot user get ($aSSC->1)]
    if ((($aHSU->"limit-uptime")>1s) && (($aHSU->"uptime")=($aSSC->2))) do={
      if (($aHSU->"limit-uptime")>($aSSC->3)) do={ set iNewLT (($aHSU->"limit-uptime") - ($aSSC->3)) } else={ set iNewLT 1s }
      log info "( $obUpdate ) => User:[$($aSSC->1)] UsrLT:[$($aHSU->"limit-uptime")] UsrUT:[$($aHSU->"uptime")] BakUT:[$($aSSC->3)] => NewLT:[$iNewLT]"
     #ip hotspot user set [find name=($aSSC->1)] limit-uptime=$iNewLT
    }
  } else={ system scheduler remove $i }
} on-error={ log warning "( $obUpdate ) ERROR: [$i] invalid data" } }

system scheduler set [find name=$obBackup] disabled=no
log info ("( $obUpdate ) End => $[system clock get time]")
}

# ------------------------------

execute [system scheduler get [find name=<eBrownOutUpdate>] on-event]

system scheduler set [find name=tester] comment="- active -,tester,00:00:00,09:59:58";
system scheduler set [find name=tester] comment="- active -,tester,00:00:00,09:59:59";
system scheduler set [find name=tester] comment="- active -,tester,00:00:00,10:00:00";
system scheduler set [find name=tester] comment="- active -,tester,00:00:00,20:00:00";

# ------------------------------

foreach i in=[system scheduler find comment~"- active -"] do={ do {
  local aSSC [toarray [system scheduler get $i comment]]
  put [system scheduler get $i comment]
  put [ip hotspot user find name=($aSSC->1)]
  put ([ip hotspot user find name=($aSSC->1)]!="")
    local aHSU [ip hotspot user get ($aSSC->1)]
    put ($aHSU->"limit-uptime")
    put (($aHSU->"limit-uptime")>1s)
    put ($aHSU->"uptime")
    put ($aSSC->2)
    put (($aHSU->"uptime")=($aSSC->2))
    put ((($aHSU->"limit-uptime")>1s) && (($aHSU->"uptime")=($aSSC->2)))
      if (($aHSU->"limit-uptime")>($aSSC->3)) do={ set iNewLT (($aHSU->"limit-uptime") - ($aSSC->3)) } else={ set iNewLT 1s }
      put "( $obUpdate ) => User:[$($aSSC->1)] UsrLT:[$($aHSU->"limit-uptime")] UsrUT:[$($aHSU->"uptime")] BakUT:[$($aSSC->3)] => NewLT:[$iNewLT]"
}}

