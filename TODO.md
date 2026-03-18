# TODO: Phase 2 - Integration & Parity
---------------------------------------------------------------------------
1. EXIT CODES: 
   - winpgrep/winkillall: Return 0 if at least one match was found/acted upon.
   - winpgrep/winkillall: Return 1 if no processes matched (POSIX standard).
   - winps: Return 0 on success, >0 on PowerShell/WMI failure.
2. PKILL EMULATION (winpkill.sh):
   - Port logic from winpgrep.sh but pipe results to Stop-Process.
   - Support -f (full path) and -n (newest) / -o (oldest) flags.
   - Default to silent (no confirmation) unlike winkillall -i.
3. SIGNAL MAPPING:
   - Basic support for mapping 'kill -15' (SIGTERM) vs 'kill -9' (SIGKILL)
   - Emulate via Stop-Process vs Taskkill /F for stubborn "zombies".
4. PATH HANDLING:
   - Ensure MSYS_NO_PATHCONV=1 is handled if passing Windows paths as args.
---------------------------------------------------------------------------
