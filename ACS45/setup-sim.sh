\cp cloud-plugin-hypervisor-simulator-4.5.1.0.jar /usr/share/cloudstack-management/webapps/client/WEB-INF/lib/
\cp templates.simulator.sql /usr/share/cloudstack-management/setup/templates.simulator.sql
#\cp tomcat6.conf /etc/cloudstack/management/tomcat6.conf
#grep "INSERT INTO\|VALUES" /usr/share/cloudstack-management/setup/templates.simulator.sql >> /usr/share/cloudstack-management/setup/templates.sql
grep "INSERT INTO\|VALUES" templates.simulator.sql >> /usr/share/cloudstack-management/setup/templates.sql
