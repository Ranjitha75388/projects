### Step 1: Add ubuntu to the Docker group
```
sudo usermod -aG docker $USER
```
### Step 2: Apply the group change

Either log out and log back in, or run:
```
newgrp docker
```
   
This reloads your group permissions in the current shell.
