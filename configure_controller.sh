# This scripts installs and configures Java, Maven, Git, and Docker

# --------------------
# Java
# --------------------

echo "Installing Java..."

# Update the repositories
sudo apt update

# Search for available packages
sudo apt search openjdk

# Pick one option and install it
sudo apt install openjdk-11-jdk

# Verify installation
echo "Checking Java installation..."
java -version

# --------------------
# Maven
# --------------------

echo "Installing Maven..."

# Update the package index and install Maven
sudo apt update
sudo apt install maven

# Verify installation
echo "Checking Maven installation..."
mvn -version

# --------------------
# Git
# --------------------

echo "Installing Git..."

# Update the packages
sudo apt-get update

# Install Git from the default repositories
sudo apt-get install git

# Verify installation
echo "Checking Git installation..."
git ––version

# --------------------
# Docker
# --------------------

# Update the apt package index
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that you now have the key with the fingerprint:
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
sudo apt-key fingerprint 0EBFCD88

# Set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update the apt package index
sudo apt-get update

# Install the latest version of Docker CE
sudo apt install docker-ce=18.06.1~ce~3-0~ubuntu

# Add `vagrant` user to Docker group
sudo usermod -aG docker vagrant

# Verify that Docker Engine is installed correctly by running the hello-world image
sudo docker run hello-world
