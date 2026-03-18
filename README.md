# Windows Process Helpers (for Git Bash / MSYS2)

A "spare tire" toolkit for developers who indulge a Windows bash prompt but 
refuse to switch to Task Manager to kill a stalled process.

## Why?
Native Windows tools like `tasklist` and `taskkill` are cognitively dissonant 
when you are already typing `ls` and `grep`. These scripts provide thin, 
zero-dependency wrappers around PowerShell to emulate familiar Linux behavior.

## The Toolkit
- **winps**: Emulates `ps faux`. Shows real Windows PIDs, PPIDs, and full executable paths.
- **winpgrep**: Emulates `pgrep`. Supports `-f` (full path match) and `-l` (list names).
- **winkillall**: Emulates `killall`. Supports `-i` (interactive) and `-v` (verbose).

## Requirements
- Git Bash (Git for Windows) or MSYS2.
- PowerShell (built into Windows 10/11).
- No admin rights required (unless killing SYSTEM processes).

## Installation
Drop these in your `~/bin` or any folder in your `$PATH`. Or run directly like `bash winps.sh`.

