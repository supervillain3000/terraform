# Terraform + Ansible with static inventory

Creates any desired number of web servers and runs Ansible roles for configuration using a dynamic inventory.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)


## Overview

Creates the desired number of web servers, an Ansible controller node, an Application Load Balancer (ALB), Virtual Private Cloud (VPC), security groups, and associates a floating IP. Sets up one virtual machine as an Ansible controller, from which a playbook is executed to configure the remaining servers.

## Prerequisites

You need to create a secrets.tfvars file where you specify the variables `secret` and `managed_password_hash`. Create a password using `mkpasswd` and set it as the value for the `managed_password_hash` variable; it will be used as the password for the virtual machines. Encrypt the password using `ansible-vault` and paste the encryption key as the value for the `secret` variable. Insert the ansible-vault cipher into the value of `ansible_password` in the inventory/group_vars/all.yml file.

## Usage
- terraform init
- terraform apply -var-file="secret.tfvars"
