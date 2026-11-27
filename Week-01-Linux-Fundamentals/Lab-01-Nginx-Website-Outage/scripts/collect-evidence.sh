
#!/bin/bash

# DevOps Incident Response Lab
# Nginx Evidence Collection Script

set -u

PROJECT_DIR="/home/ubuntu/devops-incident-lab"
EVIDENCE_DIR="$PROJECT_DIR/evidence"

mkdir -p "$EVIDENCE_DIR"

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
OUTPUT_FILE="$EVIDENCE_DIR/health-evidence-$TIMESTAMP.txt"

{
    echo "=========================================="
    echo " DEVOPS INCIDENT RESPONSE LAB"
    echo " NGINX EVIDENCE COLLECTION"
    echo "=========================================="

    echo
    echo "Collection Date:"
    date

    echo
    echo "Hostname:"
    hostname

    echo
    echo "Operating System:"
    grep PRETTY_NAME /etc/os-release

    echo
    echo "Nginx Version:"
    nginx -v 2>&1

    echo
    echo "Nginx Configuration Test:"
    sudo nginx -t 2>&1

    echo
    echo "Nginx Service Status:"
    systemctl status nginx --no-pager 2>&1

    echo
    echo "Nginx Enabled Status:"
    systemctl is-enabled nginx 2>&1

    echo
    echo "Port 80 Listening Status:"
    sudo ss -lntp | grep ':80 ' || echo "Port 80 is not listening"

    echo
    echo "Local HTTP Response:"
    curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" \
        --max-time 5 http://localhost/ || echo "HTTP request failed"

    echo
    echo "Disk Usage:"
    df -h /

    echo
    echo "Recent Nginx Error Logs:"
    sudo tail -n 30 /var/log/nginx/devops-incident-error.log 2>&1

    echo
    echo "=========================================="
    echo " EVIDENCE COLLECTION COMPLETED"
    echo "=========================================="

} > "$OUTPUT_FILE"

echo "Evidence saved to: $OUTPUT_FILE"
