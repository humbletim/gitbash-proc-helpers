#!/bin/bash

CONFIRM="\$false"
VERBOSE="\$false"

while getopts "iv" opt; do
  case $opt in
    i) CONFIRM="\$true" ;;
    v) VERBOSE="\$true" ;;
    *) echo "Usage: winkillall [-i] [-v] process_name"; exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [ $# -eq 0 ]; then
    echo "killall: no process name specified"
    exit 1
fi

PROCESS_LIST=$(printf "'%s'," "$@")
PROCESS_LIST=${PROCESS_LIST%,}

powershell.exe -NoProfile -Command "
    \$names = @($PROCESS_LIST)
    foreach (\$n in \$names) {
        \$cleanName = \$n -replace '\.exe$', ''
        # Get IDs only to avoid 'stale object' errors in the loop
        \$pids = (Get-Process -Name \$cleanName -ErrorAction SilentlyContinue).Id
        
        if (!\$pids) {
            if ($VERBOSE) { Write-Host \"\${\$n}: no process found\" -ForegroundColor Yellow }
            continue
        }

        foreach (\$id in \$pids) {
            # Re-fetch name just for the prompt/verbose output
            \$pName = (Get-Process -Id \$id).ProcessName
            \$doKill = \$true

            if ($CONFIRM) {
                \$choice = Read-Host -Prompt \"kill \$pName(PID: \$id)? (y/n)\"
                if (\$choice -notmatch '^y') { \$doKill = \$false }
            }

            if (\$doKill) {
                try {
                    Stop-Process -Id \$id -Force -ErrorAction Stop
                    if ($VERBOSE) { Write-Host \"SUCCESS: killed \$pName (PID: \$id)\" -ForegroundColor Cyan }
                } catch {
                    # Show the actual system error (e.g. Access Denied)
                    \$err = \$_.Exception.Message
                    Write-Host \"FAILURE: could not kill \$pName (PID: \$id). Reason: \$err\" -ForegroundColor Red
                }
            }
        }
    }
"
