provider "random" {}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:${var.partition}:iam::${var.account_id}:role/pcm-tfe-provisioning-role"
    session_name = "TFE_Session"
  }

}

resource "random_string" "password" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  special     = false
}


data "aws_availability_zones" "available" {}


locals {
  tags = {
    environment                = var.environment
    pcm-business_service_sysid = var.business_service
    pcm-application_name_sysid = var.application_name
    pcm-project_number         = var.project_number
    pcm-tag_1                  = var.tag_1
  }

  
  db_engine = {
  #   # MariaDB
  #   mariadb1011 = {
  #     engine               = "mariadb"
  #     engine_version       = 10.11
  #     parameter_group_name = "mariadb10.11"
  #     major_engine_version = 10
  #   }
  #   mariadb114 = {
  #     engine               = "mariadb"
  #     engine_version       = 11.4
  #     parameter_group_name = "mariadb11.4"
  #     major_engine_version = 11
  #   }
    # MySQL
    mysql80 = {
      engine               = "mysql"
      engine_version       = 8.0
      major_engine_version = 8
      parameter_group_name = "mysql8.0"
    }
    mysql84 = {
      engine               = "mysql"
      engine_version       = 8.4
      major_engine_version = 8
      parameter_group_name = "mysql8.4"
    }
    # PostgreSQL
    # postgres15 = {
    #   engine               = "postgres"
    #   engine_version       = 15
    #   major_engine_version = 15
    #   parameter_group_name = "postgres15"
    # }
    postgres16 = {
      engine               = "postgres"
      engine_version       = 16
      major_engine_version = 16
      parameter_group_name = "postgres16"
    }
    postgres17 = {
      engine               = "postgres"
      engine_version       = 17
      major_engine_version = 17
      parameter_group_name = "postgres17"
    }
    # SQL Server 2019
    sqlserver-ee-2019 = {
      engine               = "sqlserver-ee"
      engine_version       = 16.0
      major_engine_version = 16
      parameter_group_name = "sqlserver-ee-16.0"
    }
    sqlserver-se-2019 = {
      engine               = "sqlserver-se"
      engine_version       = 16.0
      major_engine_version = 16
      parameter_group_name = "sqlserver-se-16.0"
    }
    sqlserver-ex-2019 = {
      engine               = "sqlserver-ex"
      engine_version       = 16.0
      major_engine_version = 16
      parameter_group_name = "sqlserver-ex-16.0"
    }
    sqlserver-web-2019 = {
      engine               = "sqlserver-web"
      engine_version       = 16.0
      major_engine_version = 16
      parameter_group_name = "sqlserver-web-16.0"
    }
    # SQL Server 2017
    sqlserver-ee-2017 = {
      engine               = "sqlserver-ee"
      engine_version       = 15.0
      major_engine_version = 15
      parameter_group_name = "sqlserver-ee-15.0"
    }
    sqlserver-se-2017 = {
      engine               = "sqlserver-se"
      engine_version       = 15.0
      major_engine_version = 15
      parameter_group_name = "sqlserver-se-15.0"
    }
    sqlserver-ex-2017 = {
      engine               = "sqlserver-ex"
      engine_version       = 15.0
      major_engine_version = 15
      parameter_group_name = "sqlserver-ex-15.0"
    }
    sqlserver-web-2017 = {
      engine               = "sqlserver-web"
      engine_version       = 15.0
      major_engine_version = 15
      parameter_group_name = "sqlserver-web-15.0"
    }
  }
}

locals {
  # engine               = local.db_engine[var.db_type].engine
  # engine               = var.engine
  # engine_version       = var.engine_version
  # parameter_group_name = local.db_engine[var.db_type].parameter_group_name
  identifier = var.db_identifier == "" ? "${lower(var.application_name)}-${lower(var.environment)}-${lower(var.engine)}" : var.db_identifier
  rds_family = "${var.engine}${var.engine_version}"

}

data "aws_rds_engine_version" "latest" {
  engine             = var.engine
  # preferred_versions = [var.engine_version]
  latest = true
}

######## RDS MySQL ########
# Needs work
module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  identifier                  = local.identifier
  engine                      = local.db_engine[var.db_type].engine
  engine_version              = data.aws_rds_engine_version.latest.version_actual
  instance_class              = var.instance_class
  multi_az                    = var.multi_az
  manage_master_user_password = false
  password                    = random_string.password.result
  storage_encrypted           = var.encrypted_storage
  storage_type                = var.rds_volume_type
  subnet_ids                  = var.subnet_ids
  allocated_storage           = var.rds_volume_size
  max_allocated_storage       = var.max_allocated_storage
  username                    = var.db_username
  # port                        = var.rds_port
  vpc_security_group_ids      = var.vpc_security_group_ids
  maintenance_window          = var.rds_preferred_maintenance_windows
  backup_window               = var.rds_preferred_backup_window
  create_db_subnet_group      = var.create_db_subnet_group
  family                      = local.rds_family
  major_engine_version        = local.db_engine[var.db_type].major_engine_version
  # parameter_group_name        = "default.${var.db_type}"
  create_db_parameter_group = false
  parameter_group_use_name_prefix = true
  deletion_protection         = true

  # parameters = [
  #   {
  #     name  = "time_zone"
  #     value = "US/Central"
  #   }
  # ]

  tags = local.tags
}