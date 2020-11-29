echo "START........INSTALL DOCKER...............STARTED"

export DEBIAN_FRONTEND=noninteractive

# (Install Docker CE)
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
sudo apt-get update && sudo apt-get install -y \
  sudo apt-transport-https ca-certificates curl software-properties-common gnupg2

sleep 5

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker apt repository:
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

sleep 10

# Install Docker CE
sudo apt-get update && sudo apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

sleep 10

# Set up the Docker daemon
sudo mkdir -p /etc/docker
sudo touch /etc/docker/daemon.json
sudo chmod 777 /etc/docker/daemon.json
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

# add vagrant user to group docker
sudo groupadd docker
sudo gpasswd -a $USER docker

# Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker


echo "END........INSTALLED DOCKER...............ENDED"

echo "..............................................."
echo "..............................................."
echo "..............................................."
echo "..............................................."

echo "START........INSTALL GO...............STARTED"
echo "apt-get update and upgrade"
sudo apt-get update
sleep 5
#sudo apt-get -y upgrade

echo "download go tar.gz file"
sudo wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
sleep 10

echo "untar go tar.gz file"
sudo tar -xvf go1.13.3.linux-amd64.tar.gz
sleep 10
sudo mv go /usr/local

echo "PATH=$PATH:/usr/local/go/bin" >> ~/.profile

source ~/.profile

echo "Print go environ variables: "
go env -w GOPATH=/vagrant/go
go env -w GOROOT=/usr/local/go
go env

echo "Print go version: "
go version

