# My home infrastructure

This repo is my home infrastructure.

It has a terraform section for a bunch of conf to manage on DO or GCP.
Most importantly it has an ansible section to manage/provision my one warrior RaspBerry.

## How to use

```bash
# to set up the entrypoint
poetry run ansible-playbook infra/ansible/apps/entrypoint/main.yaml 

# to run everything
poetry run ansible-playbook infra/ansible/site.yaml
```

## Encription

I use ansible to encrypt secrets. It's convenient, but it use a master password for encryption that I should not loose (I already lost it once...).

Encrypted files are roles' variables and some configuration files, anything with PII information basically.

To use ansible-vault:

```bash
poetry run ansible-vault create ./infra/ansible/...
poetry run ansible-vault edit ./infra/ansible/...
```


## Backup

Core data is backuped into AWS S3 (postgres, bitwarden...).

There's a python script in `./scripts` to do it. 

Use it by defining this cronjob:

```yaml
  - name: "Add cron for backup"
    ansible.builtin.cron:
      name: "Backup postgres data"
      minute: "30"
      hour: "22"
      job: "AWS_BACKUP_BUCKET={{ aws_backup_bucket }} python /scripts/backup_aws.py /apps/postgres/data"
```
