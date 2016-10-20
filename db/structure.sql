-- MySQL dump 10.13  Distrib 5.5.52, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: labeling_production
-- ------------------------------------------------------
-- Server version	5.5.52-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `additional_infos`
--

DROP TABLE IF EXISTS `additional_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `additional_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `workflow_station_id` int(11) DEFAULT NULL,
  `info_timestamp` datetime DEFAULT NULL,
  `note` text COLLATE utf8_unicode_ci,
  `reason_code_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `station` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_additional_infos_index` (`work_flow_id`,`object_id`,`object_type`)
) ENGINE=InnoDB AUTO_INCREMENT=1962 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_options`
--

DROP TABLE IF EXISTS `attribute_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `label_attribute_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attribute_values`
--

DROP TABLE IF EXISTS `attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attribute_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_attribute_id` int(11) DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_attribute_values_on_object_id_and_object_type` (`object_id`,`object_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2447 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authentications`
--

DROP TABLE IF EXISTS `authentications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `proid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `refresh_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_authentications_on_provider` (`provider`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bu_options`
--

DROP TABLE IF EXISTS `bu_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bu_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recording_level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bu_options_on_work_flow_id_and_recording_level` (`work_flow_id`,`recording_level`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_definitions`
--

DROP TABLE IF EXISTS `group_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(45) DEFAULT NULL,
  `step_collection` varchar(200) DEFAULT NULL,
  `station_collection` varchar(300) DEFAULT NULL,
  `time_budget` int(2) DEFAULT NULL,
  `comp_dependent` bit(1) DEFAULT NULL,
  `seq` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `holidays`
--

DROP TABLE IF EXISTS `holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `holidays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `holiday_date` date DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_holidays_on_work_flow_id` (`work_flow_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l1s`
--

DROP TABLE IF EXISTS `l1s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l1s` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8_unicode_ci,
  `business_unit` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_component` int(11) DEFAULT NULL,
  `status` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `completed_estimate` datetime DEFAULT NULL,
  `completed_actual` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified_by_user_id` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique` (`name`),
  KEY `index_l1s_on_work_flow_id_and_status` (`work_flow_id`,`status`(255)),
  KEY `index_l1s_on_work_flow_id` (`work_flow_id`),
  KEY `index_l1s_on_name_and_work_flow_id` (`name`,`work_flow_id`),
  KEY `index_l1s_on_name` (`name`),
  KEY `index_l1s_on_business_unit` (`business_unit`(255)),
  KEY `index_l1s_on_name_and_business_unit` (`name`,`business_unit`(255)),
  KEY `index_l1s_on_name_and_business_unit_and_work_flow_id` (`name`,`business_unit`(255),`work_flow_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1228 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l2s`
--

DROP TABLE IF EXISTS `l2s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l2s` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `l1_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `business_unit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_component` int(11) DEFAULT NULL,
  `requested_date` datetime DEFAULT NULL,
  `to_be_approved_by` datetime DEFAULT NULL,
  `translation` tinyint(1) DEFAULT NULL,
  `completed_estimate` datetime DEFAULT NULL,
  `completed_actual` datetime DEFAULT NULL,
  `latest_ia_approval_date` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified_by_user_id` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_l2s_on_l1_id` (`l1_id`),
  KEY `index_l2s_on_name` (`name`),
  KEY `index_l2s_on_business_unit` (`business_unit`),
  KEY `index_l2s_on_name_and_business_unit` (`name`,`business_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=1239 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `l3s`
--

DROP TABLE IF EXISTS `l3s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `l3s` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `business_unit` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_component` int(11) DEFAULT NULL,
  `num_component_in_rework` int(11) DEFAULT NULL,
  `rework_parent_id` int(11) DEFAULT NULL,
  `is_full_rework` tinyint(1) DEFAULT NULL,
  `is_closed` tinyint(1) DEFAULT '0',
  `is_main_record` tinyint(1) DEFAULT NULL,
  `merge_back_with_id` int(11) DEFAULT NULL,
  `l2_id` int(11) DEFAULT NULL,
  `completed_estimate` datetime DEFAULT NULL,
  `completed_actual` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified_by_user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_l3s_on_l2_id` (`l2_id`),
  KEY `index_l3s_on_name` (`name`),
  KEY `index_l3s_on_business_unit` (`business_unit`),
  KEY `index_l3s_on_name_and_business_unit` (`name`,`business_unit`)
) ENGINE=InnoDB AUTO_INCREMENT=1604 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `label_attributes`
--

DROP TABLE IF EXISTS `label_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `label_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_flow_id` int(11) DEFAULT NULL,
  `recording_level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `short_label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT NULL,
  `sequence` int(3) DEFAULT NULL,
  `is_visible` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_label_attributes_index` (`work_flow_id`,`recording_level`,`is_visible`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notes`
--

DROP TABLE IF EXISTS `notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `l3_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oauth_caches`
--

DROP TABLE IF EXISTS `oauth_caches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth_caches` (
  `authentication_id` int(11) NOT NULL,
  `data_json` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reason_codes`
--

DROP TABLE IF EXISTS `reason_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reason_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_flow_id` int(11) DEFAULT NULL,
  `recording_level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `sequence` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_filter_steps`
--

DROP TABLE IF EXISTS `report_filter_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_filter_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_flow_id` int(11) DEFAULT NULL,
  `station_step_id` int(11) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `duration_days` int(11) DEFAULT NULL,
  `predecessors` varchar(255) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rework_infos`
--

DROP TABLE IF EXISTS `rework_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rework_infos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `step_initiating_rework` int(11) DEFAULT NULL,
  `rework_start_step` int(11) DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `move_original_record_back_to_step` int(11) DEFAULT NULL,
  `reset_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `new_rework_id` int(11) DEFAULT NULL,
  `new_rework_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `note` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `station_steps`
--

DROP TABLE IF EXISTS `station_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_station_id` int(11) DEFAULT NULL,
  `step_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recording_level` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `duration_days` int(11) DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `duration_multiplier` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_visible` tinyint(1) DEFAULT NULL,
  `can_be_turned_off` tinyint(1) DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_station_steps_on_workflow_station_id` (`workflow_station_id`),
  KEY `index_station_steps_on_workflow_station_id_and_recording_level` (`workflow_station_id`,`recording_level`(255))
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recording_level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_statuses_on_work_flow_id_and_recording_level` (`work_flow_id`,`recording_level`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timestamp_logs`
--

DROP TABLE IF EXISTS `timestamp_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timestamp_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `workflow_live_step_id` int(11) DEFAULT NULL,
  `eta` datetime DEFAULT NULL,
  `actual_confirmation` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `no_of_comp` int(11) DEFAULT NULL,
  `no_of_lang` int(11) DEFAULT NULL,
  `work_flow_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12800 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transitions`
--

DROP TABLE IF EXISTS `transitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station_step_id` int(11) DEFAULT NULL,
  `previous_station_step_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_transitions_on_station_step_id` (`station_step_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `failed_attempts` int(11) NOT NULL DEFAULT '0',
  `unlock_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_unlock_token` (`unlock_token`),
  KEY `index_users_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_flows`
--

DROP TABLE IF EXISTS `work_flows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `L1` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `L2` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `L3` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `l1_bu` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `l2_bu` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `l3_bu` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `beginning_of_workday` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `end_of_workday` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hours_per_workday` tinyint(2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `l1_component` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `l2_component` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Y',
  `l3_component` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Y|R',
  `base_duration_days` int(11) DEFAULT '21',
  `translation_days` int(11) DEFAULT '15',
  `horw_days` int(11) DEFAULT '10',
  `l1_bg_color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_in_use` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_work_flows_on_is_active_and_is_in_use` (`is_active`,`is_in_use`),
  KEY `index_work_flows_on_is_in_use` (`is_in_use`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflow_live_steps`
--

DROP TABLE IF EXISTS `workflow_live_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_live_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `station_step_id` int(11) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actual_confirmation` datetime DEFAULT NULL,
  `step_completion` datetime DEFAULT NULL,
  `predecessors` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `eta` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_workflow_live_steps_on_object_id_and_object_type` (`object_id`,`object_type`)
) ENGINE=InnoDB AUTO_INCREMENT=22045 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `workflow_stations`
--

DROP TABLE IF EXISTS `workflow_stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_stations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `work_flow_id` int(11) DEFAULT NULL,
  `station_name` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `is_visible` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_workflow_stations_on_work_flow_id_and_is_visible` (`work_flow_id`,`is_visible`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-20 14:20:54
INSERT INTO schema_migrations (version) VALUES ('20130909170542');

INSERT INTO schema_migrations (version) VALUES ('20130909194719');

INSERT INTO schema_migrations (version) VALUES ('20131020063216');

INSERT INTO schema_migrations (version) VALUES ('20131021224642');

INSERT INTO schema_migrations (version) VALUES ('20140204233100');

INSERT INTO schema_migrations (version) VALUES ('20140204233952');

INSERT INTO schema_migrations (version) VALUES ('20160715080558');

INSERT INTO schema_migrations (version) VALUES ('20160715082018');

INSERT INTO schema_migrations (version) VALUES ('20160715092823');

INSERT INTO schema_migrations (version) VALUES ('20160715092920');

INSERT INTO schema_migrations (version) VALUES ('20160715093600');

INSERT INTO schema_migrations (version) VALUES ('20160715095406');

INSERT INTO schema_migrations (version) VALUES ('20160715100319');

INSERT INTO schema_migrations (version) VALUES ('20160720082646');

INSERT INTO schema_migrations (version) VALUES ('20160802092605');

INSERT INTO schema_migrations (version) VALUES ('20160802092848');

INSERT INTO schema_migrations (version) VALUES ('20160802093028');

INSERT INTO schema_migrations (version) VALUES ('20160802093656');

INSERT INTO schema_migrations (version) VALUES ('20160802093822');

INSERT INTO schema_migrations (version) VALUES ('20160802093954');

INSERT INTO schema_migrations (version) VALUES ('20160802094105');

INSERT INTO schema_migrations (version) VALUES ('20160802094405');

INSERT INTO schema_migrations (version) VALUES ('20160802115226');

INSERT INTO schema_migrations (version) VALUES ('20160803095033');

INSERT INTO schema_migrations (version) VALUES ('20160805073028');

INSERT INTO schema_migrations (version) VALUES ('20160805075111');

INSERT INTO schema_migrations (version) VALUES ('20160808122417');

INSERT INTO schema_migrations (version) VALUES ('20160808122646');

INSERT INTO schema_migrations (version) VALUES ('20160810064410');

INSERT INTO schema_migrations (version) VALUES ('20160810092412');

INSERT INTO schema_migrations (version) VALUES ('20160811051152');

INSERT INTO schema_migrations (version) VALUES ('20160816125554');

INSERT INTO schema_migrations (version) VALUES ('20160817234328');

INSERT INTO schema_migrations (version) VALUES ('20160818002132');

INSERT INTO schema_migrations (version) VALUES ('20160826040550');

INSERT INTO schema_migrations (version) VALUES ('20160826043520');

INSERT INTO schema_migrations (version) VALUES ('20160901091803');

INSERT INTO schema_migrations (version) VALUES ('20160905021810');

INSERT INTO schema_migrations (version) VALUES ('20160905022634');

INSERT INTO schema_migrations (version) VALUES ('20160905022641');

INSERT INTO schema_migrations (version) VALUES ('20160905061435');

INSERT INTO schema_migrations (version) VALUES ('20160905063215');

INSERT INTO schema_migrations (version) VALUES ('20160908080441');

INSERT INTO schema_migrations (version) VALUES ('20160909065852');

INSERT INTO schema_migrations (version) VALUES ('20160919092537');

INSERT INTO schema_migrations (version) VALUES ('20160922062848');

INSERT INTO schema_migrations (version) VALUES ('20160926070013');

INSERT INTO schema_migrations (version) VALUES ('20160927074414');

INSERT INTO schema_migrations (version) VALUES ('20160927093731');

INSERT INTO schema_migrations (version) VALUES ('20160928054225');

INSERT INTO schema_migrations (version) VALUES ('20160928060517');

INSERT INTO schema_migrations (version) VALUES ('20160930091532');

INSERT INTO schema_migrations (version) VALUES ('20161006110844');

INSERT INTO schema_migrations (version) VALUES ('20161010110939');

INSERT INTO schema_migrations (version) VALUES ('20161013080148');

INSERT INTO schema_migrations (version) VALUES ('20161013093312');

INSERT INTO schema_migrations (version) VALUES ('20161019062502');

INSERT INTO schema_migrations (version) VALUES ('20161020091815');

