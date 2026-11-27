
#!/bin/bash

# DevOps Incident Response Lab
# Nginx Health Check Script

echo "========================================"
echo " DEVOPS INCIDENT RESPONSE LAB"
echo " NGINX HEALTH CHECK"
echo "========================================"

echo
echo "[1] Nginx Version"
nginx -v 2>&1

echo
echo "[2] Configuration Validation"
if sudo nginx -t; then
    echo "RESULT: Configuration is valid"
else
    echo "RESULT: Configuration validation FAILED"
fi

echo
echo "[3] Nginx Service Status"
if systemctl is-active --quiet nginx; then
    echo "RESULT: Nginx is ACTIVE"
else
    echo "RESULT: Nginx is NOT ACTIVE"
fi

echo
echo "[4] Nginx Boot Configuration"
systemctl is-enabled nginx 2>/dev/null || true

echo
echo "[5] Port 80 Listening Status"
if sudo ss -lntp | grep -q ':80 '; then
    echo "RESULT: Port 80 is listening"
else
    echo "RESULT: Port 80 is NOT listening"
fi

echo
echo "[6] Local HTTP Response"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 http://localhost/)

echo "HTTP Status: ${HTTP_STATUS:-No response}"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "RESULT: Website is responding successfully"
else
    echo "RESULT: Website health check FAILED"
fi

echo
echo "========================================"
echo " HEALTH CHECK COMPLETED"
echo "========================================"
