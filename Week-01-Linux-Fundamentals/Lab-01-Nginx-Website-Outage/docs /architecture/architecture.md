# Project Architecture – AWS EC2 Nginx Incident Response Lab

## 1. Overview

This document describes the architecture of the DevOps Incident Response Lab.

The project uses AWS EC2 to host an Ubuntu Linux server running Nginx. Nginx serves a custom static website over HTTP.

The environment is used to simulate configuration failures, investigate service issues, perform recovery, and verify application availability.

## 2. Architecture Diagram

```text
                  END USER
                     |
                     |
                  Internet
                     |
                     |
             AWS Security Group
                 Inbound Rules
                 HTTP - Port 80
                 SSH - Port 22
                     |
                     |
              AWS EC2 INSTANCE
                t3.micro
                     |
                     |
              Ubuntu 26.04 LTS
                     |
                     |
                NGINX SERVER
                 Port 80
                     |
                     |
             NGINX SERVER BLOCK
                     |
                     |
          /var/www/devops-incident-lab
                     |
                     |
                index.html
                     |
                     |
              HTTP RESPONSE 200
```

## 3. Infrastructure Components

### AWS EC2

AWS EC2 provides the virtual machine used to host the Nginx web server.

Configuration:
- Instance type: t3.micro
- Region: ap-south-1 (Mumbai)
- Operating system: Ubuntu 26.04.1 LTS
- CPU: 2 vCPU
- Memory: Approximately 1 GB

### AWS Security Group

The Security Group controls inbound network access.

| Protocol | Port | Purpose |
|---|---:|---|
| TCP | 22 | SSH administration |
| TCP | 80 | HTTP website access |

SSH access should be restricted to trusted administrator IP addresses.

### Ubuntu Linux

Ubuntu is the operating system responsible for:
- Managing system services.
- Running Nginx.
- Providing Linux troubleshooting utilities.
- Maintaining system and application logs.
- Managing file permissions.

### Nginx Web Server

Nginx handles incoming HTTP requests and serves the static website.

Important paths:

| Path | Purpose |
|---|---|
| `/etc/nginx/nginx.conf` | Main Nginx configuration |
| `/etc/nginx/sites-available/` | Available virtual host configurations |
| `/etc/nginx/sites-enabled/` | Enabled virtual host configurations |
| `/var/www/devops-incident-lab/` | Website document root |
| `/var/log/nginx/` | Nginx logs |

### Static Website

The custom HTML page is hosted at:

`/var/www/devops-incident-lab/index.html`

Nginx serves the page when a user accesses the EC2 instance through HTTP.

## 4. Network Flow

1. A user opens the website using the EC2 public IPv4 address.
2. The request reaches the AWS Security Group.
3. The Security Group permits HTTP traffic on port 80.
4. The request reaches the Nginx service on the EC2 instance.
5. Nginx processes the request using the enabled server block.
6. Nginx reads the requested content from the website document root.
7. The server returns the HTML page to the user.
8. Nginx records the request in its access log.

## 5. Configuration Management

The project uses a dedicated Nginx server block:

`/etc/nginx/sites-available/devops-incident-lab`

The configuration is enabled using a symbolic link:

`/etc/nginx/sites-enabled/devops-incident-lab`

Before applying configuration changes, the following validation command is used:

```bash
nginx -t
```

A successful configuration test is required before reloading or starting Nginx with the updated configuration.

## 6. Monitoring and Troubleshooting

The following Linux utilities are used during incident investigation:

| Utility | Function |
|---|---|
| `systemctl` | Service status and management |
| `journalctl` | systemd service logs |
| `nginx -t` | Configuration validation |
| `ss` | Network socket inspection |
| `curl` | HTTP connectivity verification |
| `tail` | Log inspection |
| `df` | Disk utilization |
| `free` | Memory utilization |

## 7. Incident Recovery Architecture

The recovery process follows this sequence:

```text
       Incident Detection
               |
               v
       Service Investigation
               |
               v
       Configuration Validation
               |
               v
          Root Cause
          Identification
               |
               v
        Backup Verification
               |
               v
        Configuration Fix
               |
               v
          nginx -t
               |
          +----+----+
          |         |
        PASS       FAIL
          |         |
          v         v
      Apply Fix   Investigate
          |
          v
     Start / Reload
          |
          v
    HTTP Verification
          |
          v
     Service Recovered
```

## 8. Security Considerations

- Use a dedicated lab instance for failure simulations.
- Restrict SSH access to trusted IP addresses.
- Avoid exposing administrative services unnecessarily.
- Do not commit passwords, private keys, or credentials to GitHub.
- Keep configuration backups before making changes.
- Avoid experimenting on production infrastructure.

## 9. Conclusion

This architecture provides a simple but practical environment for learning AWS infrastructure, Linux administration, Nginx configuration, incident troubleshooting, and service recovery.

It demonstrates how an infrastructure issue can be detected, investigated, corrected, and verified using standard DevOps operational practices.
