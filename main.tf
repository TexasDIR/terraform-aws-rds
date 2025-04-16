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
data "aws_rds_engine_version" "latest" {
  engine             = var.engine
  preferred_versions = [var.engine_version]
}

locals {
  tags = {
    environment                = var.environment
    pcm-business_service_sysid = var.business_service
    pcm-application_name_sysid = var.application_name
    pcm-project_number         = var.project_number
    pcm-tag_1                  = var.tag_1
  }
  rds_family = "${var.engine}${var.engine_version}"
  identifier = var.db_identifier == "" ? "${lower(var.application_name)}-${lower(var.environment)}-${lower(var.engine)}" : var.db_identifier
}

######## RDS MySQL ########

module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  identifier                  = local.identifier
  engine                      = var.engine
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
  # major_engine_version        = var.engine_version
  parameter_group_name        = var.rds_parameter_group_name
  deletion_protection         = true

  # parameters = [
  #   {
  #     name  = "time_zone"
  #     value = "US/Central"
  #   }
  # ]

  tags                        = local.tags
}