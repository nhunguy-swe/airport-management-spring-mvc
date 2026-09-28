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
-- Table structure for table `chuyen_bay`
--

DROP TABLE IF EXISTS `chuyen_bay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chuyen_bay` (
  `ma_chuyen_bay` int NOT NULL AUTO_INCREMENT,
  `so_hieu_chuyen_bay` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ngay_gio_khoi_hanh` datetime NOT NULL,
  `ngay_gio_den` datetime NOT NULL,
  `diem_khoi_hanh` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `diem_den` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `trang_thai` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ma_chuyen_bay`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chuyen_bay`
--

LOCK TABLES `chuyen_bay` WRITE;
/*!40000 ALTER TABLE `chuyen_bay` DISABLE KEYS */;
INSERT INTO `chuyen_bay` VALUES (1,'VN-A123','2026-07-01 08:00:00','2026-07-01 10:15:00','Hà Nội (HAN)','TP. Hồ Chí Minh (SGN)','Đúng giờ'),(2,'VJ-B456','2026-07-01 13:30:00','2026-07-01 15:00:00','Đà Nẵng (DAD)','Hà Nội (HAN)','Đúng giờ'),(3,'QH-C789','2026-07-02 06:00:00','2026-07-02 07:45:00','Hải Phòng (HPH)','Nha Trang (CXR)','Hoãn'),(4,'VN-A999','2026-07-03 21:00:00','2026-07-03 23:30:00','TP. Hồ Chí Minh (SGN)','Phú Quốc (PQC)','Hủy'),(5,'VJ-B888','2026-07-04 09:15:00','2026-07-04 11:30:00','Cần Thơ (VCA)','Đà Nẵng (DAD)','Đúng giờ');
/*!40000 ALTER TABLE `chuyen_bay` ENABLE KEYS */;
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

-- Dump completed on 2026-09-29  5:23:36
