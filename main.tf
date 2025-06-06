terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    hostname     = "tfe.dir.texas.gov"
    organization = "TexasDIR"

    workspaces {
      name = "pcm-rds-test"
    }
  }
}

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
    pcm-sensitive_data_cjis    = var.cjis
    pcm-sensitive_data_ferpa   = var.ferpa
    pcm-sensitive_data_fti     = var.fti
    pcm-sensitive_data_phi     = var.phi
    pcm-sensitive_data_pii     = var.pii
    pcm-sensitive_data_pci     = var.pci
    pcm-tag_1                  = var.tag_1
    pcm-tag_2                  = var.tag_2
    pcm-tag_3                  = var.tag_3
    pcm-built_by               = var.built_by
  }


  db_engine = {
    # MariaDB
    mariadb1011 = {
      engine               = "mariadb"
      engine_version       = "10.11"
      parameter_group_name = "mariadb10.11"
      major_engine_version = "10.11"
      license_model        = "general-public-license"
    }
    mariadb1104 = {
      engine               = "mariadb"
      engine_version       = "11.4"
      parameter_group_name = "mariadb11.4"
      major_engine_version = "11.4"
      license_model        = "general-public-license"
    }
    # MySQL
    mysql80 = {
      engine               = "mysql"
      engine_version       = "8.0"
      major_engine_version = "8.0"
      parameter_group_name = "mysql8.0"
      license_model        = "general-public-license"
    }
    mysql84 = {
      engine               = "mysql"
      engine_version       = "8.4"
      major_engine_version = "8.4"
      parameter_group_name = "mysql8.4"
      license_model        = "general-public-license"
    }
    postgres16 = {
      engine               = "postgres"
      engine_version       = "16"
      major_engine_version = "16"
      parameter_group_name = "postgres16"
      license_model        = "postgresql-license"
    }
    postgres17 = {
      engine               = "postgres"
      engine_version       = "17"
      major_engine_version = "17"
      parameter_group_name = "postgres17"
      license_model        = "postgresql-license"
    }
    # SQL Server 2022
    sqlserver-ee-2022 = {
      engine               = "sqlserver-ee"
      engine_version       = "16.00"
      major_engine_version = "16.00"
      parameter_group_name = "sqlserver-ee-16.00"
      license_model        = "license-included"
    }
    sqlserver-se-2022 = {
      engine               = "sqlserver-se"
      engine_version       = "16.00"
      major_engine_version = "16.00"
      parameter_group_name = "sqlserver-se-16.00"
      license_model        = "license-included"
    }
    sqlserver-ex-2022 = {
      engine               = "sqlserver-ex"
      engine_version       = "16.00"
      major_engine_version = "16.00"
      parameter_group_name = "sqlserver-ex-16.00"
      license_model        = "license-included"
    }
    sqlserver-web-2022 = {
      engine               = "sqlserver-web"
      engine_version       = "16.00"
      major_engine_version = "16.00"
      parameter_group_name = "sqlserver-web-16.00"
      license_model        = "license-included"
    }
    # SQL Server 2019
    sqlserver-ee-2019 = {
      engine               = "sqlserver-ee"
      engine_version       = "15.00"
      major_engine_version = "15.00"
      parameter_group_name = "sqlserver-ee-15.00"
      license_model        = "license-included"
    }
    sqlserver-se-2019 = {
      engine               = "sqlserver-se"
      engine_version       = "15.00"
      major_engine_version = "15.00"
      parameter_group_name = "sqlserver-se-15.00"
      license_model        = "license-included"
    }
    sqlserver-ex-2019 = {
      engine               = "sqlserver-ex"
      engine_version       = "15.00"
      major_engine_version = "15.00"
      parameter_group_name = "sqlserver-ex-15.00"
      license_model        = "license-included"
    }
    sqlserver-web-2019 = {
      engine               = "sqlserver-web"
      engine_version       = "15.00"
      major_engine_version = "15.00"
      parameter_group_name = "sqlserver-web-15.00"
      license_model        = "license-included"
    }
  }
}

locals {
  # engine               = local.db_engine[var.db_type].engine
  # engine               = var.engine
  # engine_version       = var.engine_version
  # parameter_group_name = local.db_engine[var.db_type].parameter_group_name
  identifier = var.db_identifier == "" ? "${lower(var.application_name)}-${lower(var.environment)}-${lower(local.db_engine[var.db_type].engine)}" : var.db_identifier
  rds_family = "${local.db_engine[var.db_type].engine}${local.db_engine[var.db_type].engine_version}"
  iops = var.rds_volume_size <= 400 ? 12000 : 3000
}

data "aws_rds_engine_version" "latest" {
  engine  = local.db_engine[var.db_type].engine
  version = local.db_engine[var.db_type].engine_version
  latest  = true
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
  manage_master_user_password = true
  # password                    = random_string.password.result
  storage_encrypted     = var.encrypted_storage
  storage_type          = var.rds_volume_type
  subnet_ids            = var.subnet_ids
  allocated_storage     = var.rds_volume_size
  max_allocated_storage = var.max_allocated_storage
  iops                  = local.iops
  username              = var.db_username
  # port                            = var.rds_port
  vpc_security_group_ids = var.security_group_ids
  maintenance_window     = var.rds_preferred_maintenance_windows
  backup_window          = var.rds_preferred_backup_window
  create_db_subnet_group = var.create_db_subnet_group
  family                 = local.rds_family
  major_engine_version   = local.db_engine[var.db_type].major_engine_version
  # parameter_group_name            = "default.${var.db_type}"
  create_db_parameter_group       = false
  create_db_option_group          = true
  option_group_name               = var.db_type
  parameter_group_use_name_prefix = true
  deletion_protection             = var.deletion_protection
  license_model                   = local.db_engine[var.db_type].license_model
  backup_retention_period         = var.rds_backup_retention
  # parameters = [
  #   {
  #     name  = "time_zone"
  #     value = "US/Central"
  #   }
  # ]

  tags = local.tags
}