#!/bin/bash
set -e
# simple app: nginx serving a static page
yum update -y
amazon-linux-extras enable nginx1
yum install -y nginx
cat > /usr/share/nginx/html/index.html <<'HTML'
<html>
<head><title>${name} App</title></head>
<body>
<h1>Hello from ${name} - deployed by Terraform</h1>
</body>
</html>
HTML
systemctl enable nginx
systemctl start nginx