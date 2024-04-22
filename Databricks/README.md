# Data Ops - Data Product

## Details
Terraform Configuration for Databricks services
This Directory contains Terraform code to deploy and manage resources for Databricks services, directories, permissions, service principals, and instance pools on Azure.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Configuration Overview](#configuration-overview)
- [Folder Structure](#folder-structure)
- [Usage](#usage)

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions
- Service Principal with Contributor or Owner role assigned
- Databricks terraform provider with version 1.28.0

## Configuration Overview

The Terraform configuration in this repository accomplishes the following tasks:

- Creates Databricks workspace
- Manages groups and assigns members to groups
- Creates directories and sets permissions
- Creates and manages service principals
- Configures access control rules for service principals and groups
- Creates and manages Databricks instance pools for job clusters

## Folder Structure

.
├── main.tf                # Main Terraform configuration file
├── variables.tf           # Input variables for the configuration
├── outputs.tf             # Output variables for the configuration
├── locals.tf              # contains locals used in the configuration
├── Subid.csv              # Contians subscription details
└── README.md              # This README file

## Usage
To use this Terraform configuration:

Modify variables.tf to match your environment and requirements in the respective workflow.

Initialize Terraform:
terraform init

Review the execution plan:
terraform plan

Apply the configuration:
terraform apply
