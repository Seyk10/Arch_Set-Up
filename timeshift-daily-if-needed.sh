#!/bin/bash

log() {
    /usr/bin/logger -t timeshift-autobackup "$1"
    echo "$1"
}

TODAY=$(date +%Y-%m-%d)

if sudo timeshift --list | grep -q "$TODAY"; then
    log "OK: Daily snapshot was already done $TODAY."
else
    log "WAIT: Creating daily snapshot... $TODAY."
    if sudo timeshift --create --comments "Automatic post-boot backup" --tags D; then
        log "OK: Snapshot created successfully $TODAY."
    else
        log "ERROR: Error creating snapshot $TODAY."
    fi
fi