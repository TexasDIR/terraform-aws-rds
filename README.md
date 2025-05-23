<!--- Update this line to a more specific description -->
# New AWS RDS Instance

<p align="center">
  <img height="130" src="https://www.comsoltx.com/wp-content/uploads/2016/03/logo-dir-e1462808600875.png">
  <h1 align="center">#DIRisIT</h1>
</p>

<!--- Pick Cloud provider Badge -->
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) -
<!---![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white) -->
<!-- ![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white) -->
<!---![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white) -->
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

<!--- Replace repository name -->
<!--- ![License](https://badgen.net/github/license/getindata/terraform-module-template/) -->
![Release](https://badgen.net/static/release/1.0.10/blue?icon=github) <br>
<!---  ![Release](https://badgen.net/static/pcm_project-number/prj12345678/) -->

---
<!--- Add information to each section below and be as accurate as possible when filling in the details -->

This module makes it easy to create a new RDS instance in AWS.

The resources/services/activations/deletions that this module will create/trigger are:

- One new AWS RDS instance
<!-- - Dual stacked ipv4 and ipv6 network interface -->
<!-- - Creates a network interface with both IPv4 and IPv6 addresses -->
- Creates a network interface with IPv4 address
- Disks will be automatically added to the default snapshot schedule built into the existing AWS Backup

<p>To learn more about AWS RDS instances including instance types and storage options please click the following link <a href="https://aws.amazon.com/rds/instance-types/">Amazon RDS Instance Types</a></p>

## Important:

> _There is not an option to assign a public IP to any instance and any inbound public access is required to route through PCESS._ <br>
> _Please submit a generic ticket request to request this instance be routeed through PCESS to allow for inbound public access._ <br>

## Compatibility

This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.
 If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v1.7.1](https://registry.terraform.io/modules/terraform-google-modules/-cloud-storage/google/v1.7.1).

## USAGE

Basic usage of this module is as follows:

```hcl
## The following values are examples of the requested variables
module "new-rds-instance" {
  source                             = "tfe.dir.texas.gov/TexasDIR/rds/aws"
  version                            = "~> 1.0.32"
  account_id                         = "<aws_account_id>"
  region                             = "us-east-2"
  instance_class                     = "db.m5.large"
  rds_volume_type                    = "gp3"
  rds_volume_size                    = "100"
  max_allocated_storage              = "1000"
  db_type                            = "postgres17"
  engine                             = "postgres"
  subnet_id                          = ["subnet-<abcdefghi......>","subnet-<12345678.....>"]
  partition                          = "aws"
  security_group_ids                 = ["sg-abcdefg0123456"]
  business_service                   = "empty"
  application_name                   = "empty"
  tag1                               = "ritm1234567"
  tag2                               = "ritm1234567"
  tag3                               = "ritm1234567"
  cjis                               = "no"
  ferpa                              = "no"
  fti                                = "no"
  phi                                = "no"
  pii                                = "no"
  pci                                = "no"
  environment                        = "Production"
  primary_capability                 = "application_database"
  dba_support                        = "none"
  middleware_support                 = "yes"
  dr_capability                      = "class_c"
  cloud_decision                     = "customer_preference"
  dmz                                = "no"
  patch_group                        = "patching-example"
  cloud_decision                     = "customer_preference"
}
```
## Inputs (variables)

| Name                             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                | Type             | Default                 | Required |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------|-------------------------|:--------:|
| account_id                       | This is the AWS account id where you would like the ec2 instance deployed                                                                                                                                                                                                                                                                                                                                                                                  | `string`         | `""`                    |   yes    |
| partition                        | If Govcloud then enter aws-us-gov, if not enter aws                                                                                                                                                                                                                                                                                                                                                                                                        | `string`         | `""`                    |   yes    |
| region                           | This is the AWS region where you would like the resource deployed                                                                                                                                                                                                                                                                                                                                                                                          | `string`         | `""`                    |   yes    |
| create_db_subnet_group           | This will create a db subnet group from the provided subnet ids                                                                                                                                                                                                                                                                                                                                                                                            | `bool`           | `N/A`                   |   yes    |
| db_identifier                    | This will be the database identifier for the newly created RDS instance.                                                                                                                                                                                                                                                                                                                                                                                   | `string`         | `""`                    |   yes    |
| db_name                          | This will be the database name for the newly created RDS instance.                                                                                                                                                                                                                                                                                                                                                                                         | `string`         | `""`                    |   yes    |
| db_subnet_group_name_prefix      | This will be the database subnet group name prefix added to the db subnet group name for the newly created RDS subnet group.                                                                                                                                                                                                                                                                                                                               | `string`         | `""`                    |   yes    |
| db_type                          | This is the type of RDS database to be deployed                                                                                                                                                                                                                                                                                                                                                                                                            | `string`         | `""`                    |   yes    |
| db_username                      | This is the username to use for the RDS instance                                                                                                                                                                                                                                                                                                                                                                                                           | `string`         | `""`                    |   yes    |
| deletion_protection              | This is whether to enable deletion protection for the RDS instance                                                                                                                                                                                                                                                                                                                                                                                         | `bool`           | `true`                  |   yes    |
| instance_class                   | This option would be your instance type, more information can be found within the following AWS documentation https://aws.amazon.com/rds/instance-types/                                                                                                                                                                                                                                                                                                   | `string`         | `""`                    |   yes    |
| max_allocated_storage            | Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to for this DB instance. By default, Storage Autoscaling is disabled. To enable Storage Autoscaling, set max_allocated_storage to greater than or equal to allocated_storage. Setting max_allocated_storage to 0 explicitly disables Storage Autoscaling. When configured, changes to allocated_storage will be automatically ignored as the storage can dynamically scale. | `number`         | `"100"`                 |   yes    |
| multi_az                         | Specifies if the RDS instance is multi-AZ                                                                                                                                                                                                                                                                                                                                                                                                                  | `bool`           | `false`                 |   yes    |
| rds_backup_retention             | RDS backup retention for the database.                                                                                                                                                                                                                                                                                                                                                                                                                     | `number`         | `7`                     |   yes    |
| rds_preferred_backup_window      | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: "09:46-10:16". Must not overlap with maintenance_window                                                                                                                                                                                                                                                                                             | `string`         | `"23:00-23:59"`         |   yes    |
| rds_preferred_maintenance_window | The weekly time range (in UTC) during which maintenance is performed if required. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'                                                                                                                                                                                                                                                                                                             | `string`         | `"Mon:00:00-Mon:03:00"` |   yes    |
| rds_volume_size                  | This would be a numeric value assigned to your RDS volume, the recommended minimum value is 100gb                                                                                                                                                                                                                                                                                                                                                          | `number`         | `""`                    |   yes    |
| rds_volume_type                  | This would be the "type" of disk used to run your RDS Instance, more information can be found at https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html                                                                                                                                                                                                                                                                                    | `string`         | `""`                    |   yes    |
| subnet_ids                       | The ids of the subnets to attach this RDS instance to                                                                                                                                                                                                                                                                                                                                                                                                      | `list of string` | `[""]`                  |   yes    |
| security_group_ids               | The list of security groups to attach to the RDS instance                                                                                                                                                                                                                                                                                                                                                                                                  | `list of string` | `[""]`                  |   yes    |
| application_name                 | ServiceNow Application Portfolio Management (APM) - Application Name sysid.  Used to identify which Application Name(s) each cloud resource is being used to support. Refer to Application Portfolio Management (APM)                                                                                                                                                                                                                                      | `string`         | `""`                    |   yes    |
| business_service                 | ServiceNow Application Portfolio Management (APM) - Business Service Sysid.  Used to identify which Business Service(s) each cloud resource is being used to support                                                                                                                                                                                                                                                                                       | `string`         | `""`                    |   yes    |
| environment                      | Identifies the lifecycle of the environment (ie., dev, test, prod)                                                                                                                                                                                                                                                                                                                                                                                         | `string`         | `""`                    |   yes    |
| project_number                   | Used to assign a project number tag to the RDS instance                                                                                                                                                                                                                                                                                                                                                                                                    | `string`         | `""`                    |   yes    |
| tag_1                            | This is the value for the pcm-tag_1 ITFM tag                                                                                                                                                                                                                                                                                                                                                                                                               | `string`         | `"empty"`               |    no    |
| tag_2                            | This is the value for the pcm-tag_2 tag                                                                                                                                                                                                                                                                                                                                                                                                                    | `string`         | `"empty"`               |    no    |
| tag_3                            | This is the value for the pcm-tag_3 tag                                                                                                                                                                                                                                                                                                                                                                                                                    | `string`         | `"empty"`               |    no    |
| cjis                             | Indicates that this resource processes sensitive CJIS data                                                                                                                                                                                                                                                                                                                                                                                                 | `string`         | `""`                    |   yes    |
| ferpa                            | Indicates that this resource processes sensitive FERPA data                                                                                                                                                                                                                                                                                                                                                                                                | `string`         | `""`                    |   yes    |
| fti                              | Indicates that this resource processes sensitive FTI data                                                                                                                                                                                                                                                                                                                                                                                                  | `string`         | `""`                    |   yes    |
| phi                              | Indicates that this resource processes sensitive PHI data                                                                                                                                                                                                                                                                                                                                                                                                  | `string`         | `""`                    |   yes    |
| pii                              | Indicates that this resource processes sensitive PII data                                                                                                                                                                                                                                                                                                                                                                                                  | `string`         | `""`                    |   yes    |
| pci                              | Indicates that this resource processes sensitive PCI data                                                                                                                                                                                                                                                                                                                                                                                                  | `string`         | `""`                    |   yes    |

## Outputs
| Name            | Description |
|-----------------|-------------|
| hostname    | This is the RDS instance hostname of the new RDS instance that was created |
| username    | This is the RDS master username for the created RDS instance |
| db_engine   | This is the RDS RDS database engine for the created RDS instance |
| identifier   | This is the RDS database identifier for the created RDS instance |
| resource_id  | This is the RDS database resource id for the created RDS instance |