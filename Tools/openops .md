# OpenOps: No-Code FinOps Automation Tool

## 1. Introduction

OpenOps is a no-code platform that automates cloud cost management, reducing manual work, optimizing spending, and preventing cost overruns through real-time insights and automated workflows.

## 2. What is OpenOps?

OpenOps helps companies save on cloud costs by identifying waste, optimizing resources, and automating cloud finance tasks. It integrates with leading cloud providers AWS, Azure, and Google Cloud, and tools like Jira, Slack, and GitHub.

## 3. Key Benefits

- **Easy-to-Use No-Code Platform**
    -  Works for all FinOps users – engineers, analysts, managers.
    -   No coding needed, but allows advanced users to add custom scripts.
   

- **Automation & Optimization**
  
     - Identifies unused resources and unnecessary expenses.
     -  Pre-made FinOps workflows – cost savings, budgeting, reporting.
     -    Customizable workflows – build our own cost management rules.
     -  Integrates with major cloud providers – AWS, Azure, Google Cloud.
     -  Works with other tools – Jira, Slack, GitHub, Notion, and more.

- **Reliability & Control**
    - Test before applying – ensures safe automation.
    - Human in loop – prevents mistakes.
    - Tables– track all cost-related actions.
 
## 4. Deploying OpenOps

Deployment Methods:

1. Local Deployment

2. AWS EC2 Deployment

3. Azure VM Deployment 

## 5. System Requirements

- **Hardware Requirements:**
   
    • Testing & Small Projects: 2 CPU cores, 8GB RAM, 50GB storage.
    
    • Production Use: 4 CPU cores, 16GB RAM, 100GB storage.
- **Supported Operating Systems:**
   
    • Linux: Ubuntu 20.04+, Debian 11+, Fedora 35+.
    
    • macOS: Big Sur (11.x) or later.
    
    • Windows: Windows 10 (2004) or later, Windows 11.
- **Docker Requirements:**
    
    • Linux: Docker Engine v20.10+, Docker Compose v2.x.
    
    • macOS: Docker Desktop 4.11+.
    
    • Windows: Docker Desktop 4.11+ (WSL 2 required).

## 6.Azure VM Deployment Guide

**Step 1: Create a Virtual Machine**

   - Open Azure Portal > Virtual Machines > Create a Virtual Machine.
  
  - Choose Ubuntu Server (latest version).
    
  - Allocate at least 2 CPUs and 8GB RAM.
 
  - Click Review + Create, then Create.
  
  - Open Networking > Inbound port rules, allow port 80 for web access.

   - Connect in terminal using (ssh username@vm-public-ip)

**Step 2: Install Required Dependencies**

1. Update System Packages:
```
   sudo apt update && sudo apt upgrade -y
```
2. Install Docker:
```
   sudo apt install -y docker.io
```
3. Enable Docker Service:
```
   sudo systemctl enable docker
   sudo systemctl start docker
```
4. Install Docker Compose:
```
   sudo apt install -y docker-compose
```
5. Check vresion
```
   docker --version
```       
**Step 3: Deploy OpenOps**

1. Ensure Bash Shell:
```
   [ -z "$BASH_VERSION" ] && exec bash
```
2. Create OpenOps Directory & Download Files
```
    cd ~
    mkdir openops && cd openops
    wget https://github.com/openops-cloud/openops/releases/download/0.2.1/openops-dc-0.2.1.zip
```   
3. Extract OpenOps Files
```
    python3 -m zipfile -e openops-dc-0.2.1.zip .
    cp --update=none .env.defaults .env
```
4. Set Public IP in Configuration:

  - Repalce localhost to vm public ip

```
    sed -i 's|http://localhost|http://'$(wget -4qO - https://ifconfig.io/ip)'|g' .env
```   
5. Start OpenOps with Docker Compose
```
    sudo docker compose up -d
```
6. Verify OpenOps is Running
```
    sudo docker ps
```
![image](https://github.com/user-attachments/assets/ea9e8a1b-76a7-43de-9d6a-0817acef9224)

**Step 4: Access OpenOps in Your Browser**
```
    http://<Your-VM-Public-IP>
```
- Login: admin@openops.com
- Password: please-change-this-password-1

## 7. Connect OpenOps to Azure Cloud

**1.Generate Azure Credentials**

  -  Go to Azure Portal > Azure Active Directory > App Registrations

  - Click New Registration

   - Name: OpenOps-Integration

   - Click Register

   - Copy **Application (Client) ID**

   - Copy **Directory (Tenant) ID**

   - Go to Certificates & Secrets > New Client Secret

   - Copy Client **Secret value** (not secret ID)

**2.Given Acess permission** 

   - Go to subscriptions choose which subscription you would like to be your service principal.(Free Trail)
   
   -  Go to Access control (IAM) and add a new role assignment

   - Select a Role **“Reader”**
   
   - Now in the next step add your application as a **member** in the role. The application might not show up in the dropdown but upon searching for it it will appear.(Named as OpenOps-Integration)

   - click “Review + assign”.

**3. Create Azure connection by adding credentials**    

- Go to Connections > New conneections.

1. Click **"Azure"**
- Paste the credentials that copied above step.
 
   ![image](https://github.com/user-attachments/assets/e8d759b3-2f97-4eae-9ea6-371e63a1f18a)

- If need to send notification via **SMTP**,connect in openops

2. New connection > Click **SMTP**

  ![image](https://github.com/user-attachments/assets/7cad0032-09b1-46d2-9e57-48912da296b8)

- **Important:** Google does not allow direct SMTP login with our normal password.we must generate an App Password from **Google App Passwords**.

  ![https://support.google.com/accounts/answer/185833?hl=en]

  ![image](https://github.com/user-attachments/assets/5920cf56-ad67-45a1-aa2b-e54778d0a36a)


## 8. Workflow Automation

 A workflow in OpenOps is a series of automated steps triggered by an event.

### Workflow Components

### 1. Triggers (Start the Workflow)
    
- **Schedule**: Every X minutes, Every hour, Every day, Every week, Every month, Cron expression.
    
- **Webhook**: It works like a "notification" sent over the internet from one app to another.
    
- **Jira Cloud**:

    - **New issue**: Triggered when a new issue (bug, task, etc.) is created in Jira.
    - **Updated issue**: Triggered when an existing issue is updated (like a status change or new comment).

- **Monday.com**: 

    - **New item in board:** Triggered when a new item (task, project, etc.) is added to a board in Monday.com.

    - **Specific column value updated in board:** Triggered when a value in a specific column (like "status" or "priority") is updated within a board.

### 2.Actions (All subsequent steps of workflow will be actions) 

1. **Code**: Run custom code (e.g., JavaScript or Python) within a workflow.

2. **Loop on Items:** Iterate through a list of items and perform actions on each item individually.

3. **Condition**: Check if a certain condition is true or false, then perform actions based on the result.

4. **Split**: Break a single data value into multiple parts (like splitting a string by commas or spaces).

5. **Approval**: Request approval from someone before proceeding with a certain action or workflow.

6. **AWS**:AWS Athena,AWS CloudFormation,AWS Compute Optimizer.

7. **Azure**: Use Microsoft Azure services to manage and deploy cloud resources and infrastructure.

8. **Date Operations**: Perform operations on dates like adding or subtracting days, comparing dates, or formatting them.
   
9. **Delay**: Pause the workflow for a set amount of time before continuing to the next action.

10. **End Workflow**: Stop the workflow at a specific point.

11.**File Operations**: Manage files, like uploading, downloading, or modifying files within the workflow.

12. **Github**: Integrate with GitHub to trigger actions on repositories, pull requests, or issues.

13. **List Operations**: Work with lists, such as adding/removing items, or filtering and sorting.

14. **Math Operations**: Perform basic mathematical operations (addition, subtraction, multiplication, etc.).

15.**Microsoft Teams**: Send messages or trigger actions within Microsoft Teams channels.

16.**OpenOps Tables**: Interact with OpenOps data tables for managing records and tables in your workflow.

17.**Slack**: Send messages or trigger actions in Slack channels.

18. **SMTP**: Send emails using Simple Mail Transfer Protocol (SMTP).

19. **Storage**: Manage files and data storage, like saving, retrieving, or deleting files.

20.**Text Operations**: Manipulate text data, such as extracting, transforming, or combining strings.

## 9. Workflow Methods

### 1. Using Prebuilt Workflows

OpenOps provides ready-made workflow templates to automate cost optimization, budget tracking, and anomaly detection.

1. Open OpenOps Dashboard.

2. Click Explore Templates.

3. Select a template and review the workflow steps.

4. Click Use Template to create a workflow.

5. Configure cloud connections and customize automation.

6. Save and activate the workflow.

### 2. Creating a Custom Workflow

  Build our own workflows based on specific business needs.

1. Go to Workflows > New Workflow.

2. Choose a trigger (what starts the workflow).

3. Define conditions (rules to check before actions run).

4. Add actions (tasks to be performed).

5. Enable the approval process (if required).

6. Test the workflow steps using **Generate sample data** at bottom.

7. Publish & activate the workflow.

![image](https://github.com/user-attachments/assets/777095df-8919-4366-860c-6ddb7087162f)

![image](https://github.com/user-attachments/assets/715d1ab0-7429-4960-989b-de248201ca73)

8. Check the logs after workflow running by clicking Runs > Select the runs need to check log.when expanding the runs we can check the logs for each steps runned in workflow.
   
## 9. Conclusion
OpenOps is a powerful, no-code FinOps tool that automates cloud cost management, prevents overspending, and improves efficiency.


