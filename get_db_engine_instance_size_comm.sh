engines=("postgres" "mariadb" "mysql" "sqlserver-ex" "sqlserver-web" "sqlserver-se" "sqlserver-ee")
# engines=("mariadb")
# version="11.4.5"
regions=("us-east-1" "us-east-2" "us-west-1" "us-west-2")
# regions=("us-east-1")
echo "RDS Instance Sizes per region" | tee db_instance_sizes.txt
for engine in "${engines[@]}"; do
    echo "Engine: $engine" | tee -a db_instance_sizes.txt
    version=`aws rds describe-db-engine-versions --engine $engine | jq '(.[] | reverse)[0]' | jq .EngineVersion | tr -d '"'`
    for region in "${regions[@]}"; do
        echo "Region: $region" | tee -a db_instance_sizes.txt
        echo "--------------------------------------" | tee -a db_instance_sizes.txt
        aws rds describe-orderable-db-instance-options --engine $engine --engine-version $version \
            --query "*[].{DBInstanceClass:DBInstanceClass,StorageType:StorageType}|[?StorageType=='gp3']|[].{DBInstanceClass:DBInstanceClass}" \
            --output text --region $region | tee -a db_instance_sizes.txt
        echo "--------------------------------------" | tee -a db_instance_sizes.txt
    done
done