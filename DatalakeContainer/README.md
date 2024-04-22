# Terraform Configuration for Data Lake Container and Role Assignments

This Directory contains Terraform code to deploy and manage resources for a data lake container in Azure, along with role assignments for access control.

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
- Service Principal with Owner role assigned

## Configuration Overview

The Terraform configuration in this Directory accomplishes the following tasks:

- Creates a data lake container
- Retrieves object IDs for Azure AD groups and service principals
- Manages role assignments for the data lake container.

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