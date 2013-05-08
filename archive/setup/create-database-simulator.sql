SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ANSI';

DROP DATABASE IF EXISTS `cloud_simulator`;

CREATE DATABASE `cloud_simulator`;

GRANT ALL ON cloud_simulator.* to cloud@`localhost`;
GRANT ALL ON cloud_simulator.* to cloud@`%`;

GRANT process ON *.* TO cloud@`localhost`;
GRANT process ON *.* TO cloud@`%`;

commit;
