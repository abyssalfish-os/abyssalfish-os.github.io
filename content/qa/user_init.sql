--
-- Table structure for table `t_user`
--

DROP TABLE IF EXISTS `t_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `pass` varchar(100) DEFAULT '',
  `lasttime` int(11) DEFAULT NULL,
  `lastip` int(10) unsigned DEFAULT NULL,
  `level` varchar(10) DEFAULT 'viewer',
  `createtime` int(11) DEFAULT NULL,
  `comment` varchar(200) DEFAULT NULL,
  `disabled` char(1) DEFAULT 'N',
  `creator` varchar(50) DEFAULT '',
  `lockedtime` bigint(20) NOT NULL DEFAULT '0',
  `lastsession` char(32) NOT NULL DEFAULT '',
  `resource` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

LOCK TABLES `t_user` WRITE;
/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (1,'admin','0b2c6435092cd5e4bafe47fdf1e92e9c',NULL,NULL,'sysadmin',0,'','N','',0,'',NULL),(2,'analyser','0b2c6435092cd5e4bafe47fdf1e92e9c',NULL,NULL,'analyser',0,'','N','',0,'',NULL),(3,'viewer','0b2c6435092cd5e4bafe47fdf1e92e9c',NULL,NULL,'viewer',0,'','N','',0,'',NULL);
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;
UNLOCK TABLES;