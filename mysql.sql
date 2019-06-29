
CREATE TABLE IF NOT EXISTS `bre_logdetails` (
  `id` int(11) NOT NULL,
  `username` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `whitelisted` tinyint(1) DEFAULT 0,
  `banned` varchar(100) DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



CREATE TABLE IF NOT EXISTS `bre_userdetails` (
  `user_id` int(11) NOT NULL,
  `wallet` float DEFAULT NULL,
  `bank` float DEFAULT NULL,
  `inventory` varchar(255) DEFAULT '{}',
  `identity_card` varchar(255) DEFAULT '0',
  `helper` int(11) DEFAULT 0,
  `admin` int(11) DEFAULT 0,
  `grades` varchar(255) DEFAULT '{}',
  `x` double(8,2) DEFAULT NULL,
  `y` double(8,2) DEFAULT NULL,
  `z` double(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `bre_vehicles` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `vehicle` varchar(50) NOT NULL,
  `vehicle_plate` varchar(50) NOT NULL,
  `upgrades` varchar(255) NOT NULL DEFAULT '{}',
  `odometer` float DEFAULT 0,
  `x` float DEFAULT 0,
  `y` float DEFAULT 0,
  `z` float DEFAULT 0,
  `h` float DEFAULT 0
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

ALTER TABLE `bre_logdetails`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bre_userdetails`
  ADD PRIMARY KEY (`user_id`);

ALTER TABLE `bre_vehicles`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `bre_logdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;

ALTER TABLE `bre_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1;

ALTER TABLE `bre_userdetails`
  ADD CONSTRAINT `fk_userdetails` FOREIGN KEY (`user_id`) REFERENCES `bre_logdetails` (`id`) ON DELETE CASCADE;
