#! /usr/bin/env sh

SOURCE="$1"
TARGET="$2"

/usr/local/bin/aws s3 sync "$SOURCE" "$TARGET" --delete 

success="$?"

echo "$(date --iso) $SOURCE BACKUP IS $success" >> "/apps/backup.log"
