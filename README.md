# Terraform + Ansible with static inventory

Creates 5 virtual machines and runs Ansible roles for configuration using a static inventory.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)


## Overview

Creates 5 virtual machines, a VPC, security groups, and associates a floating IP. Sets up 1 virtual machine that acts as an Ansible controller, from which a playbook is executed to configure the remaining 4. Three virtual machines serve as web servers, while the remaining virtual machine acts as an Application Load Balancer (ALB) balancing traffic between the web servers.

## Prerequisites

You need to create a secrets.tfvars file where you specify the variables `secret` and `managed_password_hash`. Create a password using `mkpasswd` and set it as the value for the `managed_password_hash` variable; it will be used as the password for the virtual machines. Encrypt the password using `ansible-vault` and paste the encryption key as the value for the `secret` variable. Insert the ansible-vault cipher into the value of `ansible_password` in the inventory/group_vars/all.yml file.

## Usage
- terraform init
- terraform apply -var-file="secret.tfvars"
