Terminology
-----------

* configuration management - managing the state of the servers
* deployment - taking SW written in-house and setting it up on a server
* orchestration - ex. making an update involving multiple servers
* provisioning - spinning up new servers (VMs)

Playbook
* a configuration management script
* unordered list of hosts
* ordered list of tasks (plays)

Module
* script packaged with Ansible
* performs some action on a host (`ansible-doc <module>`)

![Entity-relationship
diagram](https://github.com/jreisinger/blog/tree/master/files/ansible_entities.png)

Ansible workflow for each task
1. generate a Python script
2. copy the script to the servers (hosts)
3. execute the script
4. wait for the script to complete on all hosts

`True` vs `yes`
* `yes`/`no` when passing args to modules
* `True`/`False` elsewhere in playbooks

You're best off writing playbooks for your org rather than trying to reuse
generic playbooks.

One liners
----------

```
$ ansible all -m ping
$ ansible all [-m command] -a uptime
$ ansible host1 -b -a "tail /var/log/syslog" # -b -> become
$ ansible host1 -b -m apt -a name=nginx
$ ansible all -i inventories/dev -b -m apt -a "name=nagios-nrpe-server state=absent"

$ ansible-tools help init

$ ansible -i stage waf1 -m fetch -a "src=/home/ubuntu/03_gen_whitelists \
dest=./roles/nginx-naxsi/templates/events_mngt/ flat=yes"

ansible -m authorized_key -a "key=\"{{lookup('file','/tmp/dude.pub')}}\" \
user=ubuntu stage=present" all -i inventories/dev

# Viewing all facts associated with a server
ansible server1 -m setup
```

Quoting
-------

If you reference a variable *right after* the module name:
```
- name: perform some task
  command: "{{ myapp }} -a foo"
```

If your argument contains a collon:
```
- name: show a debug msg
  debug: "msg='The debug module will print a message: neat, eh?'"
```

Variables
---------

1) In inventory file

* ok if you don't have too many hosts
* only Booleans and strings (not lists and dictionaries)

2) In `host_vars`, `group_vars` directories

* separate file for each host or group

```
$ cat group_vars/production
db_primary_host: buda.example.org
# accessed as {{ db_primary_host }}

$ cat_group_vars/production_dict
db:
  primary:
    host: buda.example.org
# accessed as {{ db.primary.host }}
```

3) In role's `defaults` directory - have the lowest priority of any variables available

4) In `vars` section of a playbook - simplest way to define variables

```
vars:
  key_file: /etc/nginx/ssl/nginx.key
  cert_file: /etc/nginx/ssl/nginx.crt
  conf_file: /etc/nginx/sites-available/default
  server_name: localhost
```

5) In playbooks loaded by `vars_file`

```
vars_files:
 - nginx.yml
```

6) As arguments to a role

7) On the command line

See [variables](http://docs.ansible.com/ansible/latest/playbooks_variables.html) for more.

Roles
-----

Primary mechanism for breaking a playbook into multiple files
* tasks
* files
* templates
* handlers
* vars (higher priority than those defined in the `vars` section of a play)
* defaults (default variables that can be everridden)
* meta (dependency info about a role)

If you think you might want to change the value of a variable in a role (via `vars` section of a play or role's arguments), use a default variable (`defaults`). If you don't want it to change, use a regular variable (`vars`).

Roles with variables:
```
- name: deploy postgres on vagrant
  hosts: db
  vars_files:
    - secrets.yml
  roles:
    - role: database
      database_name: "{{ mezzanine_proj_name }}"
      database_user: "{{ mezzanine_proj_name }}"

- name: deploy mezzanine on vagrant
  hosts: web
  vars_files:
    - secrets.yml
  roles:
    - role: mezzanine
      database_host: "{{ hostvars.db.ansible_eth1.ipv4.address }}"
      live_hostname: 192.168.33.10.xip.io
      domains:
        - 192.168.33.10.xip.io
        - www.192.168.33.10.xip.io
```

See [roles](https://github.com/ansiblebook/ansiblebook/tree/master/roles/playbooks/roles) for more.

Tips and tricks
---------------

Achieve idempotence with a `command` module:
```
- name: create a Vagrantfile
  command: vagrant init {{ box }} creates=Vagrantfile
```

Change the way Ansible identifies that a task has changed state (`changed_when`):
```
- name: initialize the database
    django_manage:
      command: createdb --noinput --nodata
      app_path: "{{ proj_path }}"
      virtualenv: "{{ venv_path }}"
    register: result
    #changed_when: '"Creating tables" in result.out|default("")'
    changed_when: result.out is defined and "Creating tables" in result.out
```

```
- name: Import logs into ES
  become: no
  shell: ./nxtool.py -c nxapi.json --files=/var/log/nginx/naxsi.log 2>&1 | perl -ne 'print $1 if /Written\s+(\d+)\s+events/'
  register: result
  changed_when: result.stdout != "0"  # NOTE: this was tricky to get right! :-)
  args:
    chdir: /home/ubuntu/nginx-naxsi/naxsi-master/nxapi
  tags:
    - nxapi
```

View the output of a task:
```
- name: initialize the database
  django_manage:
    command: createdb --noinput --nodata
    app_path: "{{ proj_path }}"
    virtualenv: "{{ venv_path }}"
  failed_when: False # so the execution doesn't stop on failure
  register: result   # save the output to a variable
  
# print out the variable...
- debug: var=result

# stop the execution...
- fail:
```

Run a task and print its output, even if it fails:
```
- name: Run myprog
  command: /opt/myprog
  register: result
  ignore_errors: True

- debug: var=result

- debug: msg="Stop running the playbook if myprog failed"
  failed_when: result|failed # filters for registered variables:
  # - failed
  # - changed
  # - success
  # - skipped
  
# more tasks here
```

Have multiple ansible versions on a Laptop:

```
mkdir ansibles
cd ansibles
# see https://github.com/ansible/ansible/releases for versions
VER=v2.5.2; git clone -b $VER --recursive https://github.com/ansible/ansible.git $VER
source ./$VER/hacking/env-setup
ansible --version
```

Source
------

* [Ansible: Up and Running](https://github.com/ansiblebook/ansiblebook) (2017)
