# Mikrotik FixUserTime-onBrownout (via comment) v1.0a
Mikrotik script to fix users time on brownout via comment.
Handle active users limit-uptime on power interruption.
NOTE: data is saved in the user-scheduler-comment.
I strongly suggest to use UPS than this script! 😅

### Author:
- Chloe Renae & Edmar Lozada
### Facebook Contact:
- https://www.facebook.com/chloe.renae.9

### How to install:
- Open file "FixUserTime-onBrownout-Comment_v1a.rsc"
- select all, copy, & paste to winbox terminal

### WARNING!!!
- Do Not Mix with other similar brownout script
- Only use one brownout script for your system
- Remove our old version of brownout as well
- use at your own risk!

### Follow these steps:

#### Step 1: Copy script below and paste to winbox terminal
```bash
put "FixUserTime-onBrownout-Comment..."
local SaveInterval 5m
local iVer v1.0a
local eSName "<eBrownOutBackup>"
local eUName "<eBrownOutUpdate>"

if ([system scheduler find name=$eSName]="") do={ system scheduler add name=$eSName }
system scheduler set [find name=$eSName] start-time=00:00:00 interval=$SaveInterval \
  disabled=no comment="sysched: BrownOut Save Active User ($iVer)" \
  on-event=("# $eSName #\r
# ==============================\r
# Backup Active Users Time $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
if ([len [ip hotspot active find session-time-left>0]]>0) do={
  local obBackup \"<eBrownOutBackup>\"
  system scheduler set [find name=\$obBackup] disabled=yes
  local aHSU; local aHSA;
  foreach i in=[ip hotspot active find session-time-left>0] do={ do {
    set aHSA [ip hotspot active get \$i]
    set aHSU [ip hotspot user get [find name=(\$aHSA->\"user\")]]
    if ([system scheduler find name=(\$aHSA->\"user\")]!=\"\") do={
      system scheduler set [find name=(\$aHSA->\"user\")] comment=\"- active -,\$(\$aHSA->\"user\"),\$(\$aHSU->\"uptime\"),\$(\$aHSA->\"uptime\")\";
    } else={ log warning \"( \$obBackup ) ERROR: [ \$(\$aHSA->\"user\") ] scheduler not found!\" }
  } on-error={ log warning \"( \$obBackup ) ERROR: [ \$1 ] invalid data!\" } }
  system scheduler set [find name=\$obBackup] disabled=no
}\r
# ------------------------------\r\n")

# ==============================

if ([system scheduler find name=$eUName]="") do={ system scheduler add name=$eUName }
system scheduler set [find name=$eUName] start-time=startup interval=0 \
  disabled=no comment="sysched: BrownOut Update User Time ($iVer)" \
  on-event=("# $eUName #\r
# ==============================\r
# Update User Limit-Uptime $iVer\r
# by: Chloe Renae & Edmar Lozada\r
# ------------------------------\r
local obBackup \"<eBrownOutBackup>\"
local obUpdate \"<eBrownOutUpdate>\"
system scheduler set [find name=\$obBackup] disabled=yes

local aSSC; local aHSU; local iNewLT;
foreach i in=[system scheduler find comment~\"- active -\"] do={ do {
  set aSSC [toarray [system scheduler get \$i comment]]
  system scheduler set [find name=(\$aSSC->1)] comment=\"\"
  if ([ip hotspot user find name=(\$aSSC->1)]!=\"\") do={
    set aHSU [ip hotspot user get (\$aSSC->1)]
    if (((\$aHSU->\"limit-uptime\")>1s) && ((\$aHSU->\"uptime\")=(\$aSSC->2))) do={
      if ((\$aHSU->\"limit-uptime\")>(\$aSSC->3)) do={ set iNewLT ((\$aHSU->\"limit-uptime\") - (\$aSSC->3)) } else={ set iNewLT 1s }
      ip hotspot user set [find name=(\$aSSC->1)] limit-uptime=\$iNewLT
    }
  } else={ system scheduler remove \$i }
} on-error={ log warning \"( \$obUpdate ) ERROR: [\$i] invalid data\" } }

system scheduler set [find name=\$obBackup] disabled=no
# ------------------------------\r\n")

local n 10;while (($n>0) and ([system scheduler find name=$eSName]="")) do={set n ($n-1);delay 1s}
execute [system scheduler get [find name="$eSName"] on-event]

console clear-history

```

#### Step 2: "Copy the script provided below. You'll need to add this line to the hotspot user profile's On-Logout."
```bash
system scheduler set [find name=$username] comment=""

```
