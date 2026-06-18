#!/system/bin/sh

# ============================================
# Module Loader - Auto-loads all modules
# ============================================
# To add new module, just place .sh file here

MODULES_DIR="/system/bin/modules"
LOG_FILE="/data/local/tmp/realme_tweaks.log"

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [Loader] $1" >> $LOG_FILE
}

log_msg "🔄 Loading all modules..."

for module in $MODULES_DIR/*.sh; do
    if [ -f "$module" ] && [ "$(basename $module)" != "module_loader.sh" ]; then
        log_msg "📦 Loading: $(basename $module)"
        sh "$module" 2>&1 | while read line; do
            log_msg "  $line"
        done
    fi
done

log_msg "✅ All modules loaded"