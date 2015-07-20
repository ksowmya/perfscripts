cloudstack-setup-databases cloud@10.223.48.3 --deploy-as=root:
mysql -h 10.223.41.4 < ./create-database-simulator.sql
mysql -h 10.223.41.4 < ./create-schema-simulator.sql
cloud-setup-management

