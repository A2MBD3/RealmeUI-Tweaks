#!/system/bin/sh

MODDIR=${0%/*}
LOG_FILE="/data/local/tmp/realme_tweaks.log"

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

log_msg "═══════════════════════════════════════════════"
log_msg "🚀 Realme UI Tweaks - Service Started"
log_msg "═══════════════════════════════════════════════"

# Wait for system
sleep 15

# Load all modules
if [ -d "$MODDIR/system/bin/modules" ]; then
    for module in $MODDIR/system/bin/modules/*.sh; do
        if [ -f "$module" ] && [ "$(basename $module)" != "module_loader.sh" ]; then
            log_msg "📦 Loading: $(basename $module)"
            sh "$module" >> $LOG_FILE 2>&1
            log_msg "✓ $(basename $module) executed"
        fi
    done
fi

log_msg "✅ All modules loaded successfully"
log_msg "═══════════════════════════════════════════════"