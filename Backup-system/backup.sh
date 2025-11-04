#!/bin/bash
# ========================================================
# Automated Backup System
# Author: Your Name
# ========================================================

# --- CONFIGURATION ---
# --- Paths relative to script location ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/backup.config"
LOCK_FILE="/tmp/backup.lock"
LOG_FILE="$SCRIPT_DIR/logs/backup.log"


# --- FUNCTIONS ---

log() {
    local TYPE=$1
    local MESSAGE=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $TYPE: $MESSAGE" | tee -a "$LOG_FILE"
}

# --- Load Config ---
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# Create directories if missing
mkdir -p "$BACKUP_DESTINATION" ./logs

# --- Parse Arguments ---
DRY_RUN=false
RESTORE_MODE=false
LIST_MODE=false

while [[ "$1" != "" ]]; do
    case $1 in
        --dry-run ) DRY_RUN=true ;;
        --restore ) RESTORE_MODE=true; RESTORE_FILE=$2; shift ;;
        --to ) RESTORE_DEST=$2; shift ;;
        --list ) LIST_MODE=true ;;
        * ) SOURCE_DIR=$1 ;;
    esac
    shift
done

# --- Lock Mechanism ---
if [ -f "$LOCK_FILE" ]; then
    log "ERROR" "Another backup process is already running."
    exit 1
fi
touch "$LOCK_FILE"

# --- Handle List Mode ---
if [ "$LIST_MODE" = true ]; then
    log "INFO" "Listing available backups:"
    ls -lh "$BACKUP_DESTINATION"/backup-*.tar.gz 2>/dev/null
    rm -f "$LOCK_FILE"
    exit 0
fi

# --- Restore Function ---
restore_backup() {
    local FILE=$1
    local DEST=$2
    if [ ! -f "$FILE" ]; then
        log "ERROR" "Backup file not found: $FILE"
        rm -f "$LOCK_FILE"
        exit 1
    fi
    mkdir -p "$DEST"
    log "INFO" "Restoring $FILE to $DEST ..."
    tar -xzf "$FILE" -C "$DEST"
    log "SUCCESS" "Restore completed."
}

if [ "$RESTORE_MODE" = true ]; then
    restore_backup "$RESTORE_FILE" "$RESTORE_DEST"
    rm -f "$LOCK_FILE"
    exit 0
fi

# --- Check Source Directory ---
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: ./backup.sh [--dry-run|--list|--restore <file> --to <dir>] <source_folder>"
    rm -f "$LOCK_FILE"
    exit 1
fi
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR" "Source folder not found: $SOURCE_DIR"
    rm -f "$LOCK_FILE"
    exit 1
fi

# --- Disk Space Check ---
REQUIRED_SPACE=$(du -s "$SOURCE_DIR" | awk '{print $1}')
AVAILABLE_SPACE=$(df "$BACKUP_DESTINATION" | awk 'NR==2 {print $4}')
if [ "$AVAILABLE_SPACE" -lt "$REQUIRED_SPACE" ]; then
    log "ERROR" "Not enough disk space for backup."
    rm -f "$LOCK_FILE"
    exit 1
fi

# --- Backup Function ---
create_backup() {
    local SRC=$1
    local TIMESTAMP=$(date +%Y-%m-%d-%H%M)
    local BACKUP_FILE="${BACKUP_DESTINATION}/backup-${TIMESTAMP}.tar.gz"

    local EXCLUDES=()
    IFS=',' read -ra PATTERNS <<< "$EXCLUDE_PATTERNS"
    for pattern in "${PATTERNS[@]}"; do
        EXCLUDES+=("--exclude=${pattern}")
    done

    if [ "$DRY_RUN" = true ]; then
        log "DRY-RUN" "Would create backup for $SRC → $BACKUP_FILE"
        return
    fi

    log "INFO" "Creating backup of $SRC → $BACKUP_FILE ..."
    tar -czf "$BACKUP_FILE" "${EXCLUDES[@]}" "$SRC" 2>>"$LOG_FILE"
    if [ $? -ne 0 ]; then
        log "ERROR" "Failed to create backup."
        rm -f "$LOCK_FILE"
        exit 1
    fi
    sha256sum "$BACKUP_FILE" > "${BACKUP_FILE}.sha256"
    log "SUCCESS" "Backup created: $BACKUP_FILE"
}

# --- Verification ---
verify_backup() {
    local FILE=$1
    if [ "$DRY_RUN" = true ]; then
        log "DRY-RUN" "Would verify backup checksum for $FILE"
        return
    fi
    sha256sum -c "${FILE}.sha256" >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        log "INFO" "Checksum verified successfully for $FILE"
    else
        log "ERROR" "Checksum verification FAILED for $FILE"
    fi
}

# --- Cleanup Old Backups ---
cleanup_old_backups() {
    if [ "$DRY_RUN" = true ]; then
        log "DRY-RUN" "Would clean up old backups"
        return
    fi

    log "INFO" "Cleaning up old backups..."
    cd "$BACKUP_DESTINATION" || return

    # Delete backups older than retention policy
    ls -1t backup-*.tar.gz 2>/dev/null | awk "NR>$DAILY_KEEP" | while read f; do
        log "INFO" "Deleting old backup $f"
        rm -f "$f" "$f.sha256"
    done
}

# --- MAIN EXECUTION ---
create_backup "$SOURCE_DIR"

LATEST_BACKUP=$(ls -t "${BACKUP_DESTINATION}/backup-"*.tar.gz | head -n 1)
verify_backup "$LATEST_BACKUP"
cleanup_old_backups

log "SUCCESS" "Backup process completed."

# --- Unlock ---
rm -f "$LOCK_FILE"
exit 0
