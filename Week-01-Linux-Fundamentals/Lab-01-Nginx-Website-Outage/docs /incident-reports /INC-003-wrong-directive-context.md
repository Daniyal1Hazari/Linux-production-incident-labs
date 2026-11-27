# Incident Report INC-003 – Nginx Directive in Incorrect Context

## 1. Incident Information

| Field | Details |
|---|---|
| Incident ID | INC-003 |
| Incident Title | Directive in Incorrect Configuration Context |
| Severity | Medium |
| Environment | AWS EC2 Lab |
| Operating System | Ubuntu 26.04.1 LTS |
| Affected Service | Nginx |
| Affected Component | Server Block Configuration |
| Status | Resolved |
| Root Cause Category | Configuration Context Error |

## 2. Incident Summary

During a controlled incident simulation, the `worker_processes` directive was intentionally placed inside an Nginx server block.

This directive belongs in the main configuration context and is not permitted inside a server block.

Nginx configuration validation detected the misplaced directive.

The existing Nginx service continued serving requests using its previously loaded configuration because the faulty configuration had not been successfully applied.

The misplaced directive was removed, configuration validation passed, and Nginx was successfully reloaded.

## 3. Symptoms Observed

- Nginx configuration validation failed.
- The error reported that `worker_processes` was not allowed in the current context.
- The running Nginx service remained active.
- The website continued returning HTTP 200 using the previously loaded configuration.

## 4. Faulty Configuration

The following directive was intentionally introduced into the server block:

```nginx id="9m5mrc"
# Incident INC-003: Directive in incorrect configuration context
worker_processes 2;
```

The `worker_processes` directive belongs in the main Nginx configuration context, not inside an individual server block.

## 5. Error Message

Nginx configuration validation reported:

```text id="fznzgt"
"worker_processes" directive is not allowed here
```

The error identified the affected configuration file and line.

## 6. Investigation

### Step 1: Check Nginx Service Status

```bash id="8pfj4f"
systemctl is-active nginx
systemctl status nginx --no-pager
```

**Finding:** Nginx remained active.

### Step 2: Validate Nginx Configuration

```bash id="xq5kfa"
nginx -t
```

**Finding:** Configuration validation failed because the directive was placed in an invalid context.

### Step 3: Inspect the Configuration

```bash id="e3l6sp"
grep -n 'worker_processes' \
/etc/nginx/sites-available/devops-incident-lab
```

**Finding:** The misplaced directive was identified inside the server block.

### Step 4: Verify Website Availability

```bash id="s4e6q2"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/
```

**Finding:** The website continued returning HTTP 200.

## 7. Root Cause Analysis

**Primary Root Cause:**

The `worker_processes` directive was placed inside the wrong Nginx configuration context.

**Why did configuration validation fail?**

Nginx directives are restricted to specific configuration contexts. The `worker_processes` directive is permitted in the main context, not within a server block.

**Why did the website remain available?**

The existing Nginx workers continued using the previously loaded valid configuration. The invalid configuration had not been successfully reloaded.

## 8. Remediation

### Step 1: Remove the Misplaced Directive

```bash id="l1b9qi"
sed -i '/^[[:space:]]*worker_processes 2;[[:space:]]*$/d' \
/etc/nginx/sites-available/devops-incident-lab
```

### Step 2: Verify Removal

```bash id="ym7zsb"
grep -n 'worker_processes' \
/etc/nginx/sites-available/devops-incident-lab || \
echo "Misplaced directive removed"
```

### Step 3: Validate Configuration

```bash id="13ix6z"
nginx -t
```

**Result:** Configuration validation successful.

### Step 4: Reload Nginx

Because the service remained active, reload was used:

```bash id="l5qfca"
systemctl reload nginx
```

## 9. Recovery Verification

Run:

```bash id="1g6dph"
echo "========== SERVICE STATUS =========="
systemctl is-active nginx

echo
echo "========== CONFIGURATION VALIDATION =========="
nginx -t

echo
echo "========== PORT VERIFICATION =========="
ss -tulnp | grep ':80'

echo
echo "========== HTTP RESPONSE =========="
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/

echo
echo "========== WEBSITE CONTENT =========="
curl -s http://localhost/ | grep 'Welcome to My DevOps Project'
```

**Verified Results:**

| Check | Result |
|---|---|
| Configuration validation | Successful |
| Nginx service | Active |
| Port 80 | Listening |
| HTTP response | 200 |
| Website content | Verified |
| Configuration reload | Successful |

## 10. Resolution

The misplaced `worker_processes` directive was removed from the server block.

Nginx configuration validation passed, and the corrected configuration was successfully reloaded.

The website remained available throughout the simulation.

**Final Status: RESOLVED**

## 11. Preventive Actions

- Understand Nginx configuration contexts.
- Review directive placement before deployment.
- Validate configuration using `nginx -t`.
- Maintain a known-good configuration backup.
- Use configuration review before production changes.
- Monitor service health and application availability.
- Document configuration failures and their root causes.

## 12. Evidence

Related evidence files:

- `evidence/INC-003-detection.txt`
- `evidence/INC-003-recovery.txt`

Evidence includes configuration validation failure, service status, HTTP response, and successful recovery.

## 13. Key Learning

This incident demonstrated the importance of understanding Nginx configuration contexts.

A directive can be valid in one configuration context but invalid in another.

Configuration validation helps detect such errors before a faulty configuration is applied to the running service.
