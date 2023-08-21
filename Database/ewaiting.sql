-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 05, 2023 at 06:55 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ewaiting`
--

-- --------------------------------------------------------

--
-- Table structure for table `alltickets`
--

CREATE TABLE `alltickets` (
  `ticketid` varchar(150) NOT NULL,
  `businessName` varchar(255) NOT NULL,
  `businesstype` varchar(255) NOT NULL,
  `userid` varchar(150) NOT NULL,
  `username` varchar(250) NOT NULL,
  `serviceid` varchar(150) NOT NULL,
  `generationtime` varchar(70) DEFAULT NULL,
  `status` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `alltickets`
--

INSERT INTO `alltickets` (`ticketid`, `businessName`, `businesstype`, `userid`, `username`, `serviceid`, `generationtime`, `status`) VALUES
('1102', 'King Abdulaziz Hospital', 'Hospital', '12', 'Abdullah', '3333', '2023-08-05T21:49:41.057', '1'),
('2526', 'Ohud Hospital', 'Hospital', '12', 'Abdullah', '5555', '2023-08-05T21:49:44.406', '0'),
('2650', 'Riyad Bank', 'Bank', '12', 'Abdullah', '4', '2023-08-05T21:49:50.490', '0'),
('2994', 'Ministry of Health', 'Ministry', '12', 'Abdullah', '363', '2023-08-05T21:49:56.177', '0'),
('4560', 'King Abdulaziz Hospital', 'Hospital', '121', 'huz', '3333', '2023-08-05T21:51:35.847', '0'),
('4627', 'Ministry of Finance', 'Ministry', '121', 'huz', '212', '2023-08-05T21:51:43.779', '0'),
('6441', 'Ministry of Interior', 'Ministry', '12', 'Abdullah', '121', '2023-08-05T21:50:00.019', '2');

-- --------------------------------------------------------

--
-- Table structure for table `companylogin`
--

CREATE TABLE `companylogin` (
  `businessname` varchar(150) NOT NULL,
  `businesstype` varchar(255) NOT NULL,
  `phone` varchar(150) NOT NULL,
  `password` varchar(150) NOT NULL,
  `address` varchar(399) NOT NULL,
  `slots` varchar(70) NOT NULL DEFAULT '16',
  `loginstatus` varchar(70) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `companylogin`
--

INSERT INTO `companylogin` (`businessname`, `businesstype`, `phone`, `password`, `address`, `slots`, `loginstatus`) VALUES
('National Commercial Bank', 'Bank', '1', 'bank', 'Riyadh, Saudi Arabia', '16', '0'),
('Al-Adwani General Hospital', 'Hospital', '1111', 'Hospital', 'Riyadh, Saudi Arabia', '16', '0'),
('Ministry of Interior', 'Ministry', '121', 'Ministry', 'Riyadh, Saudi Arabia', '16', '0'),
('Al Rajhi Bank', 'Bank', '2', 'bank', 'Riyadh, Saudi Arabia', '16', '0'),
('Ministry of Finance', 'Ministry', '212', 'Ministry', 'Mecca, Saudi Arabia', '16', '0'),
('Ministry of Foreign Affairs', 'Ministry', '215', 'Ministry', 'Medina, Saudi Arabia', '16', '0'),
('Abeer Medical Center', 'Hospital', '2222', 'Hospital', 'Riyadh, Saudi Arabia', '16', '0'),
('Samba Financial Group', 'Bank', '3', 'bank', 'Jeddah, Saudi Arabia', '16', '0'),
('King Abdulaziz Hospital', 'Hospital', '3333', 'Hospital', 'Medina	, Saudi Arabia', '16', '0'),
('Ministry of Health', 'Ministry', '363', 'Ministry', 'Medinah, Saudi Arabia', '16', '0'),
('Riyad Bank', 'Bank', '4', 'bank', 'Riyadh, Saudi Arabia', '16', '0'),
('Ministry of Education', 'Ministry', '434', 'Ministry', 'Riyadh, Saudi Arabia', '16', '0'),
('King Fahad Hospital', 'Hospital', '4444', 'Hospital', 'Tabuk, Saudi Arabia', '16', '0'),
('Banque Saudi Fransi', 'Bank', '5', 'bank', 'Riyadh, Saudi Arabia', '16', '0'),
('Ohud Hospital', 'Hospital', '5555', 'Hospital', 'Medina, Saudi Arabia', '16', '0');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `userid` varchar(150) NOT NULL,
  `body` varchar(500) NOT NULL,
  `status` varchar(70) NOT NULL,
  `randomid` char(36) DEFAULT uuid()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`userid`, `body`, `status`, `randomid`) VALUES
('12', 'this is notification 1', '1', '4b83e6ea-2e43-11ee-8ff5-001a7dda7110'),
('12', 'this is noti 2', '1', '4b83e876-2e43-11ee-8ff5-001a7dda7110'),
('12', 'Ticket Has Been Cancelled Ticket id 1', '1', '4ed296cc-2e46-11ee-8ff5-001a7dda7110'),
('12', 'Ticket Has Been Cancelled Ticket id 1142', '1', '5d44c547-2e46-11ee-8ff5-001a7dda7110'),
('h', 'Ticket Has Been Cancelled Ticket id 1142', '0', '5d4840da-2e46-11ee-8ff5-001a7dda7110'),
('12', 'Ticket Has Been Cancelled Ticket id 1', '1', 'a69c7bb1-2e46-11ee-8ff5-001a7dda7110'),
('201', 'Ticket Has Been Cancelled Ticket id 1', '1', 'a6a0468d-2e46-11ee-8ff5-001a7dda7110'),
('12', 'Ticket Has Been Cancelled Ticket id 6739', '1', '38639639-2ffa-11ee-a70a-c03eba3d10f3'),
('201', 'Ticket Has Been Cancelled Ticket id 6739', '1', '38645218-2ffa-11ee-a70a-c03eba3d10f3'),
('121', 'Ticket Has Been Cancelled Ticket id 3971', '0', '00f34068-305e-11ee-a70a-c03eba3d10f3'),
('201', 'Ticket Has Been Cancelled Ticket id 3971', '1', '00f3ab6f-305e-11ee-a70a-c03eba3d10f3'),
('12', 'Ticket Has Been Cancelled Ticket id 6267', '1', '11125db8-305e-11ee-a70a-c03eba3d10f3'),
('201', 'Ticket Has Been Cancelled Ticket id 6267', '1', '1112e364-305e-11ee-a70a-c03eba3d10f3'),
('12', 'Ticket Has Been Cancelled Ticket id 9815', '1', '3f6aaa36-3205-11ee-a70a-c03eba3d10f3'),
('201', 'Ticket Has Been Cancelled Ticket id 9815', '1', '3f6b3e13-3205-11ee-a70a-c03eba3d10f3'),
('12', 'Ticket Has Been Cancelled Ticket id 8220', '1', '52bdbb3f-33af-11ee-a70a-c03eba3d10f3'),
('201', 'Ticket Has Been Cancelled Ticket id 8220', '1', '52be77ae-33af-11ee-a70a-c03eba3d10f3');

-- --------------------------------------------------------

--
-- Table structure for table `userlogin`
--

CREATE TABLE `userlogin` (
  `fullname` varchar(150) NOT NULL,
  `phone` varchar(150) NOT NULL,
  `password` varchar(150) NOT NULL,
  `loginstatus` varchar(75) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userlogin`
--

INSERT INTO `userlogin` (`fullname`, `phone`, `password`, `loginstatus`) VALUES
('Abdullah', '12', '123', '0'),
('huz', '121', '1', '0'),
('12', '1211', '23', '0'),
('huz', '123', '123', '0'),
('123', '1231232', '123123', '0'),
('123', '12321', '1', '0'),
('huza', '1234', 'pass', '0'),
('aa', '21312', 'f', '0'),
('new user', '431', 'passs', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alltickets`
--
ALTER TABLE `alltickets`
  ADD PRIMARY KEY (`ticketid`);

--
-- Indexes for table `companylogin`
--
ALTER TABLE `companylogin`
  ADD PRIMARY KEY (`phone`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD UNIQUE KEY `randomid` (`randomid`);

--
-- Indexes for table `userlogin`
--
ALTER TABLE `userlogin`
  ADD PRIMARY KEY (`phone`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
