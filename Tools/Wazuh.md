
# Wazuh: A Complete Security Monitoring Solution

## Introduction

- Wazuh is a free and open-source security tool that helps protect computers, servers, and cloud systems from threats. It provides:

  - SIEM (Security Information and Event Management) – Collects and analyzes security events.
  - XDR (Extended Detection and Response) – Detects and responds to security threats.
- Wazuh monitors on-premises, cloud environments (AWS, Azure, Google Cloud), and hybrid systems, ensuring security and compliance.

## Key Features of Wazuh

1. ### Security Monitoring
   
- Tracks computers, servers, and cloud services.
 
 - Detects malware, hacking attempts, and suspicious activities.
2. ### Threat Detection & Prevention

- Sends alerts if someone tries to break into the system.
 
- Blocks hackers and prevents data breaches.

3. ###  Compliance & Reporting
    
- Helps companies follow security regulations (e.g., GDPR, HIPAA, PCI DSS).
 
-  Creates detailed security reports for audits and improvements.

4. ### Automated Incident Response
    
- Takes automatic action when a threat is detected.
 
 - Can block attackers, stop malware, and secure sensitive data.

## Wazuh Components
   
- **Wazuh Agent** - Installed on computers/servers to monitor activities and collect security data.

- **Wazuh Server** - Central control unit that processes and analyzes data from agents.
- **Wazuh Indexer** - Stores security logs and alerts for future reference and analysis.

- **Wazuh Dashboard** - Web-based interface to view reports, alerts, and system status.




## Architecture Diagram

![image](https://github.com/user-attachments/assets/1b030982-b013-4225-bf70-44f8d6eb2a4f)


1. ####  Endpoint Security Agent (Wazuh Agent)
   
- Installed on endpoints (computers, servers, cloud systems) to monitor security events.
   
- Agent Modules perform key functions like:
   
   - Active response (blocking threats)
    - Malware detection
    - File integrity monitoring
    - Cloud & container security

- Agent Daemon manages:
    
    - Data encryption
    
    - Remote configuration
     
    - Server authentication
    
- Data Flow Control sends collected security data to the central server.

2. #### Central Components
 
 - **Wazuh Server**
   
   - Processes and analyzes security data from agents.
    - Includes:
     
      - Agent connection & enrollment service (manages agents)
       
       - Syslog listener (collects logs)
        
        - Analysis engine (detects threats, applies rules)
        
        - Threat intelligence, vulnerability detection, compliance monitoring
   - Raw data events & security alerts are sent to Filebeat for further processing.
 
 - **Wazuh Indexer**
 
     - Stores and manages data for search and analysis.
    
     - Key functions:
        -  Search engine (finds security insights)
        - Data analytics
        - Long-term storage (saves logs & alerts)
 
 - **Wazuh Dashboard**

    -  User interface for viewing security insights.
    
    -  Provides:
      
       - Query language for searching data
       - Visual dashboards for monitoring threats
        - Reports engine for compliance and auditing.

### How It Works?
    
 1. Wazuh Agent collects security logs and sends them to Wazuh Server.
 
 2. Wazuh Server analyzes logs, detects threats, and creates security alerts.
 
 3. Alerts & data are stored in Wazuh Indexer for future analysis.
 
 4. Users access alerts & reports through the Wazuh Dashboard.

## How to Install Wazuh? (Step-by-Step Guide)

#### Step 1: Install Wazuh Server

The Wazuh Server is the main control center that processes security data from agents.
```
    curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

```

#### Step 2: Wait for Installation to Complete
- The system will install all necessary Wazuh components.
 
 -  After installation, login details for the Wazuh Dashboard will be displayed.

#### Step 3: Access the Wazuh Web Interface
-  Open the browser and go to:
```
    https://<WAZUH_DASHBOARD_IP_ADDRESS>

```
- Use the credentials:
    - Username: admin
    - Password: <ADMIN_PASSWORD> (shown after installation)
- **Note**: If you see an "untrusted certificate" warning, you can accept it or set up a trusted certificate later.

#### Step 4: Managing Wazuh Passwords
    
 To find all stored passwords, use this command:
``` 
    sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
```       

#### Step 5: Uninstalling Wazuh (if needed)
```
    sudo bash ./wazuh-install.sh -u
```    

##  How Wazuh Helps Businesses & DevOps Teams

### For DevOps Teams:
- Detects security issues during software development.
 
- Protects cloud applications from cyber threats.
 - Ensures code and applications are secure before deployment.

### For Organizations:
 
 - Prevents cyberattacks and data breaches.
 - Automates security monitoring, saving time and resources.
 - Helps companies meet compliance and legal security standards.

## Securing Microsoft Azure with Wazuh

- Microsoft Azure is a cloud computing platform that offers computing, storage, and networking services. Since Azure stores critical business data, securing it is essential.
- Wazuh enhances Azure security by collecting and analyzing security event data.
-  It helps detect threats, protect sensitive data, and ensure compliance.

### What Wazuh Monitors in Azure?
 
- **Azure Virtual Machines (VMs)** – Tracks activity and detects security risks.

- **Azure Services** – Uses Azure Log Analytics, Azure Storage, and Microsoft Graph to monitor cloud security.

- **Microsoft 365 Security** – Monitors Teams, OneDrive, and Exchange via Microsoft Graph API.

- **Microsoft Intune** – Ensures corporate devices follow security policies.

##  How to Configure Wazuh for Azure Security?

**Step 1: Check Prerequisites:** Make sure Wazuh and Azure integration permissions are enabled.

**Step 2: Connect Wazuh to Azure Log Analytics** : Allows Wazuh to collect security logs from Azure.

**Step 3: Configure Azure Storage:**  Stores security logs for long-term analysis.

**Step 4: Set Up Microsoft Graph API:** Enables monitoring of Microsoft 365 applications (Teams, OneDrive, Exchange).

**Step 5: Integrate Microsoft Intune:** Ensures secure device management in an organization.

## Examples of Wazuh in Action

**Scenario 1:** An employee downloads a suspicious file.
    
 -    Wazuh detects the threat, sends an alert, and blocks the file before it spreads.

**Scenario 2:** A hacker tries to access a company’s server.
 
 - Wazuh detects unauthorized access and automatically blocks the attacker's IP address.

**Scenario 3:** A business needs a security audit.

- Wazuh generates detailed reports, showing all security settings and risks.

## Conclusion
  
- Wazuh is a powerful, free security solution that protects organizations from cyber threats.
- Ideal for DevOps teams, IT security teams, and businesses to monitor and respond to security risks.
- Integrating Wazuh with Microsoft Azure improves cloud security, threat detection, and compliance.


