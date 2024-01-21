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

## Encryption

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


## RaspBerry configuration


### Installing the OS

Install the RaspBerry OS on a SSD card.

A few things can be set up during the installation:

- Configure the root user/password
- Select `allow ssh` and provide your user public key
- Configure wifi if needed

Once done, plug it in and wait for the RaspBerry to be up & running.

Once up, try to ssh into it.

### Setting up ansible user

Next step is to create a specific user with distinct keys to provision the RaspBerry.

First thing, let's copy in the RaspBerry its public key:

```bash
# copying into my home because I would need `sudo` to put it directly into ansible home
scp infra/ansible/secrets/id_rsa.pub 192.168.1.38:/home/yomain/ansible_id_rsa.pub
```

Then, let's create the user directly from the RaspBerry

```bash
# ssh into the raspberry
ssh 192.168.1.28

# create the user ansible
sudo adduser --uid 1001 ansible

# ssh configuration set up
sudo mkdir /home/ansible/.ssh
sudo mv ansible_id_rsa.pub /home/ansible/.ssh/authorized_keys
sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys

# allow ansible to use sudo
# now that I think about it, maybe I could prevent sudo usages easily. To dig
sudo usermod -aG sudo ansible
```

and then, that should work:

```bash
ssh 192.168.1.28 -l ansible -i infra/ansible/secrets/id_rsa
```

Maybe that part could be done directly using ansible but I would need to use my own ssh key to do it first.
Maybe one day I'll try but today's not that day


### Put back in place local backup

:warning: Don't forget to put back the backup which I probably through `./scripts/local_backup.sh`

### Certbot configuration

The letstencrypt account is stored (encrypted) in that repo.
The command to regenerate certificate should be working out of the box, however it might timeout because DNS propagation wasn't done under 10secs.

Maybe

### Running ansible (finally)

Final step, hopefully, is to run:

```bash
# running utils first to ensure everything is alright when running apps later on
# some permissions (docker) are not yet enforced when running all in the same session
poetry run ansible-playbook infra/ansible/utils/site.yaml
poetry run ansible-playbook infra/ansible/apps/site.yaml
```

### Node export

I'm using prometheus to collect metrics of my service.
I can also collect metrics from the raspberry itself through the [node exporter](https://github.com/prometheus/node_exporter)

An ansible module is [here](https://prometheus-community.github.io/ansible/branch/main/node_exporter_role.html). It needs to be installed with

```bash
poetry run ansible-galaxy collection install prometheus.prometheus
```

## TODO

### Postgres data volume

I first used the postgres image using a 32x architecture (linux/arm/v7).

Later as I upgraded the raspberry to a 64x architecture (linux/arm64), I got issue because postgres was compiled differently and the previous data volume could not be reused.

My backup is basicaly f*cked.

Because of that, postgres is still running using a linux/arm/v7 platform (I'm so happy it's compatible with a 64 bits processor).

This issue is to fix.

A few other services are still running with linux/arm/v7 because I didn't have time yet to build the for the correct platform.

### Grafana

Do a damn backup of the dashboards..................
