
# Incident Report INC-002 – Invalid Nginx Root Directive

## 1. Incident Information

| Field | Details |
|---|---|
| Incident ID | INC-002 |
| Incident Title | Invalid Root Directive Arguments |
| Severity | Medium |
| Environment | AWS EC2 Lab |
| Operating System | Ubuntu 26.04.1 LTS |
| Affected Service | Nginx |
| Affected Component | Server Block Configuration |
| Status | Resolved |
| Root Cause Category | Configuration Syntax Error |

## 2. Incident Summary

During a controlled incident simulation, an additional argument was intentionally introduced into the Nginx `root` directive.

The configuration validation process detected the syntax error.

The already-running Nginx service continued serving requests using its previously loaded configuration because the faulty configuration had not been successfully applied.

The invalid directive was removed, configuration validation passed, and Nginx was successfully reloaded.

## 3. Symptoms Observed

- Nginx configuration validation failed.
- The error identified an invalid number of arguments in the root directive.
- The running Nginx service remained active.
- The website continued returning HTTP 200 using the previously loaded configuration.

## 4. Faulty Configuration

The following incorrect directive was introduced:

```nginx
# Incident INC-002: Incorrect root directive
root /var/www/devops-incident-lab /wrong-path;
```

The Nginx `root` directive expects a single root path argument.

## 5. Error Message

Configuration validation reported:

```text
invalid number of arguments in "root" directive
```

The error identified the affected configuration file and line.

## 6. Investigation

### Step 1: Check Nginx Service

```bash
systemctl is-active nginx
systemctl status nginx --no-pager
```

**Finding:** Nginx remained active.

### Step 2: Validate Configuration

```bash
nginx -t
```

**Finding:** Configuration validation failed because the root directive contained an extra argument.

### Step 3: Inspect Faulty Configuration

```bash
grep -n 'wrong-path' \
/etc/nginx/sites-available/devops-incident-lab
```

**Finding:** The incorrect root directive was identified.

### Step 4: Verify Website Availability

```bash
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/
```

**Finding:** The website continued returning HTTP 200.

## 7. Root Cause Analysis

**Primary Root Cause:**

An additional argument was introduced into the Nginx `root` directive.

**Why did configuration validation fail?**

The directive syntax did not match the expected Nginx configuration format.

**Why did the website continue working?**

The running Nginx workers continued using the previously loaded valid configuration. The faulty configuration had not been successfully reloaded.

## 8. Remediation

### Step 1: Remove the Faulty Directive

```bash
sed -i '\|root /var/www/devops-incident-lab /wrong-path;|d' \
/etc/nginx/sites-available/devops-incident-lab
```

### Step 2: Verify the Incorrect Directive Was Removed

```bash
grep -n 'wrong-path' \
/etc/nginx/sites-available/devops-incident-lab || \
echo "Faulty root directive removed"
```

### Step 3: Validate Configuration

```bash
nginx -t
```

**Result:** Configuration validation successful.

### Step 4: Reload Nginx

Because the service was still running, a reload was used to apply the corrected configuration:

```bash
systemctl reload nginx
```

## 9. Recovery Verification

Run the following checks:

```bash
echo "========== SERVICE STATUS =========="
systemctl is-active nginx

echo
echo "========== CONFIGURATION VALIDATION =========="
nginx -t

echo
echo "========== HTTP RESPONSE =========="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/

echo
echo "========== WEBSITE CONTENT =========="
curl -
