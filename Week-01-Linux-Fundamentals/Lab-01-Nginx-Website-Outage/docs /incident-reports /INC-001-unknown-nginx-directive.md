
# Incident Report INC-001 – Unknown Nginx Directive

## 1. Incident Information

| Field | Details |
|---|---|
| Incident ID | INC-001 |
| Incident Title | Nginx Service Startup Failure |
| Severity | High |
| Environment | AWS EC2 Lab |
| Operating System | Ubuntu 26.04.1 LTS |
| Affected Service | Nginx |
| Affected Port | TCP 80 |
| Status | Resolved |
| Root Cause Category | Invalid Nginx Configuration |

## 2. Incident Summary

An unsupported directive was intentionally introduced into the Nginx server configuration during a controlled incident simulation.

When Nginx attempted to start using the faulty configuration, configuration validation failed and the service could not start.

The issue was investigated using Nginx configuration validation, systemd service status, and journal logs.

The invalid directive was removed, the configuration was validated, and the Nginx service was successfully started.

## 3. Symptoms Observed

- Nginx service entered a failed state.
- Nginx configuration validation failed.
- HTTP website availability was interrupted during the service outage.
- systemd logs reported an unknown directive.

## 4. Faulty Configuration

The following invalid directive was introduced into the server configuration:

```nginx
# Incident INC-001: Faulty configuration deployment
invalid_nginx_directive on;
```

## 5. Error Message

Nginx configuration validation reported:

```text
unknown directive "invalid_nginx_directive"
```

The error identified the unsupported directive and the affected configuration file.

## 6. Investigation

### Step 1: Check Service Status

```bash
systemctl is-active nginx
systemctl status nginx --no-pager
```

**Finding:** Nginx was in a failed state.

### Step 2: Validate Configuration

```bash
nginx -t
```

**Finding:** Configuration validation failed because of the unknown directive.

### Step 3: Inspect systemd Logs

```bash
journalctl -u nginx -n 30 --no-pager
```

**Finding:** The journal showed that the Nginx start attempt failed due to the invalid configuration.

### Step 4: Inspect Configuration

```bash
grep -n 'invalid
