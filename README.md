# AKS Cluster CI/CD (Terraform + GitHub Actions)

Provision a complete AKS foundation on Azure using **Terraform** with **CI/CD via GitHub Actions**.

This repository is intentionally split into two stages:

1. **Bootstrap (one-time)** – creates the Azure resources Terraform needs for remote state and secrets.
2. **Platform (repeatable)** – creates the AKS platform (network, cluster, ACR) and stores the kubeconfig in Key Vault.

---

# What this project creates

## 1. Bootstrap (`terraform/bootstrap`)

Creates the base infrastructure required by Terraform and the CI/CD pipeline.

Resources created:

* Resource Group
* Azure Key Vault
* Storage Account (Terraform state)
* Storage Container (Terraform state container)

---

## 2. Platform (`terraform/`)

Creates the Kubernetes platform infrastructure.

Resources created:

* Virtual Network (VNet)
* Subnet
* AKS Cluster
* Azure Container Registry (ACR)
* Permission for AKS kubelet to access ACR
* Key Vault secret: **aks-kube-config** (AKS kubeconfig)

---

# Prerequisites

## Local tools

Install the following tools:

* Azure CLI (`az`)
* Terraform
* Git
* *(optional)* GitHub CLI (`gh`) for automating secrets and environments

---

## Azure permissions

Your Azure account must have permissions to create:

* Resource Groups
* Storage Accounts
* Key Vault
* AKS
* Azure Container Registry
* Virtual Networks

Login to Azure:

```bash
az login
```

---

# Step-by-Step Setup

## Step 1 — Bootstrap Infrastructure

The bootstrap stage creates the **Terraform backend and Key Vault**.

This step only needs to be executed **once**.

### Create bootstrap variables

Create the file:

```
terraform/bootstrap/terraform.tfvars
```

Example configuration:

```hcl
# Resource Group
resource_group_name = "rsg-terraform-bootstrap"
location            = "westeurope"

# Key Vault
vault_name = "kv-terraform-bootstrap"
tenant_id  = "<YOUR_TENANT_ID>"
user_id    = "<YOUR_USER_OBJECT_ID>"

# Storage Account
storage_account_name     = "stterraformstatexxxx"
account_replication_type = "LRS"
public_access            = "false"

# Storage Container
storage_container_name = "tfstate"
container_access_type  = "private"

# Tags
tags = {
  project = "aks-cluster-ci-cd"
  env     = "bootstrap"
}
```

Notes:

* `tenant_id` and `user_id` are required by the bootstrap Key Vault module.
* Storage account names must be **globally unique**.

### Run Terraform bootstrap

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

This creates the backend infrastructure.

---

# Step 2 — Configure the Terraform Backend

Edit the backend configuration file:

```
terraform/backend.hcl
```

Example configuration:

```hcl
resource_group_name  = "..."
storage_account_name = "..."
container_name       = "..."
key                  = "terraform.tfstate"
```

---

# Step 3 — Configure Platform Variables

Edit:

```
terraform/variables.tfvars
```

Ensure the following values match your environment:

* `resource_group_name`
* `location`
* `key_vault_name`
* `vnet_name`
* `subnet_name`
* `cluster_name`
* `dns_prefix`
* node configuration
* `acr_name`
* `sku`

---

# Step 4 — Deploy the Platform (Manual)

```bash
cd terraform

terraform init -backend-config=backend.hcl
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars
```

After deployment, the AKS kubeconfig is stored in Key Vault.

Secret name:

```
aks-kube-config
```

---

# Step 5 — Deploy the Platform using CI/CD Pipeline

Workflow file:

```
.github/workflows/terraform.yml
```

## Branch behavior

### development branch

Runs:

```
terraform fmt
terraform validate
terraform plan
```

### main branch

Runs:

```
terraform fmt
terraform validate
terraform plan
terraform apply
```

`terraform apply` runs **only on push**, not on pull requests.

---
# Prepate Github Actions Access 
Script:

```
scripts/azure/
```
This Script creates add's a Service Principal that we need to Github to have access on Azure

# Setup GitHub Environments

Script:

```
scripts/github/setup-environments.sh
```
Script Workflow:
 - resets SP and saves all SP infos required into variables
 - creates the GitHub environments **development** and **production**
 - configures Secrets and bind them into the enviroments.

## development

```
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_TENANT_ID
ARM_SUBSCRIPTION_ID
```

## production

```
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_TENANT_ID
ARM_SUBSCRIPTION_ID
```

Recommended: protect the **production environment** with required reviewers.

---

# Trigger the Pipeline

Script:

```
scripts/github/trigger-pipeline.sh
```

This script:

* writes a log file
* triggers the GitHub Actions pipeline

---

# Future Improvements

Planned improvements for this project:

* Add **TFLint** for Terraform linting
* Add **tfsec** for Terraform security scanning
* Use **GitHub → Azure OIDC authentication** instead of client secrets
* Separate Terraform state per environment (dev / prod)
* Add **multi-cloud support**:

  * **AWS EKS**
  * **Google GKE**
* Refactor modules to support **scalable multi-cloud deployments**


---

# License

MIT License

Copyright (c) 2026 mr-robowayne 
