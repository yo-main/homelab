#! /usr/bin/env python

import os
import socket
import sys
import boto3
from pathlib import Path


BUCKET = os.environ["AWS_BACKUP_BUCKET"]
HOSTNAME = socket.gethostname()


def run_backup():
    folders = get_folders_to_sync()

    if any(folder[0] != "/" for folder in folders):
        raise Exception("Relative paths are not supported")

    s3_client = boto3.client("s3")

    for folder in folders:
        sync(s3_client, folder)


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
    run_backup()
