# Linux & DevOps Troubleshooting Labs

## Project Overview

This repository contains 12 hands-on Linux and DevOps troubleshooting labs focused on practical system administration, incident management, service recovery, and production-oriented problem-solving.

The project demonstrates real-world troubleshooting scenarios, including service failures, resource utilization issues, network connectivity problems, web server configuration errors, and application-level incidents.

Each lab covers issue identification, investigation, root cause analysis, corrective actions, and final verification.

## Project Objectives

- Develop practical Linux system administration skills.
- Troubleshoot common Linux server issues.
- Investigate service failures and application downtime.
- Analyze system logs and error messages.
- Monitor CPU, memory, disk, and process utilization.
- Manage Linux services using systemd.
- Configure and troubleshoot Nginx.
- Investigate network connectivity issues.
- Perform incident investigation and root cause analysis.
- Document troubleshooting procedures and resolutions.

## Technologies & Tools

| Category | Technologies / Tools |
|---|---|
| Operating System | Ubuntu Linux |
| Web Server | Nginx |
| Service Management | systemctl, systemd |
| Process Management | ps, top, htop |
| Log Analysis | journalctl, grep |
| Network Troubleshooting | curl, ss, ping |
| Disk Management | df, du, lsblk |
| Resource Monitoring | free, uptime |
| Version Control | Git, GitHub |
| Scripting | Bash |
| Containerization | Docker |

## Completed Hands-on Labs

### Lab 01 – Linux Fundamentals & System Administration
- Linux directory structure.
- Essential Linux commands.
- File and directory management.
- User and permission management.
- Process investigation.
- System resource monitoring.

### Lab 02 – Nginx Deployment & Incident Troubleshooting
- Custom website creation using Nginx.
- Nginx installation and configuration.
- Website deployment and HTTP 200 verification.
- Simulated service outage.
- Incident investigation using Linux commands.
- Error log analysis and service recovery.

### Lab 03 – Linux Service Management & Troubleshooting
- Systemd service management.
- Service status investigation.
- Failed service troubleshooting.
- Service restart and recovery.
- Boot-time service configuration.

### Lab 04 – Linux CPU & Memory Troubleshooting
- CPU utilization investigation.
- Memory utilization analysis.
- Process resource monitoring.
- High resource consumption investigation.
- Performance troubleshooting.

### Lab 05 – Disk Space & Filesystem Troubleshooting
- Disk utilization analysis.
- Filesystem investigation.
- Directory-level disk usage.
- Large file identification.
- Disk space recovery.

### Lab 06 – Linux Process Management
- Process identification.
- Process monitoring.
- Process termination.
- Background and foreground processes.
- Process troubleshooting.

### Lab 07 – Linux Network Troubleshooting
- Network interface investigation.
- Connectivity testing.
- Port and listening service verification.
- DNS troubleshooting.
- Network connectivity diagnosis.

### Lab 08 – SSH & Remote Connectivity Troubleshooting
- SSH service management.
- SSH connectivity investigation.
- Authentication troubleshooting.
- SSH configuration validation.
- Remote access verification.

### Lab 09 – Linux Log Analysis & Incident Investigation
- System log investigation.
- Application log analysis.
- journalctl troubleshooting.
- Error identification using grep.
- Root cause investigation.

### Lab 10 – Bash Scripting & Automation
- Bash scripting fundamentals.
- Shell variables and conditions.
- Loops and functions.
- Command automation.
- Basic system administration automation.

### Lab 11 – Docker Container Troubleshooting
- Docker container management.
- Container status investigation.
- Container log analysis.
- Port mapping verification.
- Container restart and recovery.

### Lab 12 – End-to-End DevOps Incident Management
- Production-style incident simulation.
- Service availability investigation.
- System and application troubleshooting.
- Root cause analysis.
- Incident resolution.
- Service recovery verification.
- Technical incident documentation.

## Troubleshooting Methodology

Each lab follows a structured incident management approach:

1. **Incident Identification** – Identify the issue or service failure.
2. **Investigation** – Collect system information and inspect logs.
3. **Root Cause Analysis** – Determine the underlying cause.
4. **Resolution** – Apply the appropriate corrective action.
5. **Verification** – Confirm that the service or system is functioning correctly.
6. **Documentation** – Record commands, findings, screenshots, and resolution steps.

## Essential Linux Troubleshooting Commands

```bash
# Check system uptime
uptime

# Check memory utilization
free -h

# Check disk utilization
df -h

# Check running processes
ps aux

# Monitor system resources
top

# Check service status
systemctl status nginx

# View service logs
journalctl -u nginx

# Validate Nginx configuration
nginx -t

# Check HTTP response
curl -I http://localhost/

# Check listening ports
ss -tulnp

# Check Docker containers
docker ps -a

# View Docker container logs
docker logs <container_name>
```

## Project Learning Outcomes

- Practical Linux server administration.
- Production-oriented incident troubleshooting.
- Root cause analysis and problem resolution.
- Nginx deployment and configuration.
- Linux service management and recovery.
- System resource monitoring.
- Network and SSH troubleshooting.
- Docker container management.
- Bash scripting and automation.
- Log analysis and incident documentation.

## Evidence & Documentation

The repository contains practical implementation evidence, including:

- Step-by-step lab documentation.
- Linux commands and execution outputs.
- Configuration files.
- Implementation screenshots.
- Troubleshooting findings.
- Root cause analysis.
- Resolution and verification evidence.

---

**Linux Administration | DevOps Engineering | Incident Management | Troubleshooting | Automation**
