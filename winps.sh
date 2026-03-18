#!/bin/bash

# Define the ps faux header with STIME and extra width for the Path
printf "%8s %8s %8s %10s %-10s %-15s %-10s %s\n" "PID" "PPID" "PGID" "WINPID" "TTY" "UID" "STIME" "COMMAND/PATH"

# PowerShell execution:
# 1. Get-CimInstance Win32_Process is fast and contains CreationDate.
# 2. Sorts by ParentProcessId to group the 'faux' tree logically.
powershell.exe -NoProfile -Command "
    \$today = (Get-Date).Date
    \$thisYear = (Get-Date).Year
    
    Get-CimInstance Win32_Process | 
    Sort-Object ParentProcessId, ProcessId | 
    ForEach-Object {
        # Format STIME: Time (HH:mm) if today, Month/Day if this year, else Year
        \$cDate = \$_.CreationDate
        if (\$cDate.Date -eq \$today) { \$stime = \$cDate.ToString('HH:mm:ss') }
        elseif (\$cDate.Year -eq \$thisYear) { \$stime = \$cDate.ToString('MMM dd') }
        else { \$stime = \$cDate.ToString('yyyy') }

        # Get UID (Owner)
        \$uid = if (\$_.Name -eq 'System Idle Process') { 'SYSTEM' } else { 
            \$owner = \$_ | Invoke-CimMethod -MethodName GetOwner -ErrorAction SilentlyContinue
            if (\$owner.User) { \$owner.User } else { 'SYSTEM' }
        }
        
        # Format TTY and Command Path
        \$tty = if (\$_.SessionId -eq 0) { '???' } else { 'cons' + \$_.SessionId }
        \$cmd = if (\$_.ExecutablePath) { \$_.ExecutablePath } else { \$_.Name }

        # Output in ps faux style
        '{0,8} {1,8} {2,8} {3,10} {4,-10} {5,-15} {6,-10} {7}' -f \`
            \$_.ProcessId, \$_.ParentProcessId, \$_.ProcessId, \$_.ProcessId, \$tty, \$uid, \$stime, \$cmd
    }
"
