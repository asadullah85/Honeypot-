# Honeypot

A live honeypot deployed on a DigitalOcean cloud server to capture and analyze 
real-world attack behavior. Built using T-Pot (Telekom Security) on Ubuntu 24.04, 
the honeypot ran multiple trap services simultaneously including Cowrie (fake SSH), 
Honeytrap, Sentrypeer, Dionaea, and more — capturing over 55,000 attacks within 
24 hours of going live.

Attack data was visualized in real time using an Elasticsearch/Kibana dashboard, 
revealing attacker origins, targeted ports, and credential attempts from across 
the globe. A UFW firewall was configured to control exposed attack surfaces while 
keeping management ports secured. Automated Discord alerts were set up via webhook 
and cron jobs to deliver live attack notifications every minute.

## Server Architecture
```mermaid
flowchart TD
    A["Internet / Attackers"] --> B["UFW Firewall\nAllow: 22, 23, 80, 443, 64295, 64297\nDefault: Deny All Incoming"]
    B --> C["T-Pot / Docker"]

    C --> D["Cowrie\nFake SSH/Telnet"]
    C --> E["Honeytrap\nPort Scanner Trap"]
    C --> F["Dionaea\nMalware Trap"]
    C --> G["Sentrypeer\nVoIP/SIP Trap"]
    C --> H["15+ More Honeypot Services"]

    D --> I["Kibana Dashboard\nAttack map, charts, logs"]
    E --> I
    F --> I
    G --> I
    H --> I

    D --> J["discord_alert.sh\nCron job every minute"]
    J --> K["Discord\nLive attack alerts"]

    I --> L["Analyst\nViews attack data"]
    K --> L
```

### Flow Overview
- **Attackers** from the internet hit the **UFW Firewall** first
- UFW only allows traffic through on specific ports — everything 
  else is blocked by default
- Allowed traffic reaches **T-Pot's honeypot services** running 
  inside Docker containers (Cowrie, Honeytrap, Dionaea, Sentrypeer and more)
- All attack data is logged and visualized in the **Kibana Dashboard**
- Simultaneously the **discord_alert.sh** bash script runs every minute 
  via cron job, extracting Cowrie logs and sending live attack 
  notifications to **Discord**


## ⚙️ Specs & Security

### Cloud Server (DigitalOcean Droplet)
| Component | Requirement |
|---|---|
**OS** | Ubuntu 24.04 LTS x64 |
| **RAM** | 8 GB minimum |
| **CPU** | 2-4 vCPUs |
| **Storage** | 160 GB SSD |
| **Region** | Any (Toronto used in this project) |
| **Provider** | DigitalOcean (or any cloud provider) |

### Software & Tools
| Tool | Purpose |
|---|---|
| **T-Pot (Telekom Security)** | Honeypot framework |
| **Elasticsearch & Kibana** | Attack data visualization |
| **Docker** | Runs all honeypot containers |
| **UFW** | Firewall configuration |
| **Cowrie** | Fake SSH/Telnet honeypot |
| **Discord Webhook** | Real time attack alerts |
| **Cron** | Automated alert scheduling |
| **Git** | Cloning T-Pot repository |

### Secure Authentication
| Password Type | Purpose | Recommended Requirements |
|---|---|---|
| **DigitalOcean Root Password** | SSH access to the droplet as root | Min 8 chars, uppercase, lowercase, number, special character |
| **Non-Root User Password** | Daily server management as non-root user | Min 8 chars, uppercase, lowercase, number, special character |
| **T-Pot Web Password** | Login to Kibana/Elastic dashboard | Min 8 chars, no special characters (T-Pot restriction) |
| **Discord Webhook URL** | Authenticates alert script to Discord channel | Treat as a password — never share or commit to GitHub publicly |

## 🛠️Setup

### Step 1 — Create Droplet/ VPS

Cloud Provider: For this project any cloud provided is good but I used digital ocean

![DigitalOcean Droplet Setup](https://github.com/asadullah85/Honeypot-/blob/main/Media-Honeypot/Screenshot%202026-03-16%20011101.jpg?raw=true)

Pick Region: For the region I picked Toronto as I am closest to it

![Region](https://github.com/asadullah85/Honeypot-/blob/main/Media-Honeypot/Screenshot%202026-03-16%20005551.png?raw=true)


Choosing an image: For this project I picked Unbuntu 24.4(lts) x 64. Digital ocean provides other images that would work fine for this porject like Debian, but since Unbuntu is drectly supported by Telekom security I chose to go with that.

![Image](https://github.com/asadullah85/Honeypot-/blob/main/Media-Honeypot/Screenshot%202026-03-16%20005631.jpg?raw=true)

Authentication Method: For the authentication method, SSH is a much safer option. In my case I was only going to run this droplet for around 32 hours and SSH is used for servers that run long term. Using password was quicker for the actual setup of the Honey pot and was better for analyzing real-time attack data. Thus, a strong password is very important to implement! 

![Password](https://github.com/asadullah85/Honeypot-/blob/main/Media-Honeypot/Screenshot%202026-03-16%20005736.jpg?raw=true)

Improved Metrics Monitoring: For a server getting 1,800+ attacks an hour with 15+ tpot services running all at once inside Docker, it is very important to be able to see if the droplet is able to handle all of that attack load. This feature tracks network traffic, CPU usage, RAM consumption, and disk I/O.

![Metrics](https://github.com/asadullah85/Honeypot-/blob/main/Media-Honeypot/Screenshot%202026-03-16%20005802.jpg?raw=true)

---

## 🔗 T-Pot Repository

This project uses the official T-Pot framework developed by Telekom Security.
T-Pot is an all-in-one honeypot platform that runs 20+ honeypot services 
simultaneously inside Docker containers. If you too would like to run these tpot services then here is the Github Repo link.

**Official Repository:** [Telekom Security T-Pot](https://github.com/telekom-security/tpotce)

---


---

## 🔥 UFW Firewall Configuration

To add an additional layer of security and control over the honeypot, 
UFW was configured on the droplet. The goal 
was to intentionally expose only the necessary ports to attract attackers 
while keeping management ports secured.

### Why UFW?
Without a firewall every port on the server is completely uncontrolled. 
UFW allowed full control over exactly what traffic could reach the server 
— blocking everything by default and only allowing specific ports through.

### Firewall Rules

| Port | Protocol | Reason |
|---|---|---|
| **64295** | TCP | New SSH management port (T-Pot changes default port 22) |
| **64297** | TCP | T-Pot Kibana dashboard access |
| **22** | TCP | Intentionally exposed — attracts SSH brute force attackers into Cowrie trap |
| **23** | TCP | Intentionally exposed — attracts Telnet attackers |
| **80** | TCP | Intentionally exposed — attracts HTTP based attacks |
| **443** | TCP | Intentionally exposed — attracts HTTPS based attacks |

### Key Detail
The default policy was set to **deny all incoming traffic** meaning 
any port not explicitly listed above is completely blocked. This gave 
full control over the attack surface while still allowing the honeypot 
traps to function properly.

### UFW Commands Used
![UFW Commands](https://github.com/asadullah85/Honeypot/blob/main/Media-Honeypot/Screenshot%202026-03-20%20223338.jpg?raw=true)

### UFW Status
![UFW Status](https://github.com/asadullah85/Honeypot/blob/main/Media-Honeypot/Screenshot%202026-03-20%20223452.jpg?raw=true)






