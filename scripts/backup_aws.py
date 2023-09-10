#! /usr/bin/env python

import os
import socket
import sys
import boto3
from datetime import datetime
from pathlib import Path


BUCKET = os.environ["AWS_BACKUP_BUCKET"]
HOSTNAME = socket.gethostname()
LOG_FILE = os.environ.get("LOG_FILE", "/var/log/cron.log")

def log(msg):
    now = datetime.now()
    with open(LOG_FILE, "a") as stream:
        stream.write(f"{now} - {msg}")


def run_backup():
    folders = get_folders_to_sync()
    log(f"Backup started for folders {','.join(folders)}")

    if any(folder[0] != "/" for folder in folders):
        raise Exception("Relative paths are not supported")

    s3_client = boto3.client("s3")

    for folder in folders:
        sync(s3_client, folder)

    log(f"Backup successed for folders {','.join(folders)}")


def sync(s3, folder):
    local_files = list_local_files(folder)
    for file in local_files:
        upload_file(s3, file)


def get_folders_to_sync():
    return sys.argv[1:]


def list_local_files(folder):
    path = Path(folder)
    return (file for file in path.iterdir() if file.is_file())


def upload_file(s3, file):
    s3.upload_file(
        Bucket=BUCKET,
        Filename=file,
        Key=f"{HOSTNAME}{file}",
    )


if __name__ == "__main__":
    try:
        run_backup()
    except Exception as exc:
        log(f"Error while processing backup: {exc}")
