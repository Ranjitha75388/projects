## Install packer

1.Download from: https://developer.hashicorp.com/packer/install
On Ubuntu:
```
sudo apt-get update && sudo apt-get install -y unzip
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

2.verify installation

![image](https://github.com/user-attachments/assets/5a902118-9591-455c-8f5b-b7ce2cb74230)
