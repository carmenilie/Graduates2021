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

## Jenkins

**Step 1** - Once the user got set up and the necessary plugins were successfully installed, start creating a job that would clone a repository, build a Java app using Maven, test the app, then create a Docker image based on this specific app and upload the image to Docker Hub.

**Step 2** - Set up your Docker Hub credentials into Jenkins. Follow the path *Manage Jenkins* >> *Manage Credentials* >> *Credentials* >> *Jenkins* >> *Global credentials (unrestricted)*. In this section, enter your Docker Hub username, password, choose a Docker Hub ID that would be further used for the job. 

> NOTE: Using your Docker Hub password is not the safest option. Try setting up an access token instead. For my application, the method I described above was sufficient.

**Step 3** - Go to the Jenkins dashboard and select New Item. This will begin a new job.Type in a name for the job; I called it *Graduates2021*. Then, choose the Freestyle project option and click OK. In the *Source Code Management* section, choose Git, then add in the repository URL you intend to work it. I used https://github.com/GRomR1/java-servlet-hello. 

Moving on, I left the credentials feature set as none and in the *Branches to build* subsection, I left the default option of master. In the *Build* section, tick *Use the provided DSL script*.

**Step 4** - Create the DSL script.

```sh
pipelineJob("greetingJob") {
  definition {
           cps {
             script('''
                 pipeline{
    				environment{
						registry = "carmenilie/java-app"
                        registryCredential = 'dockerhub_id'
                        dockerImage = ''
					}
                    agent{
                        label 'master'
                    }
                    stages{
                        stage('Clone Repo'){
                            steps{                            
                                git 'https://github.com/GRomR1/java-servlet-hello'
                                echo "Cloned!"
                            }
                        }
                        stage('Build'){
                            steps{
                                sh 'mvn -B -DskipTests clean package'
                                echo "Built!"
                            }
                        }
                        stage('Test'){
                            steps{
                                sh 'mvn test'
                                echo "Tested!"
                            }
                        }
                        stage('Build Image'){
                            steps{
                                script{
                                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                                }
                            }
                        }
                        stage('Deploy Image'){
                            steps{
                                script{
                                    docker.withRegistry( '', registryCredential ) {
                                    dockerImage.push()
                                    }
                                }
                            }
                        }
                        stage('Cleanup'){
                            steps {
                                sh 'docker rmi $registry:$BUILD_NUMBER'
                            }
                        }
                    }
                }

              '''
                  .stripIndent())
       sandbox()
          }
      }
  }
```

Apply the changes and save the script.

**Step 5** - Build the job. Notice the generated items, in my case a pipeline job by the name of *greetingJob*. Click the job, build it, and follow the output log to check the progress. If the job was built successfully, you will see a Finished: SUCCESS message at the end of the log.

**Step 6** - Check the image was pushed to Docker Hub by logging into the Docker Hub platform. In my case, a repository named *java-app* got built.

## Bibliography

https://www.cprime.com/resources/blog/deploying-your-first-web-app-to-tomcat-on-docker/
https://www.cidevops.com/2018/05/install-jenkins-using-ansible-playbook.html
