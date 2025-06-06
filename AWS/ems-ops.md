
## Architecture diagram

![image](https://github.com/user-attachments/assets/6ceba5e3-1072-47f8-8b83-0315f074ded4)

## Steps in console

Step1: Login to AWS console  https://console.aws.amazon.com

Step 2: Select Region : ap-south-1.

Step 3:Choose Default VPC.

Step 4: Choose 3 public subnets under default vpc.
 
 1.public subnet-1 : Application Load Balancer.

 2.Public subnet-2 : Auto scaling group
 
 3.public subnet-3 : Amazon RDS

Step 5:Create EC2 Instance

1.Type EC2 in search bar.

2.Select Instance ---> Launch Instance

#### - Name and Tags
    - Name:ems-Instance

#### - Application and OS Images 
   - Quick start:Ubuntu.
   - Amazon Machine Image (AMI): Ubuntu server 24.04 (Free tier eligible)
#### - Instance type
  - t2.micro(Free tier eligible)
#### Keypair(Login)
  - Create new keypair
  - Keypair Name:ranjitha-ec2-keypair
  - Keypair type:RSA
  - Private key file format: .pem
  - create new pair.
  - Key-pair file will be downloaded.
![image](https://github.com/user-attachments/assets/30c3c912-d50f-48f7-90ac-3c1065ab30a6)

#### - Network settings
- Select Default VPC.
- Select Default public subnet.
- Auto-assign public IP:Enable.
- 






















