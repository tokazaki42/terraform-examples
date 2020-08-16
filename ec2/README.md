- Copy aws.tfvars.template to aws.tfvars
- Write your AWS access key, secret key and region in aws.tfvars.
- Change values in variable.tf.


- Execute Terraform.
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



