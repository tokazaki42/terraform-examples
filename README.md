## About this Repository

This is a personal repository aims to learn AWS and Terraform.

Each Terraform code associates with following blog posts.
https://www.learningcloudinfra.tokyo/en/aws/


## Preparation 
- Install Terraform on your laptop.
  [HashiCorp Learn: Terraform Get Started](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Clone this repository and move to each subdirectory.
- Copy aws.tfvars.template to aws.tfvars
- Write your AWS access key, secret key and region in aws.tfvars.
- Change values in variable.tf.


## TryTerraform.
Initialize Terraform 
```
terraform init

```

 Plan the changes 
```
terraform plan -var-file=aws.tfvars

```

Apply the execution plan 
```
terraform apply -var-file=aws.tfvars
```

Destroy the resources
```
terraform destroy -var-file=aws.tfvars
```



