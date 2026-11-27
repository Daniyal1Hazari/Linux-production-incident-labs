
# Nginx Troubleshooting and Recovery Guide

## 1. Introduction

This guide provides practical troubleshooting procedures for investigating Nginx web server issues on Ubuntu Linux.

It covers service investigation, configuration validation, log analysis, network checks, root cause identification, and recovery verification.

These procedures were practiced in the AWS EC2 DevOps Incident Response Lab.

## 2. Troubleshooting Methodology

Follow a structured troubleshooting approach:

1. Detect the issue.
2. Confirm the impact.
3. Check service status.
4. Inspect configuration files.
5. Analyze system and application logs.
6. Identify the root cause.
7. Preserve the working configuration.
8. Apply the minimum required correction.
9. Validate the configuration.
10. Restore the service.
11. Verify application availability.
12. Document the incident.

## 3. Check Nginx Service Status

Check detailed service information:

```bash
systemctl status nginx --no-pager
```

Check whether Nginx is active:

```bash
systemctl is-active nginx
```

Check whether Nginx starts automatically during boot:

```bash
systemctl is-enabled nginx
```

Common service states:

| State | Meaning |
|---|---|
| active | Service is running |
| inactive | Service is stopped |
| failed | Service encountered a failure |
| enabled | Service is configured to start at boot |
| disabled | Service is not configured to start at boot |

## 4. Validate Nginx Configuration

Run:

```bash
nginx -t
```

This command checks the Nginx configuration syntax and verifies that referenced configuration files can be loaded.

Do not reload or restart Nginx with an invalid configuration.

Common configuration errors include:

- Unknown directives.
- Incorrect directive arguments.
- Directives placed in the wrong configuration context.
- Missing semicolons.
- Missing configuration files.

## 5. Inspect Nginx Logs

### Nginx Error Log

```bash
tail -n 50 /var/log/nginx/devops-incident-error.log
```

Follow the error log in real time:

```bash
tail -f /var/log/nginx/devops-incident-error.log
```

### Nginx Access Log

```bash
tail -n 50 /var/log/nginx/devops-incident-access.log
```

The access log helps verify incoming requests and HTTP response codes.

### systemd Journal Logs

```bash
journalctl -u nginx -n 50 --no-pager
```

Inspect logs from the current boot:

```bash
journalctl -u nginx -b --no-pager
```

Follow logs in real time:

```bash
journalctl -u nginx -f
```

## 6. Check Network Port Availability

Check whether Nginx is listening on port 80:

```bash
ss -tulnp | grep ':80'
```

Check all listening TCP ports:

```bash
ss -tulnp
```

Expected: Nginx should listen on the configured HTTP port.

If port 80 is not listening, investigate the Nginx service and configuration.

## 7. Verify HTTP Connectivity

Check the local HTTP response:

```bash
curl -I http://localhost/
```

Check the website response body:

```bash
curl -s http://localhost/
```

Interpret common HTTP status codes:

| Status | Meaning |
|---|---|
| 200 | Request successful |
| 301 | Permanent redirect |
| 302 | Temporary redirect |
| 403 | Access forbidden |
| 404 | Resource not found |
| 500 | Internal server error |
| 502 | Bad gateway |
| 503 | Service unavailable |
| 504 | Gateway timeout |

A successful local response does not by itself prove that external access works. Verify the AWS Security Group and browser access separately.

## 8. Check File Permissions

Verify the website directory:

```bash
ls -ld /var/www/devops-incident-lab
```

Verify the HTML file:

```bash
ls -l /var/www/devops-incident-lab/index.html
```

Nginx must have permission to traverse the directory and read the website files.

Typical permissions:

- Directories: `755`
- HTML files: `644`

## 9. Check Disk and Memory Utilization

Disk utilization:

```bash
df -h
```

Memory utilization:

```bash
free -h
```

Check system load:

```bash
uptime
```

Resource exhaustion can affect service availability and should be investigated when relevant.

## 10. Recovery Procedures

### Case A: Nginx Configuration Error

1. Inspect the configuration file.
2. Identify the invalid directive or syntax.
3. Preserve the known-good configuration.
4. Correct the faulty configuration.
5. Validate with `nginx -t`.
6. Reload Nginx if it is running.

Example:

```bash
nginx -t
systemctl reload nginx
```

### Case B: Nginx Service Is Stopped

First validate the configuration:

```bash
nginx -t
```

If validation succeeds, start the service:

```bash
systemctl start nginx
```

Verify:

```bash
systemctl is-active nginx
```

### Case C: Nginx Service Has Failed

Inspect the service logs:

```bash
journalctl -u nginx -n 50 --no-pager
```

Validate the configuration:

```bash
nginx -t
```

After correcting the root cause and confirming the configuration is valid:

```bash
systemctl start nginx
```

### Case D: Restore a Known-Good Configuration

If configuration recovery requires restoring the saved server block, first preserve the current file, then restore the known-good copy.

Example:

```bash
cp -a /etc/nginx/sites-available/devops-incident-lab \
/etc/nginx/sites-available/devops-incident-lab.before-restore

cp -a /home/ubuntu/devops-incident-lab/backup/devops-incident-lab.working \
/etc/nginx/sites-available/devops-incident-lab
```

Validate before applying:

```bash
nginx -t
```

If Nginx is running:

```bash
systemctl reload nginx
```

If Nginx is stopped:

```bash
systemctl start nginx
```

## 11. Post-Recovery Verification

After recovery, execute:

```bash
echo "========== CONFIGURATION VALIDATION =========="
nginx -t

echo
echo "========== SERVICE STATUS =========="
systemctl is-active nginx
systemctl is-enabled nginx

echo
echo "========== PORT VERIFICATION =========="
ss -tulnp | grep ':80'

echo
echo "========== HTTP VERIFICATION =========="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/

echo
echo "========== WEBSITE CONTENT =========="
curl -s http://localhost/ | grep 'Welcome to My DevOps Project'
```

Expected results:

- Nginx configuration test successful.
- Service active.
- Service enabled.
- Port 80 listening.
- HTTP status 200.
- Expected website heading displayed.

## 12. Important Operational Practices

- Always validate configuration before applying changes.
- Keep a known-good configuration backup.
- Avoid unnecessary service restarts.
- Use reload when Nginx is running and a validated configuration change needs to be applied.
- Use start when Nginx is stopped.
- Review logs before making changes.
- Apply the smallest possible corrective change.
- Verify both service health and application availability.
- Maintain incident evidence and recovery documentation.
- Perform failure simulations only in isolated test environments.

## 13. Conclusion

A structured troubleshooting process reduces recovery risk and helps identify the actual cause of infrastructure issues.

This guide demonstrates practical Nginx and Linux operational procedures using an AWS EC2 lab environment.
