# OpenOps: No-Code FinOps Automation Tool

## 1. Introduction

OpenOps is a no-code platform that automates cloud cost management, reducing manual work, optimizing spending, and preventing cost overruns through real-time insights and automated workflows.

## 2. What is OpenOps?

OpenOps helps companies save on cloud costs by identifying waste, optimizing resources, and automating cloud finance tasks. It integrates with leading cloud providers AWS, Azure, and Google Cloud, and tools like Jira, Slack, and GitHub.

## 3. Why Use OpenOps?

OpenOps simplifies cloud cost management by:
    
   • **Detecting cost-saving opportunities**– Identifies unused resources and unnecessary expenses.

  • **Providing AI-driven recommendations** – Suggests actions based on usage patterns.

   • **Automating workflows** – Users can automate cost-saving actions with prebuilt or custom workflows.

   • **Ensuring human oversight** – Requires approvals for major modifications.

## 4. Key Benefits

- **Easy-to-Use No-Code Platform**
    -  Works for all FinOps users – engineers, analysts, managers.
    -   No coding needed, but allows advanced users to add custom scripts.
   

- **Automation & Optimization**
     -  Pre-made FinOps workflows – cost savings, budgeting, reporting.
     -    Customizable workflows – build our own cost management rules.
     -  Integrates with major cloud providers – AWS, Azure, Google Cloud.
     -  Works with other tools – Jira, Slack, GitHub, Notion, and more.

- **Reliability & Control**
    - Test before applying – ensures safe automation.
    - Human in loop – prevents mistakes.
    - Tables– track all cost-related actions.

## 5. Workflow Automation
A workflow in OpenOps is a series of automated steps triggered by an event.

### Workflow Components
### 1. Triggers (Start the Workflow)
    
 • **Scheduled Trigger**: Runs at fixed times (e.g., daily at 12 AM).
    
• **Event-Based Trigger**: Runs on cloud events (e.g., idle VM for 7 days).
    
• **Manual Trigger**: Runs when manually started.

### 2. Conditions & Decision Making
    
• If Condition A is met → Take Action 1. (e.g., If cloud cost increases by 20%)

• Else → Take Action 2.

### 3. Actions (What the Workflow Does)
    
 • Modify Cloud Resources: Stop unused servers, resize instances.

• Send Alerts: Notify the team about cost spikes.

• Log Data: Store financial details for reporting.

### 4. Approval Process

• Workflows can require human approval before execution.

• Example: Auto-stop an idle server only if the owner doesn’t respond within 3 days.

### Workflow Methods

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

6. Test the workflow using sample data.

7. Publish & activate the workflow.

## 6. System Requirements

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


## 7. Deploying OpenOps

Deployment Methods:

1. Local Deployment

2. AWS EC2 Deployment

3. Azure VM Deployment

### Azure VM Deployment Guide

**Step 1: Create a Virtual Machine**

   - Open Azure Portal > Virtual Machines > Create a Virtual Machine.
  
  - Choose Ubuntu Server (latest version).
    
- Allocate at least 2 CPUs and 8GB RAM.
 
 - Click Review + Create, then Create.
  
  - Open Networking > Inbound port rules, allow port 80 for web access.
    
**Step 2: Connect to the VM Using Cloud Shell**

- In Azure Portal, go to Overview > Connect > SSH using Azure CLI.

- Open Cloud Shell and connect to the VM.or open in terminal using SSH

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

Repalce localhost to vm public ip
```
sed -i 's|http://localhost|http://'$(wget -4qO - https://ifconfig.io/ip)'|g' .env
```   
4. Start OpenOps with Docker Compose
```
sudo docker compose up -d
```
5. Verify OpenOps is Running
```
sudo docker ps
```
![image](https://github.com/user-attachments/assets/ea9e8a1b-76a7-43de-9d6a-0817acef9224)

6.Access OpenOps in Your Browser

```
http://<Your-VM-Public-IP>
```
- Login: admin@openops.com

- Password: please-change-this-password-1
5. Configure Azure Credentials:

```
echo -e "OPS_ENABLE_HOST_SESSION=true\nHOST_AZURE_CONFIG_DIR=/root/.azure" >> .env
sudo az login
```
6. Enable TLS (Recommended for Production)

- Use Azure Application Gateway for HTTPS.

7. Updating OpenOps
```
sudo docker compose down
cd openops
wget https://github.com/openops-cloud/openops/releases/download/0.2.1/openops-dc-0.2.1.zip
python3 -m zipfile -e openops-dc-0.2.1.zip .
sudo COMPOSE_PARALLEL_LIMIT=4 docker compose pull -q && sudo docker compose up -d
```
## 8. Cloud Access & Permissions
### Connecting OpenOps to Azure

To allow OpenOps to manage Azure resources, users must provide:

• Application (client) ID

• Client Secret

• Directory (tenant) ID

With proper permissions, OpenOps can monitor cloud spending, detect unused resources, and automate cost-saving actions.

## 9. How OpenOps Helps in Azure

OpenOps optimizes Azure cloud costs by:

• Detecting and removing unused VMs, disks, and storage.

• Auto-scaling resources based on usage.

• Scheduling automatic shutdowns during non-business hours.

• Monitoring spending and alerting on cost spikes.

• Creating workflows for cost control with approval-based execution.

• Ensuring security with Azure AD integration and role-based access.

## 10. Conclusion
OpenOps is a powerful, no-code FinOps tool that automates cloud cost management, prevents overspending, and improves efficiency.


