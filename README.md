[![Infrastructure CI/CD pipeline](https://github.com/ozennou/code-keeper/actions/workflows/infra-pipeline.yml/badge.svg)](https://github.com/ozennou/code-keeper/actions/workflows/infra-pipeline.yml)

# **CodeGuard**

## **Overview**
- CodeGuard is a learning project where I apply my skills in Infrastructure as Code (IaC), Configuration Management, building CI/CD pipelines and GitLab.
- In this project, I use Terraform to create an Azure infrastructure composed of two VMs: one for the GitLab EE instance and one for the GitLab Runner, along with all the necessary components to make the GitLab instance accessible from the internet securely:

<img src="./imgs/diagram.png" width="800" style="border: 5px solid black; border-radius: 15px; margin-left: 30px;" />

## Resources
### Storing terraform state in azure storage:
https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli
### Azure terraform resources docs:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
### Run Ansible playbooks on GitHub actions
https://groups.google.com/g/ansible-project/c/OZPu-b17n_w?pli=1

