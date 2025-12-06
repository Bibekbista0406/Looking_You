# 🔍 LOOK_For_Kri

<div align="center">

[![Version](https://img.shields.io/badge/Version-1.1-00ffff?style=for-the-badge&logo=github)](https://github.com/bibekbista/look-for-kri)
[![License](https://img.shields.io/badge/License-MIT-ff00ff?style=for-the-badge&logo=opensourceinitiative)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-Script-yellow?style=for-the-badge&logo=gnubash)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Termux%20%7C%20MacOS-00ff00?style=for-the-badge&logo=linux)]()

**Advanced Geolocation & Security Testing Tool for Authorized Penetration Testing**

![LOOK_For_Kri Banner](https://img.shields.io/badge/LOOK_For_Kri-Cyber_Security_Tool-050510?style=for-the-badge&logo=probot&labelColor=0a0a1a&color=00ffff)

</div>

## 📌 Table of Contents
- [⚠️ **Important Notice**](#️-important-notice)
- [🌟 **Features**](#-features)
- [🚀 **Quick Start**](#-quick-start)
- [📦 **Installation**](#-installation)
  - [Method 1: Clone Repository](#method-1-clone-repository)
  - [Method 2: Direct Download](#method-2-direct-download)
  - [Method 3: Termux Installation](#method-3-termux-installation)
- [🛠️ **Usage**](#️-usage)
  - [Basic Usage](#basic-usage)
  - [Command Line Options](#command-line-options)
  - [Interactive Menu](#interactive-menu)
- [🔧 **Configuration**](#-configuration)
  - [Page Templates](#page-templates)
  - [Tunnel Options](#tunnel-options)
- [📊 **Data Collection**](#-data-collection)
  - [What Data is Collected?](#what-data-is-collected)
  - [Data Storage](#data-storage)
- [🔒 **Security & Ethics**](#-security--ethics)
  - [Legal Disclaimer](#legal-disclaimer)
  - [Ethical Guidelines](#ethical-guidelines)
- [🤝 **Contributing**](#-contributing)
- [🐛 **Troubleshooting**](#-troubleshooting)
- [📞 **Support**](#-support)
- [👨‍💻 **Author**](#-author)
- [📜 **License**](#-license)

## ⚠️ **Important Notice**

<div align="center">

> **🚨 WARNING: This tool is for EDUCATIONAL PURPOSES ONLY**

</div>

**READ THIS CAREFULLY BEFORE USING:**

- ✅ **Authorized Use Only** - Use only for penetration testing on systems you own or have written permission to test
- ✅ **Educational Purpose** - Designed for learning about geolocation vulnerabilities and security research
- ✅ **Security Awareness** - Helps understand how location tracking attacks work to better defend against them
- ❌ **NOT for Illegal Activities** - Do not use for unauthorized access, harassment, or any illegal purposes
- ❌ **NOT for Malicious Use** - Do not use to harm or compromise systems without authorization
- ❌ **NOT for Privacy Violation** - Do not use to violate anyone's privacy without consent

**The developer is NOT responsible for any misuse or illegal activities conducted with this tool.**

## 🌟 **Features**

### 🎯 **Advanced Geolocation**
| Feature | Description |
|---------|-------------|
| **GPS Location** | High-precision GPS coordinates with accuracy metrics |
| **IP Geolocation** | IP-based location with city, country, and ISP details |
| **Network Information** | Connection type, speed, and cellular data detection |
| **Device Fingerprinting** | Browser, OS, screen resolution, and hardware details |

### 🌐 **Multiple Tunnel Support**
| Tunnel | Type | Account Required | Best For |
|--------|------|------------------|----------|
| **Cloudflare** | Free Tunnel | ❌ No | Quick testing, No setup |
| **Ngrok** | Professional | ✅ Yes | Reliable, Long sessions |
| **localhost.run** | SSH Tunnel | ❌ No | Advanced users, Free |
| **Local Server** | Local Network | ❌ No | Internal testing, LAN |

### 🎨 **Professional Page Templates**
| Template | Description | Use Case |
|----------|-------------|----------|
| **🎂 Birthday Page** | Festive birthday wishing page | Social engineering tests |
| **🔗 Custom Redirect** | URL redirect with security notice | Phishing awareness training |
| **🏠 Landing Page** | Professional service landing page | Penetration testing scenarios |

### 🔧 **Technical Features**
- 🖥️ **Terminal UI** - Colorful ASCII art with interactive menus
- 📱 **Cross-Platform** - Works on Linux, Termux, MacOS
- 🔄 **Auto-Dependency** - Automatic dependency installation
- 🛡️ **Error Handling** - Comprehensive error checking and recovery
- 📈 **Real-time Monitoring** - Live data collection and display

## 🚀 **Quick Start

### Installation in 3 Steps:
```bash
# Step 1: Clone the repository
git clone https://github.com/bibekbista/look-for-kri.git

# Step 2: Navigate to directory
cd look-for-kri

# Step 3: Make script executable and run
chmod +x look-kri.sh
./look-kri.sh
First Run Demo:
bash
╔══════════════════════════════════════════════╗
║  LOOK_For_Kri v1.1 - Starting...            ║
╚══════════════════════════════════════════════╝

[+] Checking dependencies...
[+] All dependencies satisfied!
[+] Select page template...
[+] Choose tunnel method...
[✓] Server started successfully!
[→] Your link: https://example.trycloudflare.com
📦 Installation
Prerequisites
Ensure you have the following installed on your system:

Requirement	Minimum Version	Check Command
Bash	4.0+	bash --version
PHP	7.4+	php --version
cURL	Latest	curl --version
wget	Latest	wget --version
Method 1: Clone Repository (Recommended)
bash
# Clone the repository
git clone https://github.com/bibekbista/look-for-kri.git

# Navigate to directory
cd look-for-kri

# Set execute permissions
chmod +x look-kri.sh

# Run the fixer to install dependencies
./look-kri.sh --fix
Method 2: Direct Download
bash
# Download script directly
wget https://raw.githubusercontent.com/bibekbista/look-for-kri/main/look-kri.sh

# Make executable
chmod +x look-kri.sh

# Run with fix option
./look-kri.sh --fix
Method 3: Termux Installation (Android)
bash
# Update packages
pkg update && pkg upgrade

# Install dependencies
pkg install php curl wget git openssh -y

# Clone repository
git clone https://github.com/bibekbista/look-for-kri.git

# Navigate and run
cd look-for-kri
chmod +x look-kri.sh
./look-kri.sh
System-Specific Installation
<details> <summary><b>📦 Debian/Ubuntu</b></summary>
bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install -y php curl wget git ssh

# Clone and run
git clone https://github.com/bibekbista/look-for-kri.git
cd look-for-kri
chmod +x look-kri.sh
./look-kri.sh
</details><details> <summary><b>🐧 Fedora/RHEL/CentOS</b></summary>
bash
# Install dependencies
sudo dnf install -y php curl wget git openssh
# or
sudo yum install -y php curl wget git openssh

# Clone and run
git clone https://github.com/bibekbista/look-for-kri.git
cd look-for-kri
chmod +x look-kri.sh
./look-kri.sh
</details><details> <summary><b>🍎 macOS</b></summary>
bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install php curl wget git

# Clone and run
git clone https://github.com/bibekbista/look-for-kri.git
cd look-for-kri
chmod +x look-kri.sh
./look-kri.sh
</details>
🛠️ Usage
Basic Usage
bash
# Run the tool
./look-kri.sh

# Follow the interactive menu:
# 1. Select page template
# 2. Choose tunnel method
# 3. Share generated link with target
# 4. Monitor collected data in real-time
Command Line Options
Option	Short	Description
--help	-h	Show help message and exit
--fix	-f	Fix tunnel issues and install dependencies
--version	-v	Display version information
--local	-l	Start local server only (no tunnel)
Examples:

bash
# Show help
./look-kri.sh --help

# Fix installation issues
./look-kri.sh --fix

# Run local server only
./look-kri.sh --local
Interactive Menu Walkthrough
text
╔══════════════════════════════════════════════╗
║  LOOK_For_Kri v1.1 - Main Menu              ║
╚══════════════════════════════════════════════╝

[1] Birthday Wishing Page 🎂
[2] Custom URL Redirect 🔗
[3] Simple Landing Page 🏠

Choose page [1-3]: 1

[1] Cloudflare Tunnel (Free, No Account)
[2] Ngrok Tunnel (Requires Account)
[3] localhost.run (SSH required)
[4] Local Server Only

Choose tunnel method [1-4]: 1

[✓] Server started successfully!
[→] Your link: https://secure-link.trycloudflare.com
[→] Waiting for connections...
🔧 Configuration
Page Templates
<details> <summary><b>🎂 Birthday Wishing Page</b></summary>
Features:

🎉 Festive birthday theme

🎵 Background music

🎂 Animated cake with candles

🎊 Confetti effects

📍 Location request with friendly message

Use Case: Social engineering awareness training

</details><details> <summary><b>🔗 Custom URL Redirect</b></summary>
Features:

🔒 Security verification notice

⏱️ 5-second countdown

🛡️ Security features list

📍 Location verification

🔗 Custom redirect URL

Use Case: Phishing simulation and redirect testing

</details><details> <summary><b>🏠 Landing Page</b></summary>
Features:

🌐 Professional design

📍 Location-based services

💼 Feature showcases

👥 Testimonials section

📞 Contact information

Use Case: Penetration testing and security assessment

</details>
Tunnel Options
<details> <summary><b>🌐 Cloudflare Tunnel</b></summary>
Pros:

✅ Free, no account required

✅ Easy setup

✅ No authentication needed

✅ Good for quick tests

Setup:

bash
# Automatic setup - just choose option 1
[1] Cloudflare Tunnel (Free, No Account)
</details><details> <summary><b>🚀 Ngrok Tunnel</b></summary>
Pros:

✅ More reliable

✅ Longer session times

✅ Custom subdomains

✅ Better stability

Setup:

Sign up at ngrok.com

Get your authtoken

Configure ngrok:

bash
ngrok config add-authtoken YOUR_TOKEN
Choose option 2 in the menu

</details><details> <summary><b>🔐 localhost.run</b></summary>
Pros:

✅ Free

✅ No authentication

✅ SSH-based

✅ Good alternative

Requirements:

SSH client installed

Internet connection

Setup:

bash
# Ensure SSH is installed
sudo apt install openssh-client

# Choose option 3 in the menu
</details><details> <summary><b>💻 Local Server</b></summary>
Pros:

✅ No internet required

✅ Complete control

✅ Good for LAN testing

✅ No external dependencies

Setup:

bash
# Choose option 4
# Use provided local IP for network access
# Example: http://192.168.1.100:9999
</details>
📊 Data Collection
What Data is Collected?
Category	Data Points	Purpose
Location	GPS coordinates, IP location, Accuracy	Geolocation analysis
Device	Browser, OS, Screen size, Platform	Device fingerprinting
Network	IP address, ISP, Connection type	Network analysis
Behavior	Clicks, Scrolls, Time on page	User interaction tracking
Technical	Timezone, Language, Cookies	Technical environment data
Data Storage
File Structure:

text
look-for-kri/
├── data.txt          # Complete collected data log
├── ip.txt           # IP addresses (real-time)
├── saved.ip.txt     # Historical IP records
├── targetreport.txt # Comprehensive target reports
└── logs/           # Session logs (if enabled)
Data Format Example:

json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "ip": "192.168.1.100",
  "location": {
    "latitude": 40.7128,
    "longitude": -74.0060,
    "accuracy": 50,
    "city": "New York",
    "country": "United States"
  },
  "device": {
    "browser": "Chrome 120.0",
    "os": "Windows 10",
    "screen": "1920x1080"
  }
}
Data Privacy & Security
🔐 Local Storage - All data stored locally on your machine

🗑️ Manual Deletion - Clear data files when no longer needed

📝 Transparent - No hidden data collection

⚖️ Compliant - Follows ethical data handling practices

🔒 Security & Ethics
Legal Disclaimer
IMPORTANT LEGAL NOTICE:

text
THIS TOOL IS PROVIDED FOR EDUCATIONAL PURPOSES ONLY. 
THE DEVELOPER ASSUMES NO LIABILITY AND IS NOT RESPONSIBLE 
FOR ANY MISUSE OR DAMAGE CAUSED BY THIS PROGRAM.

BY USING THIS TOOL, YOU AGREE TO:
1. Use it only for authorized security testing
2. Obtain written permission before testing any system
3. Comply with all applicable laws and regulations
4. Not use it for any illegal or malicious purposes
Ethical Guidelines
<table> <tr> <th>✅ DO</th> <th>❌ DON'T</th> </tr> <tr> <td>
✅ Test only systems you own
✅ Get written permission
✅ Use for educational purposes
✅ Report vulnerabilities responsibly
✅ Follow bug bounty programs
✅ Respect privacy laws

</td> <td>
❌ Test without permission
❌ Use for illegal activities
❌ Harm systems or networks
❌ Violate privacy rights
❌ Share collected data
❌ Bypass security measures

</td> </tr> </table>
Responsible Disclosure
If you discover vulnerabilities using this tool:

📧 Contact the system owner immediately

🔐 Provide details privately

⏳ Allow reasonable time for fixing

📝 Document your findings ethically

🤝 Work cooperatively on solutions

🤝 Contributing
We welcome contributions! Here's how you can help:

Ways to Contribute
🐛 Report Bugs - Open an issue with detailed information

💡 Suggest Features - Share your ideas for improvement

📝 Improve Documentation - Help make docs better

🔧 Submit Code - Fix bugs or add new features

🌐 Translate - Help translate to other languages

Development Setup
bash
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/look-for-kri.git
cd look-for-kri

# Create a feature branch
git checkout -b feature/your-feature-name

# Make your changes
# Test thoroughly
# Commit with descriptive message
git commit -m "Add: Description of your feature"

# Push to your fork
git push origin feature/your-feature-name

# Create a Pull Request
Code Style Guidelines
Use meaningful variable names

Add comments for complex logic

Follow existing code structure

Test changes before submitting

Update documentation if needed

🐛 Troubleshooting
Common Issues & Solutions
<details> <summary><b>❌ Cloudflare Tunnel Fails</b></summary>
Symptoms:

"Failed to get Cloudflare tunnel URL"

Cloudflared stops immediately

No link generated

Solutions:

bash
# Solution 1: Use the fixer
./look-kri.sh --fix

# Solution 2: Try different tunnel
# Choose Ngrok or localhost.run instead

# Solution 3: Manual cloudflared download
rm -f cloudflared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
./look-kri.sh
</details><details> <summary><b>❌ PHP Server Won't Start</b></summary>
Symptoms:

"PHP server failed to start"

Port already in use

Permission denied

Solutions:

bash
# Solution 1: Check if PHP is installed
php --version

# Solution 2: Install PHP
sudo apt install php  # Debian/Ubuntu
sudo yum install php  # RHEL/CentOS
pkg install php       # Termux

# Solution 3: Kill existing processes
pkill -f php
./look-kri.sh
</details><details> <summary><b>❌ Ngrok Authentication Error</b></summary>
Symptoms:

"Ngrok authentication failed"

No valid authtoken

Solutions:

bash
# Solution 1: Get and set authtoken
# 1. Sign up at ngrok.com
# 2. Get your authtoken from dashboard
# 3. Configure:
ngrok config add-authtoken YOUR_TOKEN

# Solution 2: Use different tunnel
# Choose Cloudflare or localhost.run
</details><details> <summary><b>❌ Permission Denied Errors</b></summary>
Symptoms:

"Permission denied"

Cannot execute script

Solutions:

bash
# Solution: Set execute permissions
chmod +x look-kri.sh

# If still issues, run with sudo (not recommended)
sudo chmod +x look-kri.sh
</details>
Debug Mode
For advanced troubleshooting:

bash
# Run with verbose output
bash -x look-kri.sh

# Check specific component
./look-kri.sh --local  # Test local server only
📞 Support
Getting Help
📖 Read Documentation - Check this README first

🔍 Search Issues - Look for similar problems

💬 Community Chat - Join our Discord (coming soon)

🐛 Report Bugs - Use GitHub Issues

Issue Reporting Template
When reporting issues, please include:

markdown
**Description:**
[Brief description of the issue]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior:**
[What should happen]

**Actual Behavior:**
[What actually happens]

**System Information:**
- OS: [e.g., Ubuntu 22.04]
- Bash Version: [e.g., 5.1.16]
- PHP Version: [e.g., 8.1.2]
- Terminal: [e.g., GNOME Terminal]

**Screenshots/Logs:**
[Paste any relevant output]
👨‍💻 Author
<div align="center">
Bibek Bista
Security Researcher & Developer

https://img.shields.io/badge/GitHub-bibekbista-181717?style=flat-square&logo=github
https://img.shields.io/badge/Twitter-@bibekbista-1DA1F2?style=flat-square&logo=twitter
https://img.shields.io/badge/LinkedIn-Bibek_Bista-0A66C2?style=flat-square&logo=linkedin
https://img.shields.io/badge/Email-contact%2540bibekbista.com-D14836?style=flat-square&logo=gmail

</div>
About the Author
Bibek Bista is a passionate security researcher and developer with expertise in cybersecurity, penetration testing, and ethical hacking. He creates educational tools to help security professionals understand vulnerabilities and improve defenses.

Acknowledgments
Thanks to all contributors and testers

Inspired by various security research tools

Built with ❤️ for the security community

📜 License
text
MIT License

Copyright (c) 2024 Bibek Bista

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
<div align="center">
⭐ Star this repository if you found it useful!
https://api.star-history.com/svg?repos=bibekbista/look-for-kri&type=Date

Remember: With great power comes great responsibility. Use this tool ethically!

</div> ```
