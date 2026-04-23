# \# Terraform AWS Static Website with CloudFront

# 

# \## Project Overview

# 

# This project demonstrates how to provision a simple static website infrastructure on AWS using Terraform.

# 

# It was developed as part of a \*\*university project\*\* to showcase the practical use of Infrastructure as Code (IaC) and cloud services.

# 

# \---

# 

# \## Architecture

# 

# User → CloudFront → S3 Bucket

# 

# \- \*\*S3 Bucket\*\*: Stores static website files (e.g. `index.html`)

# \- \*\*CloudFront\*\*: Delivers content globally with low latency

# \- \*\*Origin Access Control (OAC)\*\*: Ensures secure access between CloudFront and S3

# 

# \---

# 

# \## Technologies Used

# 

# \- Terraform

# \- AWS (S3, CloudFront)

# 

# \---

# 

# \## Features

# 

# \- Infrastructure as Code using Terraform

# \- Secure access to S3 via CloudFront (OAC)

# \- Deployment of a static HTML page

# \- CDN-based content delivery

# 

# \---

# 

# \## Prerequisites

# 

# \- Terraform installed

# \- AWS account

# \- Configured AWS credentials

# 

# \---

# 

# \## Usage

# 

# ```bash

# terraform init

# terraform apply

