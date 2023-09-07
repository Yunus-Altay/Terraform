#!/bin/bash
dnf update -y
dnf install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
dnf -y install terraform