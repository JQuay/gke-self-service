# 🚀 GKE Self-Service Cluster Provisioning

A GitOps-based self-service platform that enables developers to request and provision GKE (Google Kubernetes Engine) clusters through GitHub Issues, with automated approval workflows and Terraform infrastructure-as-code.

---

## 🎯 Overview

This project provides a self-service platform for GKE cluster provisioning using:

- **GitHub Issues** — User-friendly request forms
- **GitHub Actions** — Automated workflows
- **Terraform** — Infrastructure as Code
- **GCS Backend** — Remote state management


### Benefits

| Benefit | Description |
|---------|-------------|
| 🚀 **Self-Service** | Developers can request clusters without direct platform team intervention |
| 🔒 **Approval Gate** | Platform team reviews and approves requests before provisioning |
| 📝 **Audit Trail** | All requests tracked via GitHub Issues and PRs |
| 🔄 **GitOps** | Infrastructure changes tracked in Git with full history |
| ⚡ **Automation** | Minimal manual steps after approval |
| 💰 **Cost Control** | Pre-defined options prevent over-provisioning |

---

## ✨ Features

- ✅ Self-service cluster requests via GitHub Issue forms
- ✅ Platform team approval workflow
- ✅ Automated Terraform plan on Pull Request
- ✅ Automated Terraform apply after merge
- ✅ Node pool autoscaling support
- ✅ Spot VM support for cost optimization
- ✅ Change ticket tracking for compliance
- ✅ Automatic GCS state bucket creation
- ✅ Input validation and duplicate cluster checks
- ✅ Success/failure notifications on issues

---

## 🏗️ Architecture
┌─────────────────────────────────────────────────────────────────────────────┐
│ │
│ GitHub Repository │
│ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ │
│ │ Issue Template │ │ Workflows │ │ Terraform │ │
│ │ (Request Form) │ │ (GitHub Actions)│ │ (Modules) │ │
│ └────────┬────────┘ └────────┬────────┘ └────────┬────────┘ │
│ │ │ │ │
└───────────┼──────────────────────┼──────────────────────┼───────────────────┘
│ │ │
▼ ▼ ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Developer │ │ Platform Team │ │ Google Cloud │
│ (Requester) │ │ (Approver) │ │ (GKE) │
└─────────────────┘ └─────────────────┘ └─────────────────







---

## 📋 Prerequisites

### GitHub

- [ ] Repository with GitHub Actions enabled
- [ ] Personal Access Token (PAT) with `repo` scope
- [ ] Labels created: `cluster-create`, `pending-approval`, `approved`

### Google Cloud

- [ ] GCP Project with billing enabled
- [ ] APIs enabled:
  - Kubernetes Engine API
  - Compute Engine API
  - Cloud Storage API
- [ ] Service Account with roles:
  - `roles/container.admin`
  - `roles/compute.admin`
  - `roles/storage.admin`
  - `roles/iam.serviceAccountUser`
- [ ] Service Account key (JSON)

---

## 🔄 Workflow Files

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `self-service-create.yml` | `approved` label added | Generates Terraform files and creates PR |
| `plan.yaml` | Pull Request opened/updated | Runs `terraform plan` and comments on PR |
| `apply.yaml` | PR merged to `main` | Runs `terraform apply` to create cluster |

                Issue Created
                     │
                     ▼
          ┌─────────────────────┐
          │   pending-approval  │
          │   cluster-create    │
          └──────────┬──────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │  + approved label   │◀─── Platform Team
          └──────────┬──────────┘
                     │
                     ▼
     ┌───────────────────────────────┐
     │  self-service-create.yaml     │
     │  ───────────────────────────  │
     │  • Parse issue                │
     │  • Validate inputs            │
     │  • Create bucket              │
     │  • Generate TF files          │
     │  • Create PR                  │
     └───────────────┬───────────────┘
                     │
                     ▼
     ┌───────────────────────────────┐
     │  plan.yaml                    │
     │  ───────────────────────────  │
     │  • terraform init             │
     │  • terraform plan             │
     │  • Comment on PR              │
     └───────────────┬───────────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │   Review & Merge    │◀─── Platform Team
          └──────────┬──────────┘
                     │
                     ▼
     ┌───────────────────────────────┐
     │  apply.yaml                   │
     │  ───────────────────────────  │
     │  • terraform init             │
     │  • terraform apply            │
     │  • Create GKE cluster         │
     └───────────────┬───────────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │   ✅ Cluster Ready  │
          └─────────────────────┘