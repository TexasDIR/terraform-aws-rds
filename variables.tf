################################################################################
# Instance Specifications
################################################################################
variable "region" {
  type        = string
  description = "AWS region to deploy resources into."
}

variable "account_id" {
  type        = string
  description = "AWS account_id to deploy resources into."
}

variable "partition" {
  type        = string
  description = "If Govcloud then enter aws-us-gov if not enter aws"
  validation {
    condition     = contains(["aws-us-gov", "aws"], var.partition)
    error_message = "Valid values for var: environment are (aws-us-gov or aws)."
  }
}

variable "db_identifier" {
  type        = string
  description = "The name of the RDS instance"
}

variable "db_name" {
  description = "Name to be used for database_name as identifier"
  type        = string
  validation {
    condition     = length(var.db_name) > 1 && length(var.db_name) < 65
    error_message = "The database name for RDS instance cannot be longer than 64 characters"
  }
}

variable "engine" {
  description = "The database type to use"
  type        = string
  validation {
    condition = contains([
      "mariadb",
      "mysql",
      "postgres",
      "sqlserver-ee",
      "sqlserver-se",
      "sqlserver-ex",
      "sqlserver-web"
    ], var.engine)
    error_message = "The database engine name is not correct."
  }
}

variable "db_type" {
  description = "The database type to use"
  type        = string
  validation {
    condition = contains([
      # "mariadb1011",
      # "mariadb114",
      "mysql80",
      "mysql84",
      # "postgres15",
      "postgres16",
      "postgres17",
      "sqlserver-ee-2017",
      "sqlserver-se-2017",
      "sqlserver-ex-2017",
      "sqlserver-web-2017",
      "sqlserver-ee-2019",
      "sqlserver-se-2019",
      "sqlserver-ex-2019",
      "sqlserver-web-2019"
    ], var.db_type)
    error_message = "The database engine type is not correct."
  }
}



variable "engine_version" {
  description = "The engine version to use"
  type        = string
}

# variable "major_engine_version" {
#   description = "The major engine version to use for the db parameter group option."
#   type = string

# }

# variable "engine_lifecycle_support" {
#   description = "The life cycle type for this DB instance. This setting applies only to RDS for MySQL and RDS for PostgreSQL. Valid values are `open-source-rds-extended-support`, `open-source-rds-extended-support-disabled`. Default value is `open-source-rds-extended-support`."
#   type        = string
# }

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
}

# DB subnet group
variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  # default     = false
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}

variable "db_subnet_group_use_name_prefix" {
  description = "Determines whether to use `subnet_group_name` as is or create a unique name beginning with the `subnet_group_name` as the prefix"
  type        = bool
  default     = true
}

variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs to add to DB subnet group"
  type        = list(string)
  # default     = []
}

variable "multi_az" {
  type        = bool
  description = "Specify whether the Database is configured in Multiple AZs or not."
  default     = false
}

variable "encrypted_storage" {
  type        = bool
  description = "Whether storage for RDS is encrypted or not."
  default     = true
}

variable "rds_backup_retention" {
  type        = number
  description = "RDS backup retention for the database."
  default     = 7
  validation {
    condition     = var.rds_backup_retention >= 0 && var.rds_backup_retention <= 35
    error_message = "Valid values for var: rds_backup_retention is between 0 - 35."
  }
}

variable "rds_preferred_backup_window" {
  type        = string
  description = "value"
  default     = "23:00-23:59"
}

# variable "rds_parameter_group_name" {
#   type        = string
#   description = "value"
# }

variable "instance_class" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  # default     = "t3.medium" #Setting default size
  validation {
    condition = !contains([
      "t2.nano",
      "t2.micro",
      "t2.small",
      "t3.nano",
      "t3.micro",
      "t3.small",
    ], var.instance_class)
    error_message = "Valid values for var: instances_class are available at: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Types.html"
  }
}

# variable "subnet_id" {
#   description = "Name to be used on all the resources as identifier"
#   type        = string
#   # default     = ""
# }

variable "db_username" {
  description = "The db master username"
  type        = string
  default     = "dba"
  validation {
    condition     = length(var.db_username) > 1 && length(var.db_username) < 17
    error_message = "The db master username for RDS instance cannot be longer than 16 characters"
  }
}

# variable "rds_port" {
#   type        = number
#   description = "RDS Port for Database."
#   validation {
#     condition     = contains([1433, 3306, 5432], var.rds_port)
#     error_message = "Valid values for var: rds_port are 1433 (SQL Server), 3306 (MySQL and MariaDB), and 5432 (PostgreSQL)."
#   }
# }

variable "rds_volume_size" {
  description = "RDS volume size in GB"
  type        = number
  default     = 20
  validation {
    condition     = var.rds_volume_size >= 20 && var.rds_volume_size <= 65536
    error_message = "Valid values for var: rds_volume_size is between 20 and 65536 GiB."
  }
}

variable "rds_volume_type" {
  description = "RDS volume type valid option types are gp2, gp3, io1, io2"
  type        = string
  # default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.rds_volume_type)
    error_message = "Valid values for var: rds_volume_type  are (gp2, gp3, io1, io2)."
  }
}

variable "max_allocated_storage" {
  description = "Max allocated storage size. Minimum is 20GiB (gp2 and gp3) and 100GiB (io1 and io2). Max 65536GiB (gp2 and gp3) and 16384GiB (io1 and io2)"
  type        = number
  default     = 100
  validation {
    condition     = var.max_allocated_storage >= 20 && var.max_allocated_storage <= 65536
    error_message = "Valid values for var: max_allocated_storage is between 20 and 65536 GiB."
  }
}

variable "rds_preferred_maintenance_windows" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

################################################################################
# Common Tags
################################################################################

variable "environment" {
  type        = string
  description = "value for pcm-environment tag"
  #  default = "Development"
  validation {
    condition     = contains(["Development", "Production", "Pre-Prod", "Testing"], var.environment)
    error_message = "Valid values for var: environment are (Development, Production, Pre-Prod, Testing)."
  }
}

variable "business_service" {
  description = "The value of the business_service tag."
  type        = string
  default     = "empty"
}

variable "application_name" {
  description = "The value of the application_name tag."
  type        = string
  default     = "test"
}

variable "project_number" {
  description = "The value of the project_number tag."
  type        = string
  default     = "pcm-management"
}

variable "tag_1" {
  description = "The value of the pcm-tag_1 tag."
  type        = string
  default     = "testing"
}

variable "tag_2" {
  description = "The value of the pcm-tag_2 tag."
  type        = string
  default     = "testing"
}

variable "tag_3" {
  description = "The value of the pcm-tag_3 tag."
  type        = string
  default     = "testing"
}

variable "cjis" {
  description = "The value of the cjis tag. Valid values are yes or no"
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.cjis)
    error_message = "Valid values for var: cjis are (yes, no)."
  }
}

variable "ferpa" {
  description = "The value of the ferpa tag."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.ferpa)
    error_message = "Valid values for var: ferpa are (yes, no)."
  }
}

variable "fti" {
  description = "The value of the fti tag."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.fti)
    error_message = "Valid values for var: fti are (yes, no)."
  }
}

variable "phi" {
  description = "The value of the phi tag."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.phi)
    error_message = "Valid values for var: phi are (yes, no)."
  }
}

variable "pii" {
  description = "The value of the pii tag."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.pii)
    error_message = "Valid values for var: pii are (yes, no)."
  }
}
variable "pci" {
  description = "The value of the pci tag."
  type        = string
  default     = "no"
  validation {
    condition     = contains(["yes", "no"], var.pci)
    error_message = "Valid values for var: pci are (yes, no)."
  }
}

variable "build_engineer" {
  description = "The email address of the build engineer."
  type        = string
  default     = "RackspacePCM"
}

variable "primary_capability" {
  description = "The value of the primary_capability tag."
  type        = string
  default     = "application_other"
}

variable "dr_capability" {
  description = "The value of the dr_capability tag."
  type        = string
  default     = "class_d"
  validation {
    condition     = contains(["class_a", "class_b", "class_c", "class_d", "class_e", "customer_opt_out"], var.dr_capability)
    error_message = "Valid values for var: dr_capability are (class_a, class_b, class_c, class_d, class_e, customer_opt_out)."
  }
}

variable "cloud_decision" {
  description = "The value of the cloud decision criteria tag."
  type        = string
  default     = "customer_preference"
}

variable "department" {
  description = "The value of the pcm-department tag"
  type        = string
  default     = "cmn_department"
}

variable "dba_support" {
  description = "The value of the pcm-dba_support tag"
  type        = string
  default     = "none"
}

variable "middleware_support" {
  description = "The value of the pcm-middleware_support tag"
  type        = string
  default     = "no"
}

variable "dmz" {
  description = "The value of the pcm-dmz tag"
  type        = string
  default     = "no"
}


variable "kms_key" {
  description = "The kms key to use for EBS Encryption"
  type        = string
  default     = null
}

################################################################################
# Mostly Static Tags
# Please leave default unless you absolutely have to modify these.
################################################################################

variable "backup" {
  description = "Backup tag"
  type        = string
  default     = "True"
  validation {
    condition     = contains(["True", "False"], var.backup)
    error_message = "Valid values for var: backup are (True, False)."
  }
}