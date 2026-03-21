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


## ⚙️ Specs

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








