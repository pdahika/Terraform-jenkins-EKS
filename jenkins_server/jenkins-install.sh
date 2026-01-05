#!/bin/bash
set -x

exec > /var/log/jenkins-install.log 2>&1

echo "=== Jenkins installation started ==="
date

# Wait for yum lock (VERY IMPORTANT on first boot)
while fuser /var/run/yum.pid >/dev/null 2>&1; do
  echo "Waiting for yum lock..."
  sleep 5
done

yum update -y

# Install Java 17 (CORRECT for Amazon Linux 2)
yum install -y java-17-amazon-corretto-devel

java -version

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum install -y jenkins

systemctl daemon-reexec
systemctl enable jenkins
systemctl start jenkins

sleep 15
systemctl status jenkins --no-pager

echo "=== Jenkins installation completed ==="
