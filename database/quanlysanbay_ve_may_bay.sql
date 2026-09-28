-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: quanlysanbay
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'a35a2d81-17c8-11f1-8870-6c2b59632347:1-536';

--
-- Table structure for table `ve_may_bay`
--

DROP TABLE IF EXISTS `ve_may_bay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ve_may_bay` (
  `ma_ve` int NOT NULL AUTO_INCREMENT,
  `ma_hanh_khach` int DEFAULT NULL,
  `ma_chuyen_bay` int DEFAULT NULL,
  `loai_ve` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gia_ve` int NOT NULL,
  `thong_bao` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma_ve`),
  KEY `ma_hanh_khach` (`ma_hanh_khach`),
  KEY `ma_chuyen_bay` (`ma_chuyen_bay`),
  CONSTRAINT `ve_may_bay_ibfk_1` FOREIGN KEY (`ma_hanh_khach`) REFERENCES `hanh_khach` (`ma_hanh_khach`),
  CONSTRAINT `ve_may_bay_ibfk_2` FOREIGN KEY (`ma_chuyen_bay`) REFERENCES `chuyen_bay` (`ma_chuyen_bay`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ve_may_bay`
--

LOCK TABLES `ve_may_bay` WRITE;
/*!40000 ALTER TABLE `ve_may_bay` DISABLE KEYS */;
INSERT INTO `ve_may_bay` VALUES (1,1,1,'Hạng thương gia',0,'Chuyến bay đã bị hoãn'),(2,2,1,'Hạng phổ thông',0,'Chuyến bay đã bị hoãn'),(3,3,2,'Hạng phổ thông',980000,'Không hoàn đổi vé'),(4,4,2,'Hạng thương gia',2800000,'Được vào phòng chờ thương gia'),(5,5,3,'Hạng phổ thông',0,'Chuyến bay đã bị hoãn'),(6,1,4,'Hạng phổ thông',0,'Chuyến bay đã bị hủy'),(7,2,3,'Hạng thương gia',0,'Chuyến bay đã bị hoãn'),(8,6,2,'Hạng thương gia',2000000,'');
/*!40000 ALTER TABLE `ve_may_bay` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-29  5:23:35
