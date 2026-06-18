#!/system/bin/sh

# Magisk Module Customize Script
ui_print "═══════════════════════════════════════════════"
ui_print "     🔧 Realme UI Tweaks - Installation"
ui_print "═══════════════════════════════════════════════"
ui_print ""

ui_print "📦 Installing core system..."
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
set_perm $MODPATH/system/bin/realme-tweaks 0 0 0755

ui_print "📦 Installing modules..."
for module in $MODPATH/system/bin/modules/*.sh; do
    set_perm $module 0 0 0755
    ui_print "  ✓ $(basename $module)"
done

ui_print ""
ui_print "✅ Installation complete!"
ui_print "📱 Reboot to apply tweaks"
ui_print "🌐 Open WebUI from your root manager"
ui_print ""
ui_print "═══════════════════════════════════════════════"