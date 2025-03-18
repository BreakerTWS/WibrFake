# WibrFake 🌐🔍

[![Version](https://img.shields.io/badge/version-0.0.2-blue.svg)](https://github.com/yourusername/wibrfake)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-Yes-success.svg)](https://github.com/yourusername/wibrfake)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg)](CONTRIBUTING.md)

**Advanced Wi-Fi Security Assessment Framework**  
*Professional tool for wireless network penetration testing and vulnerability analysis*

---

## 📖 Table of Contents
- [Key Features](#-key-features)
- [Ethical Considerations](#-ethical-considerations)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Basic Usage](#-basic-usage)
- [Attack Modules](#-attack-modules)
- [Captive Portal Templates](#-captive-portal-templates)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Key Features

### Core Capabilities
- **Rogue Access Point Deployment**
  - Custom SSID configuration
  - Multiple channel support
  - Traffic interception & analysis
- **Advanced MAC Spoofing**
  - OUI validation system
  - Random/preset MAC generation
  - MAC persistence management
- **Session Orchestration**
  - Parallel attack sessions
  - State preservation
  - Configuration versioning

### Enterprise-Grade Modules
| Module | Description |
|--------|-------------|
| **Evil Twin** | AP cloning with beacon flooding |
| **Captive Portal** | Credential harvesting framework |
| **WKdump Automation** | YAML-based attack configurations |

---

## ⚠ Ethical Considerations

**This tool must only be used for:**
- Authorized security audits
- Educational purposes
- Ethical penetration testing

**By using WibrFake, you agree to:**
- Comply with all applicable laws
- Obtain proper authorization
- Respect network privacy
- Never engage in malicious activities

---

## 🔧 Prerequisites

### Mandatory Requirements
```bash
sudo apt-get install -y \
hostapd \
libpcap-dev \
ruby \
ruby-full \
```

### Recommended Specifications
- Linux
- Wireless adapter supporting ap mode
- Dual-band Wi-Fi card (2.4GHz/5GHz)
- Minimum 2GB RAM

---

## 🚀 Installation

### Standard Setup
```bash
git clone https://github.com/BreakerTWS/WibrFake.git
cd WibrFake
sudo bundle install
sudo ruby wibrfake --help
```

### RubyGem (Recommended)
```bash
sudo gem install wibrfake-brk
sudo wibrfake --help
```

---
# Usage
This will launch a web server displaying the complete usage documentation for the wibrfake program:

```bash
    sudo wibrfake --usage
```
## 🕹 Basic Usage

### Initialization
```bash
sudo wibrfake --mode cli --iface wlan0
```

### MAC Management
```bash
# Show current configuration
mac status

#OUIs list
mac list

mac list 10..20

# Generate random MAC with valid OUI
mac ramset b2:fa:91

# Set specific MAC address
mac set 00:11:22:33:44:55
```

---

## ⚡ Attack Modules

### Rogue AP Deployment
```bash
set ssid Wifi_Free
apfake on
```

### Evil Twin Attack
```bash
Continue...
```

---

## 🔐 Captive Portal Templates

WibrFake supports enterprise-grade phishing templates:

| Template | Description | Authentication Methods |
|----------|-------------|-------------------------|
| **Basic Login** | Generic credential form | Username/Password |
| **Nauta Etecsa** | Cuban ISP portal clone | Account Nauta |
| **Nauta Hogar** | Residential ISP variant | Account Nauta |
| **Google** | Social media clone | OAuth/2FA |
| **Facebook** | Social media clone | Email/Phone |
| **Instagram** | Social media clone | Social credentials |

---

## 🤝 Contributing

We welcome responsible disclosures and ethical contributions. Please review our:
- [Contribution Guidelines](CONTRIBUTING.md)

---

## 📜 License

Distributed under MIT License. See [LICENSE](LICENSE) for full details.

---

## 🔒 Security Recommendations

For optimal security during audits:
1. Use dedicated hardware
2. Enable VPN tunneling
3. Regularly rotate MAC addresses
4. Limit attack surface
5. Destroy captured data post-audit

> **Warning**  
> Unauthorized use of this software violates international laws.  
> Developers assume no liability for misuse.
