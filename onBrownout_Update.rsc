# <eBrownOutUpdate> #
# ==============================
# Update User Limit-Uptime v1.0a
# by: Chloe Renae & Edmar Lozada
# ------------------------------
local obBackup "<eBrownOutBackup>"
local obUpdate "<eBrownOutUpdate>"
system scheduler set [find name=$obBackup] disabled=yes

local aSSC; local aHSU; local iNewLT;
foreach i in=[system scheduler find comment~"- active -"] do={ do {
  set aSSC [toarray [system scheduler get $i comment]]
  system scheduler set [find name=($aSSC->1)] comment=""
  if ([ip hotspot user find name=($aSSC->1)]!="") do={
    set aHSU [ip hotspot user get ($aSSC->1)]
    if ((($aHSU->"limit-uptime")>1s) && (($aHSU->"uptime")=($aSSC->2))) do={
      if (($aHSU->"limit-uptime")>($aSSC->3)) do={ set iNewLT (($aHSU->"limit-uptime") - ($aSSC->3)) } else={ set iNewLT 1s }
      ip hotspot user set [find name=($aSSC->1)] limit-uptime=$iNewLT
    }
  } else={ system scheduler remove $i }
} on-error={ log warning "( $obUpdate ) ERROR: [$i] invalid data" } }

system scheduler set [find name=$obBackup] disabled=no
# ------------------------------
