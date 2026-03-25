# Ansible Project for Installing Nexus

This Ansible project automates the installation of Nexus on Ubuntu/Debian servers based on the official Nexus installation instructions.

The `Dockerfile` in the project is for emulating an ansible host which can be used for testing your script instead of testing directly on your servers.

# Configure DB

You should follow the configuration setps [here](https://help.sonatype.com/en/install-nexus-repository-with-a-postgresql-database.html)

You can run a local postgres DB as a container like so:
```sh
# accessible at localhost:5432
docker run -d --name nexus-db -p 5432:5432 -e POSTGRES_PASSWORD=YOUR_PASS postgres:latest
```

Make sure that the user your Nexus instance will authenticate to your DB as has been properly configured in the `pg_hba.conf` file (usually in `/etc/postgresql/VERSION/main` directory).

# Installation:

Edit and rename the `.template` files. Edit the `defaults/main.yml`, `inventory/` files, and `ansible.cfg` as necessary.

By default, it's assumed that the SSH keys are in the `inventory/` folder.

```sh
# Test ping
ansible-playbook -i inventory/remote.yml --tags ping site.yaml

# Debug: Print variables
ansible-playbook -i inventory/remote.yml --tags debug site.yaml

# Run the entire script
ansible-playbook -i inventory/remote.yml -e "nexus_state=present" site.yaml
```

# Uninstall

```sh
ansible-playbook -i inventory/remote.yml -e "nexus_state=absent" site.yaml
```

# Run a local container as Nexus instance for testing script

First generate ssh key pair with

```sh
ssh-keygen -t rsa
```

Then, copy the `id_rsa.pub` key to the root directory. Keep the private key (`id_rsa` file) in the `inventory/` folder. 

Run the `start-ubuntu-container.sh` script to start the container.

You can ssh into the container via `ssh -i inventory/id_rsa -p 2222 appuser@localhost`

Stop the container with the `rm-ubuntu-container.sh`.

# Main Stages:

The main stages as outlined in `site.yml` and `roles/nexus/tasks/` files are:
- `ping`
- `debug`
- `check-compatibility`
- `install`
- `setup-sysd-service`

You can run just tasks with a certain tag as seen in the [example above](#installation)