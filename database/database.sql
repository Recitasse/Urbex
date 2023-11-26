-- MySQL Script generated by MySQL Workbench
-- Sun Nov 12 22:14:50 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Urbex
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Urbex
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Urbex` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `Urbex` ;

-- -----------------------------------------------------
-- Table `Urbex`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Urbex`.`users` (
  `users_id` INT AUTO_INCREMENT,
  `users_pseudo` VARCHAR(255) NOT NULL,
  `users_center` VARCHAR(100) NOT NULL DEFAULT '46.980146, 2.551705',
  `users_grade` TINYINT(5) NOT NULL DEFAULT 0,
  `users_admin` TINYINT(1) NOT NULL DEFAULT 0,
  `users_join` VARCHAR(45) NOT NULL,
  `users_mdp` VARCHAR(255) CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci' NOT NULL,
  PRIMARY KEY (`users_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Urbex`.`type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Urbex`.`type` (
  `type_id` INT AUTO_INCREMENT,
  `type_name` VARCHAR(100) NULL,
  PRIMARY KEY (`type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Urbex`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Urbex`.`city` (
  `city_id` INT AUTO_INCREMENT,
  `city_country` VARCHAR(2) NOT NULL DEFAULT 'FR',
  `city_name` VARCHAR(155) NOT NULL,
  `city_localisation` VARCHAR(45) NOT NULL,
  `city_code` VARCHAR(6) NOT NULL,
  `city_departement` VARCHAR(150) NOT NULL,
  `city_region` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`city_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Urbex`.`spots`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Urbex`.`spots` (
  `spots_id` INT AUTO_INCREMENT,
  `spots_country` VARCHAR(2) NOT NULL DEFAULT 'FR',
  `spots_type` INT DEFAULT 0,
  `spots_ville` INT NOT NULL,
  `spots_user` INT NOT NULL,
  `spots_loc` VARCHAR(45) NOT NULL DEFAULT 'None',
  `spots_difficulty` TINYINT(10) NOT NULL DEFAULT 3,
  `spots_degradation` TINYINT(10) NOT NULL DEFAULT 5,
  `spots_surveillance` TINYINT(10) NOT NULL DEFAULT 5,
  `spots_interet` TINYINT(10) NOT NULL DEFAULT 3,
  `spots_link` VARCHAR(400) NULL,
  PRIMARY KEY (`spots_id`),
  INDEX `discoverer_idx` (`spots_user` ASC) VISIBLE,
  INDEX `type_spot_idx` (`spots_type` ASC) VISIBLE,
  INDEX `ville_idx` (`spots_ville` ASC) VISIBLE,
  CONSTRAINT `discoverer`
    FOREIGN KEY (`spots_user`)
    REFERENCES `Urbex`.`users` (`users_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `type_spot`
    FOREIGN KEY (`spots_type`)
    REFERENCES `Urbex`.`type` (`type_id`)
    ON DELETE SET DEFAULT  -- Set the foreign key to default value on delete
    ON UPDATE NO ACTION,
  CONSTRAINT `ville`
    FOREIGN KEY (`spots_ville`)
    REFERENCES `Urbex`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
