
CREATE TABLE IF NOT EXISTS `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `permission` int(11) NOT NULL DEFAULT 0,
  `create_time` int(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `uid` INT(11) NOT NULL,
  `nickname` VARCHAR(128) NOT NULL,
  `money` INT(11) NOT NULL DEFAULT 0,
  `curlevel` INT(11) NOT NULL DEFAULT 0,
  `lastOnline` int(10) NOT NULL DEFAULT 0,
  `item` TEXT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `team_member` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `pid` INT(11),
  `alive` INT(2) NOT NULL DEFAULT 1,
  `weaponid` INT(11) NOT NULL DEFAULT 0,
  `armorid` INT(11) NOT NULL DEFAULT 0,
  `normalskillid` INT(11) NOT NULL DEFAULT 0,
  `ultraskillid` INT(11) NOT NULL DEFAULT 0,
  `hp` INT(11) NOT NULL DEFAULT 0,
  `energy` INT(11) NOT NULL DEFAULT 0,
  `practiceattrs` VARCHAR(256),
  `rewardattrs` VARCHAR(256),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;