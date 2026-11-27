# DevOps Incident Response Lab – AWS EC2 & Nginx

## Project Overview

The **DevOps Incident Response Lab** is a hands-on infrastructure deployment and troubleshooting project implemented on AWS EC2 using Ubuntu Linux and Nginx.

The project demonstrates how to deploy and manage a web server, identify Nginx configuration failures, perform root cause analysis, recover services, and verify infrastructure health.

Three real-world Nginx configuration failure scenarios were intentionally introduced, investigated, corrected, and documented.

The objective is to demonstrate practical DevOps skills in Linux administration, cloud infrastructure, web server management, incident response, troubleshooting, and service recovery.

## Project Objectives

- Deploy an Ubuntu EC2 instance on AWS.
- Install and configure the Nginx web server.
- Host a custom website using Nginx.
- Configure Nginx virtual hosting.
- Simulate real-world Nginx configuration incidents.
- Identify configuration errors using diagnostic commands.
- Perform root cause analysis and remediation.
- Restore services and validate website availability.
- Automate health checks and evidence collection.
- Maintain incident reports and recovery documentation.

## Architecture

```text
                  INTERNET
                     |
                     v
              AWS SECURITY GROUP
                 HTTP : 80
                 SSH  : 22
                     |
                     v
               AWS EC2 INSTANCE
                  t3.micro
                     |
                     v
                UBUNTU 26.04
                     |
                     v
                NGINX SERVER
                  Port 80
                     |
                     v
              WEBSITE HOSTING
                     |
                     v
          /var/www/devops-incident-lab
                     |
                     v
               WEBSITE ACCESS
                     |
                     v
             INCIDENT MONITORING
                     |
                     v
           CONFIGURATION VALIDATION
                     |
                     v
              INCIDENT DETECTION
                     |
                     v
               ROOT CAUSE ANALYSIS
                     |
                     v
               CONFIGURATION FIX
                     |
                     v
               SERVICE RECOVERY
                     |
                     v
              FINAL VERIFICATION
                     |
                     v
                 HTTP 200 OK
```

## Technology Stack

| Technology | Purpose |
|---|---|
| AWS EC2 | Cloud infrastructure |
| Ubuntu 26.04.1 LTS | Operating system |
| Nginx 1.28.3 | Web server |
| Linux Shell | System administration |
| Bash | Automation scripts |
| GitHub | Source code and documentation |
| HTTP | Website communication |

## Infrastructure Details

| Component | Configuration |
|---|---|
| Cloud Provider | Amazon Web Services |
| AWS Region | ap-south-1 (Mumbai) |
| Instance Type | t3.micro |
| Operating System | Ubuntu 26.04.1 LTS |
| Web Server | Nginx 1.28.3 |
| HTTP Port | 80 |
| SSH Port | 22 |
| Website Root | `/var/www/devops-incident-lab` |
| Nginx Configuration | `/etc/nginx/sites-available/devops-incident-lab` |

## Implementation

### 1. AWS EC2 Infrastructure Setup

- Launched an Ubuntu EC2 instance.
- Configured the security group.
- Allowed SSH access from the administrator's IP.
- Allowed HTTP traffic on port 80.
- Connected to the instance using SSH.

### 2. Nginx Installation and Configuration

- Updated Ubuntu packages.
- Installed Nginx.
- Created a custom website directory.
- Deployed a custom HTML homepage.
- Created a dedicated Nginx server configuration.
- Enabled the Nginx site.
- Validated the configuration.
- Enabled and started the Nginx service.

### 3. Website Deployment

Deployed a custom homepage displaying:

**Welcome to My DevOps Project!**

The website includes an operational status indicator and project information.

Website access:

```text
http://<EC2_PUBLIC_IP>/
```

Replace `<EC2_PUBLIC_IP>` with the current public IP of your EC2 instance.

## Incident Response Scenarios

Three Nginx configuration failure scenarios were simulated and resolved.

### INC-001: Unknown Nginx Directive

**Fault injected:**

```nginx
invalid_nginx_directive on;
```

**Error detected:**

```text
unknown directive "invalid_nginx_directive"
```

**Impact:**

Nginx failed to start with the invalid configuration, causing website unavailability.

**Resolution:**

1. Inspected the Nginx configuration.
2. Identified the unsupported directive.
3. Removed the faulty configuration line.
4. Validated the corrected configuration.
5. Started the Nginx service.
6. Verified website availability.

**Result:** Successful service recovery.

### INC-002: Invalid Root Directive Arguments

**Fault injected:**

```nginx
root /var/www/devops-incident-lab /wrong-path;
```

**Error detected:**

```text
invalid number of arguments in "root" directive
```

**Impact:**

Nginx configuration validation failed. The existing Nginx process remained active and continued serving requests using its previously loaded valid configuration.

**Resolution:**

1. Inspected the Nginx site configuration.
2. Identified the additional argument.
3. Removed the faulty configuration line.
4. Executed `nginx -t`.
5. Reloaded Nginx after successful validation.
6. Verified website availability.

**Result:** Successful configuration recovery.

### INC-003: Wrong Directive Context

**Fault injected:**

```nginx
worker_processes 2;
```

The directive was incorrectly placed inside the server block.

**Error detected:**

```text
"worker_processes" directive is not allowed here
```

**Impact:**

Nginx configuration validation failed. The existing Nginx process continued serving requests using its previously loaded valid configuration.

**Resolution:**

1. Inspected the Nginx configuration.
2. Identified the misplaced directive.
3. Removed it from the server block.
4. Validated the configuration using `nginx -t`.
5. Reloaded Nginx.
6. Verified service and website availability.

**Result:** Successful configuration recovery.

## Troubleshooting Commands

| Command | Purpose |
|---|---|
| `nginx -t` | Validate Nginx configuration |
| `nginx -v` | Check Nginx version |
| `systemctl status nginx` | Check service status |
| `systemctl restart nginx` | Restart Nginx |
| `systemctl reload nginx` | Reload configuration |
| `systemctl is-enabled nginx` | Check startup configuration |
| `journalctl -u nginx` | Inspect service logs |
| `tail -f /var/log/nginx/error.log` | Monitor Nginx errors |
| `ss -lntp` | Check listening ports |
| `curl -I http://localhost/` | Verify HTTP response |

## Recovery and Verification

After remediation, the following checks were performed:

- Nginx configuration validation successful.
- Nginx service active.
- Nginx enabled at system startup.
- Port 80 listening.
- Website returning HTTP 200.
- Expected website content verified.

### Final Validation

```bash
nginx -t

systemctl is-active nginx

systemctl is-enabled nginx

curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/
```

Expected results:

```text
Configuration test: successful
Service status: active
Boot status: enabled
HTTP Status: 200
```

## Automation Scripts

The project includes two Bash scripts.

**health-check.sh**

Automates:

- Nginx version verification.
- Configuration validation.
- Service status checks.
- Port 80 verification.
- Local HTTP response checks.

**collect-evidence.sh**

Collects:

- System information.
- Operating system details.
- Nginx version.
- Configuration validation output.
- Service status.
- Listening port information.
- HTTP response.
- Disk usage.
- Recent Nginx error logs.

## Project Structure

```text
devops-incident-response-lab/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── architecture/
│   │   ├── architecture.md
│   │   └── architecture-diagram.png
│   │
│   ├── incident-reports/
│   │   ├── INC-001-unknown-nginx-directive.md
│   │   ├── INC-002-invalid-root-directive.md
│   │   └── INC-003-wrong-directive-context.md
│   │
│   ├── implementation-guide.md
│   └── troubleshooting-guide.md
│
├── evidence/
│   ├── baseline.txt
│   ├── INC-001-recovery.txt
│   ├── INC-002-detection.txt
│   ├── INC-002-recovery.txt
│   ├── INC-003-detection.txt
│   └── INC-003-recovery.txt
│
├── screenshots/
│   ├── 01-ec2-instance.png
│   ├── 02-website-homepage.png
│   ├── 03-nginx-validation.png
│   ├── 04-nginx-service-status.png
│   ├── 05-incident-001.png
│   ├── 06-incident-002.png
│   ├── 07-incident-003.png
│   └── 08-final-verification.png
│
├── scripts/
│   ├── health-check.sh
│   └── collect-evidence.sh
│
└── backup/
    └── nginx-working-config.conf
```

## Key Learnings

Through this project, I gained practical experience in:

- AWS EC2 provisioning and configuration.
- Ubuntu Linux administration.
- Nginx installation and web server management.
- Nginx configuration troubleshooting.
- Linux service management using systemd.
- Incident detection and root cause analysis.
- Configuration backup and recovery.
- Bash scripting and automation.
- Infrastructure health verification.
- Technical documentation and incident reporting.

## Future Improvements

- Implement HTTPS using SSL/TLS certificates.
- Configure Nginx monitoring and alerting.
- Integrate Prometheus and Grafana.
- Implement automated configuration backups.
- Introduce CI/CD-based deployment.
- Add centralized log monitoring.

**Project Status:** Completed

*This project demonstrates hands-on AWS infrastructure deployment, Nginx troubleshooting, incident response, and service recovery through practical implementation.*
