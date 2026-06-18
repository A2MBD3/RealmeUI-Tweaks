#!/system/bin/sh

# Force update
rm -f /data/local/tmp/app_cloner_state

# Run with live output
/system/bin/app_cloner_tweaks

exit 0