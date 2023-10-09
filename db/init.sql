-- init.sql

-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS `db-square-root` DEFAULT CHARACTER SET utf8mb4;

-- Use the database
USE `db-square-root`;

-- Table structure for the `logs` table
DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `input` double DEFAULT NULL,
  `hasil` double DEFAULT NULL,
  `waktu` double DEFAULT NULL,
  `jenis` char(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Procedure structure for procedure `square_root`
DROP PROCEDURE IF EXISTS `square_root`;

DELIMITER $$

CREATE PROCEDURE `square_root`(IN input DOUBLE, OUT output DOUBLE, OUT timeoutput DOUBLE)
BEGIN
    DECLARE hasil DOUBLE;
    DECLARE tebak DOUBLE;
    DECLARE toleransi DOUBLE;

    SET hasil = input/2;
    SET tebak = 0;
    SET toleransi = 0.00001;

    SET @mulai = NOW(6) + 0;
    WHILE abs(hasil - tebak) > toleransi DO
        SET tebak = hasil;
        SET hasil = 0.5 * (hasil + (input/hasil));
    END WHILE;
    SET @akhir = NOW(6) + 0;
    SET @waktu = @akhir - @mulai;

    INSERT INTO `logs`(input, hasil, waktu, jenis, created_at, updated_at)
    VALUES(
        input,
        hasil,
        @waktu,
        'PL-SQL',
        NOW(),
        NOW()
    );

    SET output = hasil;
    SET timeoutput = @waktu;
END;
$$

DELIMITER ;