# Implementation Guide – AWS EC2 Nginx Incident Response Lab

## 1. Introduction

This guide explains how to deploy the DevOps Incident Response Lab using AWS EC2, Ubuntu Linux, and Nginx.

It covers infrastructure provisioning, Nginx installation, static website deployment, server configuration, and baseline verification.

The instructions are intended for a dedicated lab environment.

## 2. Prerequisites

Before starting, ensure you have:

- An AWS account.
- Access to the AWS EC2 console.
- Basic Linux command-line knowledge.
- An SSH client or EC2 Instance Connect access.
- Basic understanding of AWS Security Groups.

## 3. Provision AWS EC2

### Step 1: Launch an EC2 Instance

1. Sign in to the AWS Management Console.
2. Open the EC2 service.
3. Select Launch Instance.
4. Enter an instance name:

   `devops-nginx-incident-lab-day1`

5. Select Ubuntu Server 26.04 LTS.
6. Choose instance type `t3.micro`.
7. Configure the required key pair or EC2 Instance Connect access.
8. Configure the Security Group.

### Step 2: Configure Security Group

Configure the following inbound rules:

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | 22 | My IP |
| HTTP | TCP | 80 | 0.0.0.0/0 |

For production environments, follow your organization's network security policies and restrict access as much as possible.

### Step 3: Launch and Connect

Launch the instance and wait until both EC2 status checks pass.

Connect using EC2 Instance Connect or SSH.

## 4. Verify the Operating System

Run:

```bash
whoami
hostname
cat /etc/os-release
nproc
free -h
df -h /
```

Verify:
- Correct user access.
- Ubuntu operating system.
- CPU and memory availability.
- Available disk space.

## 5. Update the System

Update the package repositories:

```bash
apt update -y
```

## 6. Install Nginx

Install Nginx:

```bash
apt install nginx -y
```

Verify the installed version:

```bash
nginx -v
```

Enable Nginx at system startup:

```bash
systemctl enable nginx
```

Start the service:

```bash
systemctl start nginx
```

Check the service:

```bash
systemctl status nginx
```

## 7. Create the Website Directory

Create a dedicated directory for the static website:

```bash
mkdir -p /var/www/devops-incident-lab
```

Set ownership and permissions:

```bash
chown -R www-data:www-data /var/www/devops-incident-lab
chmod 755 /var/www/devops-incident-lab
```

## 8. Deploy the HTML Website

Create the landing page:

```bash
nano /var/www/devops-incident-lab/index.html
```

Add the following HTML:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Incident Lab</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f5f9;
            font-family: Arial, sans-serif;
            color: #1e293b;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            max-width: 650px;
            margin: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        h1 {
            color: #2563eb;
        }

        .status {
            color: #15803d;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to My DevOps Project!</h1>

        <p>
            This website is successfully hosted on an AWS EC2 instance
            using Nginx Web Server.
        </p>

        <p>
            Learning, Building and Troubleshooting Real-World
            DevOps Infrastructure.
        </p>

        <p class="status">● Website Operational</p>

        <footer>
            AWS EC2 | Ubuntu | Nginx | DevOps Incident Response Lab
        </footer>
    </div>
</body>
</html>
```

Set file permissions:

```bash
chown www-data:www-data /var/www/devops-incident-lab/index.html
chmod 644 /var/www/devops-incident-lab/index.html
```

## 9. Configure the Nginx Server Block

Create the configuration file:

```bash
nano /etc/nginx/sites-available/devops-incident-lab
```

Add:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name _;

    root /var/www/devops-incident-lab;
    index index.html;

    access_log /var/log/nginx/devops-incident-access.log;
    error_log /var/log/nginx/devops-incident-error.log;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

## 10. Enable the Website

Create the symbolic link:

```bash
ln -s /etc/nginx/sites-available/devops-incident-lab \
/etc/nginx/sites-enabled/devops-incident-lab
```

Remove the default site if it is enabled:

```bash
rm -f /etc/nginx/sites-enabled/default
```

## 11. Validate Nginx Configuration

Before applying the configuration, run:

```bash
nginx -t
```

Expected successful output:

```text
syntax is ok
test is successful
```

Reload Nginx:

```bash
systemctl reload nginx
```

Verify:

```bash
systemctl is-active nginx
systemctl is-enabled nginx
```

## 12. Verify Website Availability

Check the local HTTP response:

```bash
curl -I http://localhost/
```

Expected response:

```text
HTTP/1.1 200 OK
```

Check the website content:

```bash
curl -s http://localhost/ | grep 'Welcome to My DevOps Project'
```

Open the following URL in a browser, replacing the placeholder with the EC2 public IPv4 address:

`http://<EC2_PUBLIC_IP>/`

Confirm that the custom website loads successfully.

## 13. Configure a Known-Good Backup

Before conducting incident simulations, preserve the working Nginx server block.

Example:

```bash
mkdir -p /home/ubuntu/devops-incident-lab/backup

cp -a /etc/nginx/sites-available/devops-incident-lab \
/home/ubuntu/devops-incident-lab/backup/devops-incident-lab.working
```

Verify the backup:

```bash
ls -lh /home/ubuntu/devops-incident-lab/backup/
```

## 14. Capture Baseline Evidence

Record the initial healthy state before performing incident simulations.

Useful commands:

```bash
date -Is
hostnamectl
nginx -v
systemctl status nginx --no-pager
nginx -t
ss -tulnp | grep ':80'
curl -I http://localhost/
```

Store the output in the project evidence directory.

## 15. Completion Checklist

- [ ] AWS EC2 instance launched.
- [ ] Security Group configured.
- [ ] Ubuntu access verified.
- [ ] Nginx installed.
- [ ] Nginx enabled and active.
- [ ] Custom website deployed.
- [ ] Nginx server block configured.
- [ ] Configuration validation successful.
- [ ] Local HTTP response returns 200.
- [ ] External browser access verified.
- [ ] Known-good configuration backup created.
- [ ] Baseline evidence collected.

## 16. Conclusion

The initial infrastructure deployment is complete when the Nginx service is healthy, the custom website is accessible, the configuration passes validation, and the known-good configuration has been backed up.

The environment is then ready for controlled incident response exercises.
