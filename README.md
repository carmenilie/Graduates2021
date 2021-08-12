# Graduates2021

This repository describes the steps I took in creating my 2021 Graduates Programme project. 

## Requirements

- Create a Vagrantfile that would configure three VMs: controller, jenkins, and production
- For the controller, set up Ansible from the Vagrantfile, then generate SSH keys and add them on the jenkins and production VMs
- Install Java, Maven, Git, and Docker on the controller machine
- Using Ansible, install Jenkins on the jenkins machine
- Using Jenkins, create a DSL script that would build a Java app, test it, create a Docker image based on this app and upload the image to Docker Hub
- Push the image on the production machine and write a script to check whether the app runs properly

## Controller

**Step 1** - Set up the machines by going into the directory where the Vagrantfile is located and then run the command below. This will create and configure the machines using the features described in the Vagrantfile.

```sh
vagrant up
```

**Step 2** - Check the VMs are running using the command:

```sh
vagrant status
```

**Step 3** - Connect to the controller by running:

```sh
vagrant ssh controller
```

Another way to connect to this machine is by using the IP defined for it in the Vagrantfile:

```sh
ssh vagrant@192.168.50.10
```

**Step 4** - Install Java, Git, Maven, and Docker by running the script *configure_controller.sh*:

```sh
./configure_controller.sh
```

**Step 5** - Set up Jenkins to run on the jenkins machine using Ansible. To configure Jenkins, I created a YAML file, *install_Jenkins.yml*. Then, add to the Ansible hosts file the IP of the machine you want to install Jenkins on. To do this, use the command below:

```sh
sudo vi /etc/ansible/hosts
```

In this file, I added the information below. I created a group called Jenkins_Group under which I added my Jenkins machine.

```sh
[Jenkins_Group]
192.168.50.21 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_python_interpreter=/usr/bin/python3
```

Run the following command to perform the installation of Jenkins on the node machine:

```sh
sudo ansible-playbook installJenkins.yml
```

> NOTE: Further improvements would imply installing Jenkins using the geerlingguy role, which would help to automize the entire set-up process.
