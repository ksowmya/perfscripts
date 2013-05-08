cloud-setup-databases cloud@10.223.41.5 --deploy-as=root:
mysql -h 10.223.41.5 < ./create-database-simulator.sql
mysql -h 10.223.41.5 < ./create-schema-simulator.sql
cloud-setup-management

