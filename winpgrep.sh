#!/bin/bash

# Default settings
MATCH_FULL_COMMAND="\$false"
LIST_NAMES="\$false"

while getopts "fl" opt; do
  case $opt in
    f) MATCH_FULL_COMMAND="\$true" ;;
    # -l lists the process name alongside the PID
    l) LIST_NAMES="\$true" ;;
    *) echo "Usage: winpgrep [-f] [-l] pattern"; exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$1" ]; then
    echo "Usage: winpgrep [-f] [-l] pattern"
    exit 1
fi

PATTERN="$1"

powershell.exe -NoProfile -Command "
    \$pattern = '$PATTERN'
    # CIM is faster for full-path searches (-f)
    \$procs = Get-CimInstance Win32_Process
    
    foreach (\$p in \$procs) {
        # Match against Name or Full Executable Path
        \$target = if ($MATCH_FULL_COMMAND) { \$p.ExecutablePath } else { \$p.Name }
        
        if (!\$target) { continue }

        if (\$target -match \$pattern) {
            if ($LIST_NAMES) {
                # Standard pgrep -l format: PID Name
                \"{0} {1}\" -f \$p.ProcessId, \$p.Name
            } else {
                # Just the PID for piping to kill/xargs
                \$p.ProcessId
            }
        }
    }
"
