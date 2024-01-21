#! /usr/bin/env sh

# backup files from the raspberry to localhost

scp -r -i infra/ansible/secrets/id_rsa ansible@home:/apps/bitwarden/data ./backup/bitwarden

scp -r -i infra/ansible/secrets/id_rsa ansible@home:/apps/postgres/data ./backup/postgres


# rerun those commands with path reverted to put it back into the RaspBerry when needed
