#!/system/bin/sh

# ============================================
# App Cloner Module
# ============================================
MODULE_NAME="App Cloner"
XML_FILE="/data/oppo/coloros/multiapp/oppo_allowed_app.xml"
BACKUP_DIR="/data/oppo/coloros/multiapp/backups"
BACKUP_FILE="${BACKUP_DIR}/oppo_allowed_app.xml"
TEMP_FILE="/data/local/tmp/oppo_allowed_app_fixed.xml"
LOG_FILE="/data/local/tmp/realme_tweaks.log"

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$MODULE_NAME] $1" >> $LOG_FILE
}

fix_multiapp() {
    log_msg "═══════════════════════════════════════════════"
    log_msg "📱 App Cloner Module - Starting"
    log_msg "═══════════════════════════════════════════════"
    
    # Root check
    if [[ $(id -u) -ne 0 ]]; then
        log_msg "❌ Root access required!"
        return 1
    fi
    
    # Backup
    mkdir -p "$BACKUP_DIR"
    if [[ -f "$XML_FILE" ]]; then
        cp "$XML_FILE" "$BACKUP_FILE"
        log_msg "✅ Backup created"
    fi
    
    # Get original SELinux context
    ORIG_CONTEXT=$(ls -lZ "$XML_FILE" 2>/dev/null | awk '{print $4}')
    
    # Get user apps
    USER_APPS=$(pm list packages -3 | cut -d: -f2)
    APP_COUNT=$(echo "$USER_APPS" | wc -l)
    log_msg "📋 Found $APP_COUNT user apps"
    
    # Add predefined apps
    PREDEFINED_APPS=("mark.via.gp")
    for app in "${PREDEFINED_APPS[@]}"; do
        if ! echo "$USER_APPS" | grep -q "^$app$"; then
            USER_APPS="$USER_APPS"$'\n'"$app"
        fi
    done
    
    # Create XML
    {
        echo '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>'
        echo '<gs>'
        for APP in $USER_APPS; do
            echo "<allowedapp>${APP}</allowedapp>"
        done
        echo '</gs>'
    } > "$TEMP_FILE"
    
    XML_APPS=$(grep -c '<allowedapp>' "$TEMP_FILE")
    log_msg "📄 XML created with $XML_APPS apps"
    
    # Apply permissions
    cp "$TEMP_FILE" "$XML_FILE"
    chmod 644 "$XML_FILE"
    chown system:system "$XML_FILE"
    
    # Fix SELinux
    SELINUX_FIXED=0
    if [[ -n "$ORIG_CONTEXT" ]]; then
        chcon "$ORIG_CONTEXT" "$XML_FILE" 2>/dev/null && SELINUX_FIXED=1
    fi
    
    if [[ $SELINUX_FIXED -eq 0 ]]; then
        for ctx in "u:object_r:oppo_data_file:s0" "u:object_r:system_data_file:s0" "u:object_r:app_data_file:s0"; do
            chcon "$ctx" "$XML_FILE" 2>/dev/null && SELINUX_FIXED=1 && break
        done
    fi
    
    if [[ $SELINUX_FIXED -eq 0 ]]; then
        restorecon "$XML_FILE" 2>/dev/null
    fi
    
    # Restart service
    pm clear com.coloros.oppomultiapp >/dev/null 2>&1
    am force-stop com.coloros.oppomultiapp >/dev/null 2>&1
    
    rm -f "$TEMP_FILE"
    log_msg "✅ App Cloner module completed successfully"
    log_msg "═══════════════════════════════════════════════"
    return 0
}

# Execute
fix_multiapp