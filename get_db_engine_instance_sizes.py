import boto3
import os

commercial_regions = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
    ]
govcloud_regions = ["us-gov-west-1", "us-gov-east-1"]

rds_engines = [
    "mariadb",
    "mysql",
    "postgres",
    "sqlserver-ee",
    "sqlserver-se",
    "sqlserver-ex",
    "sqlserver-web"
               ]

session = boto3.Session()


def get_rds_engine_version(engine, region):
    rds = session.client("rds", region_name=region)
    engine_versions = []
    response = rds.describe_db_engine_versions(Engine=engine)
    engine_versions_unformatted = response['DBEngineVersions']
    for version in engine_versions_unformatted:
        engine_versions.append(version['EngineVersion'])
    latest_engine_version = engine_versions[-1]
    return latest_engine_version


def get_rds_instance_sizes_per_region(engine, engine_version, region):
    rds = session.client("rds", region_name=region)
    instance_types = []
    response = rds.describe_orderable_db_instance_options(
        Engine=engine,
        EngineVersion=engine_version)
    instance_types_unformatted = response['OrderableDBInstanceOptions']
    for instance_type in instance_types_unformatted:
        instance_types.append(instance_type['DBInstanceClass'])
    
    return instance_types


if os.environ.get('AWS_DEFAULT_REGION') in commercial_regions or os.environ.get('AWS_REGION') in commercial_regions:
    print("Running in AWS Commercial partition.")
    regions = commercial_regions
    file_name_prefix = "comm"
else:
    print("Running in AWS GovCloud partition.")
    regions = govcloud_regions
    file_name_prefix = "comm"

file = open(file_name_prefix+"_db_instance_sizes.txt", "w")
for engine in rds_engines:
    
    for region in regions:
        region_string = "Getting Instance Types for Engine: " + engine + " in Region: " + region
        print(region_string)
        engine_version = get_rds_engine_version(engine, region)
        print(engine_version)
        instance_types = get_rds_instance_sizes_per_region(engine, engine_version, region)
        uniq_instance_types = list(set(instance_types))
        sorted_instance_types = sorted(uniq_instance_types)
        print(sorted_instance_types)
        file.write(region_string)
        file.write("\n")
        file.write("-"*20)
        file.write("\n")
        for instance_type in sorted_instance_types:
            file.write(instance_type)
            file.write("\n")
        
file.close()

# rds = session.client("rds")


