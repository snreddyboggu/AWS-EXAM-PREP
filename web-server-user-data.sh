#!/bin/bash

# Update the system packages
yum update -y

# Install Apache HTTP server
yum install -y httpd

# Start and enable the Apache service
systemctl start httpd
systemctl enable httpd

# Get the EC2 instance's availability zone using IMDSv2
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_AVAIL_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Check if the availability zone is retrieved
if [ -z "$EC2_AVAIL_ZONE" ]; then
  echo "Failed to retrieve availability zone"
  exit 1
fi

# Create an index.html file with a message
echo "<h1>Hello World from Rokkitt at $(hostname -f) in AZ $EC2_AVAIL_ZONE</h1>" > /var/www/html/index.html
