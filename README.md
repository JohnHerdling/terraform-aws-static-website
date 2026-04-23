# Terraform AWS Static Website with CloudFront

**Project Overview**

This project demonstrates how to provision a simple static website infrastructure on AWS using Terraform.

It was developed as part of a **university project** to showcase the practical use of Infrastructure as Code (IaC) and cloud services.

---

**Architecture**

User → CloudFront → S3 Bucket

- S3 Bucket: Stores static files
- CloudFront: CDN delivery
- OAC: Secure access

---

**Technologies**

- Terraform
- AWS (S3, CloudFront)

---

**Usage**

```bash
terraform init
terraform apply
