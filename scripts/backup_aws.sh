#! /usr/bin/env sh

METRIC_FILE="/var/lib/node_exporter/backup_metrics.prom"

log() {
    echo "$(date --iso) $1" >> "/apps/backup.log"
}

metric() {
    source="$1"
    status="$2"

    current_metric="yomain_backup_script{folder=\"${source}\", status=\"${status}\"}"

    grep -q "$current_metric" "$METRIC_FILE"
    found="$?"

    if [ "$found" = "1" ]; then
        echo "${current_metric} 1" >> "$METRIC_FILE"
    else
        tempfile=$(mktemp)
        cat "$METRIC_FILE" | grep -v "$current_metric" > $tempfile
        cat "$METRIC_FILE" | grep "$current_metric" | sed -E 's/.*([0-9]+)$/echo "$((\1 + 1))"/ge' | awk -v prefix="$current_metric" '{print prefix " " $0}' >> $tempfile
        mv "$tempfile" "$METRIC_FILE"
    fi
}

SOURCE="$1"
TARGET="$2"

if [ -d "$SOURCE" ]; then
  /usr/local/bin/aws s3 sync "$SOURCE" "$TARGET" --delete 
elif [ -f "$SOURCE" ]; then
  /usr/local/bin/aws s3 cp "$SOURCE" "$TARGET"
else
  log "$SOURCE is not known"
  exit 1
fi

status="$?"

metric "$SOURCE" "$status"

log "$SOURCE BACKUP IS $status" 
