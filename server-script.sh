# sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
# sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
    git pull origin addbookDocker
    cd addressbook-v1
else
  git clone https://github.com/RAMESHBABUT/addressbook-v1.git
fi

cd addressbook-v1
git checkout master
# mvn package
# mvn -U deploy -s settings.xml

sudo docker build -t $1 .