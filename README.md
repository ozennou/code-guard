[![Infrastructure CI/CD pipeline](https://github.com/ozennou/code-keeper/actions/workflows/infra-pipeline.yml/badge.svg)](https://github.com/ozennou/code-keeper/actions/workflows/infra-pipeline.yml)
## Resources
### Storing terraform state in azure storage:
https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli
### Azure terraform resources docs:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
### Run Ansible playbooks on GitHub actions
https://groups.google.com/g/ansible-project/c/OZPu-b17n_w?pli=1


```
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.ini Gitlab-instance.yml
```
