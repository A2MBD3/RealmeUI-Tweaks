#!/system/bin/sh

# Cleanup on uninstall
rm -rf /data/local/tmp/realme_tweaks.log
rm -rf /data/oppo/coloros/multiapp/backups

ui_print "🗑️ Realme UI Tweaks uninstalled"
ui_print "📁 Backups preserved at: /data/oppo/coloros/multiapp/backups"