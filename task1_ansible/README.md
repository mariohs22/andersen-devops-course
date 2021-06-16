# Ansible assignment

**Current status: in progress...**

## Create and deploy your own service

### The development stage:

For the true enterprise grade system we will need Python3, Flask and emoji support. Why on Earth would we create stuff that does not support emoji?!

- the service listens at least on port 80 (443 as an option)
- the service accepts GET and POST methods
- the service should receive `JSON` object and return strings in the following manner:

```
curl -XPOST -d'{"animal":"cow", "sound":"moooo", "count": 3}' http://myvm.localhost/
cow says moooo
cow says moooo
cow says moooo
Made with ❤️ by %your_name
```

- bonus points for being creative when serving `/`

### Hints

- [installing flask](https://flask.palletsprojects.com/en/1.1.x/installation/#installation)
- [become a developer](https://flask.palletsprojects.com/en/1.1.x/quickstart/)
- [or whatch some videos](https://www.youtube.com/watch?v=Tv6qXtc4Whs)
- [dealing with payloads](https://www.digitalocean.com/community/tutorials/processing-incoming-request-data-in-flask)
- [Flask documentation](https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request.get_json)
- [The database](https://emojipedia.org/nature/)
- 🐘 🐮 🦒
- what would you expect to see when visiting a random unknown website?

### The operating stage:

- [x] create an ansible playbook that deploys the service to the VM
- [x] make sure all the components you need are installed and all the directories for the app are present
- [x] configure systemd so that the application starts after reboot
- [x] secure the VM so that our product is not stolen: allow connections only to the ports 22,80,443. Disable root login. Disable all authentication methods except 'public keys'.
- [x] bonus points for SSL/HTTPS support with self-signed certificates
- [x] bonus points for using ansible vault

## Task explanation and execution order

1. Install VirtualBox VM, create VM (node host) with latest [Debian netinstall image](https://www.debian.org/CD/netinst/).
2. Setup network (add bridge interface, ensure VM is getting ip address, if no - check `/etc/network/interfaces` configuration).
3. Install Ansible on master host (use [Cygwin](https://geekflare.com/ansible-installation-windows/) if host on Windows).
4. On master host (terminal, cygwin):

Clone this repository

```
git clone https://github.com/mariohs22/andersen-devops-course.git
cd andersen-devops-course/task1_ansible
```

Run these commands to install ssl_certificate Ansible role, generate new ssh authentication key and transfer it to node host:

```
ansible-galaxy install ome.ssl_certificate
ssh-keygen -f ~/.ssh/id_rsa -q -N ""
ssh-copy-id <user-of-node-host>@<ip-address-of-node-host>
```

Add these lines in `/etc/ansible/hosts' file:

```
[debianserver]
<ip-address-of-node-host>

[debianserver:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user='{{ node_user }}'
ansible_become_pass='{{ node_root_password }}'
```

5. Set up Ansible vault (on master host) to store passwords:

Create `vault.yml` file with this contents:

```
node_user: <user-of-node-host>
node_root_password: <root-password-of-node-host>
```

Encrypt file:

```
ansible-vault encrypt vault.yml
```

6. Run Ansible playbook (on master host):

```
ansible-playbook --ask-vault-pass --extra-vars '@vault.yml' deploy.yml
```

7. Test application:

```
curl -XPOST -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}'    http://<ip-address-of-node-host>
curl -XPOST -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}' -k https://<ip-address-of-node-host>
curl -XGET  -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}'    http://<ip-address-of-node-host>
curl -XGET  -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}' -k https://<ip-address-of-node-host>

```
