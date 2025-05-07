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
- Two persistent disks (OS \ Data) with the OS and sizing of your choice
- Disks will be automatically added to the default snapshot schedule built into the existing AWS Backup

<p>To learn more about AWS EC2 instances including instance types and stoprage options please click the following link <a href="https://docs.aws.amazon.com/ec2/?nc2=h_ql_doc_ec2">Amazon Elastic Compute Cloud Documentation</a></p>

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
  subnet_id                          = ["subnet-<abcdefghi......>","subnet-<12345678.....>]
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
  pcm-patching_last_updated          = "No auto"
  pcm-av_last_updated                = "No auto"  
}
```
## Inputs (variables)

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account_id | This is the AWS account id where you would like the ec2 instance deployed | `string` | `""` | yes |
| region | This is the AWS region where you would like the resource deployed  | `string` | `""` | yes |
| db_identifier | This will be the database identifier for the newly created RDS instance. | `string` | `""` | yes |
| instance_class | This option would be your instance type, more information can be found within the following AWS documentation https://docs.aws.amazon.com/ec2/latest/instancetypes/instance-types.html | `string` | `""` | yes |
| rds_volume_type | This would be the "type" of disk used to run your RDS Instance, more information can be found at https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html | `string` | `""` | yes |
| rds_volume_size | This would be a numeric value assigned to your RDS volume, the recommended minimum value is 100gb | `string` | `""` | yes |
| max_allocated_storage | Max size of RDS storage volume to grow to | `string` | `""` | yes |
| engine | The database engine from which to launch new RDS instance   | `string` | `""` | yes |
| engine_version | The database engine version from which to launch new RDS instance   | `string` | `""` | yes |
| db_type | The database engine version from which to launch new RDS instance   | `string` | `""` | yes |

| subnet_ids | The ids of the subnetworks to attach this RDS instance to | `list` | `""` | yes |
| partition | The AWS partition to deploy EC2 instance to | `string` | `""` | yes |
| vpc_security_group_ids | The list of security groups to attach to the RDS instance| `list` | `""` | yes |
| business_service | ServiceNow Application Portfolio Management (APM) - Business Service Sysid.  Used to identify which Business Service(s) each cloud resource is being used to support | `string` | `""` | yes |
| application_name | ServiceNow Application Portfolio Management (APM) - Application Name sysid.  Used to identify which Application Name(s) each cloud resource is being used to support. Refer to Application Portfolio Management (APM) | `string` | `""` | yes |
| tag1 | Customer choice.  Customer Tag for ITFM.  This can be any data the Customer would like to see in the ITFM system for their own grouping or knowledge of specific device(s) | `string` | `""` | yes |
| tag2 | Customer choice.  Customer Tag for ITFM.  This can be any data the Customer would like to see in the ITFM system for their own grouping or knowledge of specific device(s) | `string` | `""` | yes |
| tag3 | Customer choice.  Customer Tag for ITFM.  This can be any data the Customer would like to see in the ITFM system for their own grouping or knowledge of specific device(s) | `string` | `""` | yes |
| cjis | Indicates that this resource processes sensitive CJIS data | `string` | `""` | yes |
| ferpa | Indicates that this resource processes sensitive FERPA data | `string` | `""` | yes |
| fti | Indicates that this resource processes sensitive FTI data | `string` | `""` | yes |
| phi | Indicates that this resource processes sensitive PHI data | `string` | `""` | yes |
| pii | Indicates that this resource processes sensitive PII data | `string` | `""` | yes |
| pci | Indicates that this resource processes sensitive PCI data | `string` | `""` | yes |
| environment | Identifies the lifecycle of the environment (ie., dev, test, prod) | `string` | `""` | yes |
| primary_capability | Used to categorize the primary capability associated with end point | `string` | `""` | yes |
| dba_support | Identifies that customer is entitled to receive Database Administration Support as defined in the contract. This tag is required if the primary capability is Application - Database | `string` | `""` | yes |
| middleware_support | Identifies that customer is entitled to receive Middleware Support as defined in the contract. This tag is required if the primary capability is Application - Middleware | `string` | `""` | yes |
| dr_capability | Disaster Recovery capability associated with the resource.  For older builds, CIs must go through a DR entitlement assessment before a DR class is assigned | `string` | `""` | yes |
| dmz | Indicates that this resource is contained in the public portion of the customer's environment. If the value for this is yes, PCESS should also be yes | `string` | `""` | yes |
| patch_group | Name of the patch group associated with this resource | `string` | `""` | yes |
| cloud_decision | To identify why customers chose the Cloud Service Provider (CSP) they are using | `string` | `""` | yes |

## Outputs
| Name | Description |
|------|-------------|
| RDS Hostname | This is the RDS instance hostname of the new RDS instance that was created |
| RDS Username | This is the RDS master username for the created RDS instance |
| RDS DB Engine | This is the RDS RDS database engine for the created RDS instance |
| RDS DB Identifier | This is the RDS database identifier for the created RDS instance |
| RDS DB Resource ID | This is the RDS database resource id for the created RDS instance |