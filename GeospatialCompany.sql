
DROP TABLE IF EXISTS `offices`;
DROP TABLE IF EXISTS `employees`;
DROP TABLE IF EXISTS `certifications`;
DROP TABLE IF EXISTS `project_data`;
DROP TABLE IF EXISTS `employee_cert`;
DROP TABLE IF EXISTS `works_on`;



-- Create a table called offices with the following properties:
-- city - varchar  with a max of 255 char, which is the primary key, cannot be null
-- state - a varchar with a maximum length of 255 characters, cannot be null

CREATE TABLE `offices` (
`id` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
`city` varchar(255) NOT NULL,
`state` varchar(255) NOT NULL
) ENGINE=InnoDB;


-- Create a table called employee with the following properties:
-- id - an auto incrementing integer which is the primary key
-- first_name - a varchar of maximum length 255, cannot be null
-- last_name - a varchar of maximum length 255, cannot be null
-- job_title - a varchar of max length 255, cannot be null
-- department - a varchar of max length 255, cannot be null
-- salary - int
-- office - foreign key to office.city
-- the combination of the first_name and last_name must be unique in this table

CREATE TABLE `employees` (
`id` int PRIMARY KEY AUTO_INCREMENT,
`first_name` varchar(255) NOT NULL,
`last_name` varchar(255) NOT NULL,
`job_title` varchar(255) NOT NULL,
`department` varchar(255) NOT NULL,
`salary` int,
`office` int NOT NULL,
CONSTRAINT `employees_fkc` FOREIGN KEY(`office`) REFERENCES `offices`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
UNIQUE KEY(`first_name`,`last_name`)
) ENGINE=InnoDB;


-- Create a table called certifications with the following properties:
-- id - an auto incrementing integer which is the primary key
-- cert_name varchar of max 255, cannot be null

CREATE TABLE `certifications` (
`id` int PRIMARY KEY AUTO_INCREMENT,
`cert_name` varchar(255) NOT NULL
) ENGINE=InnoDB;



-- Create a table called project_data with the following properties
-- id -an auto incrementing integer which is the primary key
-- client - varchar 255, cannot be null
-- request_date - date, cannot be null
-- due_date -date
-- data_type -varchar 255
-- coordinate_system -varchar 255
-- budget - int
-- hours_charged -int
-- cert_required -foreign key to cert.id

CREATE TABLE `project_data` (
`id` int PRIMARY KEY AUTO_INCREMENT,
`client` varchar(255) NOT NULL,
`request_date` date NOT NULL,
`due_date` date NOT NULL,
`data_type` varchar(255) NOT NULL,
`coordinate_system` varchar(255),
`budget` int,
`hours_charged` int,
`cert_required` int,
CONSTRAINT `cert_required` FOREIGN KEY(`cert_required`) REFERENCES `certifications`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;






-- Create a table called works_on
-- eid- foreign key to employee
-- proj_id -foreign key to project

CREATE TABLE `works_on` (
`eid` int NOT NULL,
`proj_id` int NOT NULL,
PRIMARY KEY(eid, proj_id),
CONSTRAINT `works_on_fkeid` FOREIGN KEY(`eid`) REFERENCES `employees`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `works_on_fkprojid` FOREIGN KEY(`proj_id`) REFERENCES `project_data`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create a table called employee_cert
-- eid -foreign key to employee.id
-- cid -foreign key to certification id

CREATE TABLE `employee_cert` (
`eid` int NOT NULL,
`cid` int NOT NULL,
PRIMARY KEY(eid,cid),
CONSTRAINT `eid_ibfk` FOREIGN KEY(`eid`) REFERENCES `employees`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `cid_ibfk` FOREIGN KEY(`cid`) REFERENCES `certifications`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;



-- insert the offices data

INSERT INTO offices (city,state) VALUES
("Lakeland","Florida"),
("Knoxville","Tennessee"),
("Madison","Wisconsin"),
("Atlanta","Georgia");






-- insert the employees data

INSERT INTO employees (first_name,last_name,job_title,department,salary,office) VALUES
("Michael","Scott","Manager","GIS",100000 ,(SELECT id FROM offices WHERE city="Lakeland" )),
("Jim","Halpert","Manager","Survey",95000 ,(SELECT id FROM offices WHERE city="Knoxville" )),
("Pam","Beesly","Manager","Lidar",95000 ,(SELECT id FROM offices WHERE city="Madison" )),
("Dwight","Schrute","Manager","Photogrammetry",95000 ,(SELECT id FROM offices WHERE city="Atlanta" )),
("Tracy","Jordan","Secretary","Photogrammetry",45000 ,(SELECT id FROM offices WHERE city="Atlanta" )),
("Dwight","Yoakam","Secretary","Lidar",40000 ,(SELECT id FROM offices WHERE city="Madison" )),
("Obi-Wan","Kenobi","Secretary","Survey",43000 ,(SELECT id FROM offices WHERE city="Knoxville" )),
("Eugene","Mirman","Secretary","GIS",46000 ,(SELECT id FROM offices WHERE city="Lakeland" )),
("David","White","GIS Developer","GIS",95000 ,(SELECT id FROM offices WHERE city="Lakeland" )),
("Eric","Presnell","Surveyor","Survey",60000 ,(SELECT id FROM offices WHERE city="Lakeland" )),
("Bob","Smith","Lidar Analyst","Lidar",48000 ,(SELECT id FROM offices WHERE city="Lakeland" )),
("Kelsey","Opry","GIS Technician","GIS",55000 ,(SELECT id FROM offices WHERE city="Knoxville" )),
("Katie","Gassaway","GIS Developer","GIS",95000 ,(SELECT id FROM offices WHERE city="Knoxville" )),
("Lisa","Cochran","Surveyor","Survey",60000 ,(SELECT id FROM offices WHERE city="Knoxville" )),
("Meredith","Curtis","Lidar Analyst","Lidar",53000 ,(SELECT id FROM offices WHERE city="Madison" )),
("Liz","Maltby","Photogrammetrist","Photogrammetry",56000 ,(SELECT id FROM offices WHERE city="Madison" )),
("Bob","Kovalcheck","Surveyor","Survey",48000 ,(SELECT id FROM offices WHERE city="Madison" )),
("Emily","Camp","GIS Technician","GIS",58000 ,(SELECT id FROM offices WHERE city="Atlanta" )),
("Cindy","Frohlich","Photogrammetrist","Photogrammetry",52000 ,(SELECT id FROM offices WHERE city="Atlanta" )),
("Matt","Garcia","Surveyor", "Survey",58000 ,(SELECT id FROM offices WHERE city="Atlanta" ));


-- Insert the Certifications data

INSERT INTO certifications (cert_name) VALUES ("GISP"),("Licensed Surveyor"),("Licensed Photogrammetrist");

-- Insert the employee_cert data
-- eid -foreign key to employees.id
-- cid -foreign key to certifications.id

INSERT INTO employee_cert (eid, cid) VALUES 
((SELECT id FROM employees WHERE first_name="David" AND last_name="White"),(SELECT id from certifications WHERE cert_name="GISP")),
((SELECT id FROM employees WHERE first_name="David" AND last_name="White"),(SELECT id from certifications WHERE cert_name="Licensed Photogrammetrist")),
((SELECT id FROM employees WHERE first_name="Eric" AND last_name="Presnell"),(SELECT id from certifications WHERE cert_name="Licensed Surveyor")),
((SELECT id FROM employees WHERE first_name="Katie" AND last_name="Gassaway"),(SELECT id from certifications WHERE cert_name="GISP")), 
((SELECT id FROM employees WHERE first_name="Katie" AND last_name="Gassaway"),(SELECT id from certifications WHERE cert_name="Licensed Surveyor")), 
((SELECT id FROM employees WHERE first_name="Lisa" AND last_name="Cochran"),(SELECT id from certifications WHERE cert_name="Licensed Surveyor")), 
((SELECT id FROM employees WHERE first_name="Liz" AND last_name="Maltby"),(SELECT id from certifications WHERE cert_name="Licensed Photogrammetrist")),
((SELECT id FROM employees WHERE first_name="Cindy" AND last_name="Frohlich"),(SELECT id from certifications WHERE cert_name="Licensed Photogrammetrist"));


-- INSERT the project_data 
-- id -an auto incrementing integer which is the primary key
-- client - varchar 255, cannot be null
-- request_date - date, cannot be null
-- due_date -date
-- data_type -varchar 255
-- coordinate_system -varchar 255
-- budget - int
-- hours_charged -int
-- cert_required -foreign key to cert.id
INSERT INTO project_data (client, request_date, due_date, data_type, coordinate_system, budget, hours_charged, cert_required) VALUES
("USGS","2016-11-03", "2017-07-01", "DEM", "UTM NAD 83", 40000, 60, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("University of Tennessee","2017-01-15", "2017-06-15", "Lidar", "TN State Plane NAD 83", 60000, 25, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("Tennessee Valley Authority","2016-12-10", "2017-04-10", "Orthophotography", "TN State Plane NAD 83", 35000, 10, (SELECT id FROM certifications WHERE cert_name= "Licensed Photogrammetrist")),
("State of Florida","2017-02-20", "2017-08-19", "Lidar", "Geographic Coordinate System NAD 83", 80000, 66, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("US Army","2017-03-01", "2017-09-01", "Orthophotography", "UTM NAD 83", 100000, 80, (SELECT id FROM certifications WHERE cert_name= "Licensed Photogrammetrist")),
("Duke Energy","2014-08-22", "2015-09-01", "Planimetric Mapping", "State Plane NAD 83", 75000, 200, (SELECT id FROM certifications WHERE cert_name= "Licensed Photogrammetrist")),
("Mosaic Fertilizer","2017-05-01", "2018-03-01", "Boundary Survey", "State Plane NAD 83", 55000, 25, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("SWFWMD","2013-05-01", "2013-06-01", "Boundary Survey", "State Plane NAD 83", 5000, 10, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("Department of Transportation","2016-09-01", "2018-12-25", "Boundary Survey", "State Plane NAD 83", 55400, 90, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("Tennessee Valley Authority","2017-4-01", "2018-03-01", "Boundary Survey", "State Plane NAD 83", 10000, 25, (SELECT id FROM certifications WHERE cert_name= "Licensed Surveyor")),
("Dominion","2017-06-01", "2018-01-01", "Land-use map", "State Plane NAD 83", 45000, 100, (SELECT id FROM certifications WHERE cert_name= "GISP")),
("Mosaic Fertilizer","2017-05-02", "2018-05-01", "Vegetation map", "State Plane NAD 83", 59000, 85, (SELECT id FROM certifications WHERE cert_name= "GISP")),
("Mosaic Fertilizer","2017-06-01", "2018-05-01", "Flood Mapping", "State Plane NAD 83", 79000, 150, NULL);

-- insert the works_on data

INSERT INTO works_on (eid,proj_id) VALUES
((SELECT id FROM employees WHERE first_name="Bob" and last_name="Smith"),(SELECT id FROM project_data WHERE client ="USGS" AND request_date="2016-11-03")),
((SELECT id FROM employees WHERE first_name="Eric" and last_name="Presnell"),(SELECT id FROM project_data WHERE client ="USGS" AND request_date="2016-11-03")),
((SELECT id FROM employees WHERE first_name="Meredith" and last_name="Curtis"),(SELECT id FROM project_data WHERE client ="University of Tennessee" AND request_date="2017-01-15")),
((SELECT id FROM employees WHERE first_name="Lisa" and last_name="Cochran"),(SELECT id FROM project_data WHERE client ="University of Tennessee" AND request_date="2017-01-15")),
((SELECT id FROM employees WHERE first_name="Liz" and last_name="Maltby"),(SELECT id FROM project_data WHERE client ="Tennessee Valley Authority" AND request_date="2016-12-10")),
((SELECT id FROM employees WHERE first_name="Katie" and last_name="Gassaway"),(SELECT id FROM project_data WHERE client ="State of Florida" AND request_date="2017-02-20")),
((SELECT id FROM employees WHERE first_name="Bob" and last_name="Smith"),(SELECT id FROM project_data WHERE client ="State of Florida" AND request_date="2017-02-20")),
((SELECT id FROM employees WHERE first_name="Cindy" and last_name="Frohlich"),(SELECT id FROM project_data WHERE client ="US Army" AND request_date="2017-03-01")),
((SELECT id FROM employees WHERE first_name="David" and last_name="White"),(SELECT id FROM project_data WHERE client ="Duke Energy" AND request_date="2014-08-22")),
((SELECT id FROM employees WHERE first_name="Matt" and last_name="Garcia"),(SELECT id FROM project_data WHERE client ="Mosaic Fertilizer" AND request_date="2017-05-01")),
((SELECT id FROM employees WHERE first_name="Bob" and last_name="Kovalcheck"),(SELECT id FROM project_data WHERE client ="Mosaic Fertilizer" AND request_date="2017-05-01")),
((SELECT id FROM employees WHERE first_name="Kelsey" and last_name="Opry"),(SELECT id FROM project_data WHERE client ="Dominion" AND request_date="2017-06-01")),
((SELECT id FROM employees WHERE first_name="Katie" and last_name="Gassaway"),(SELECT id FROM project_data WHERE client ="Dominion" AND request_date="2017-06-01")),
((SELECT id FROM employees WHERE first_name="David" and last_name="White"),(SELECT id FROM project_data WHERE client ="Mosaic Fertilizer" AND request_date="2017-05-02")),
((SELECT id FROM employees WHERE first_name="Emily" and last_name="Camp"),(SELECT id FROM project_data WHERE client ="Mosaic Fertilizer" AND request_date="2017-06-01")),
((SELECT id FROM employees WHERE first_name="Eric" and last_name="Presnell"),(SELECT id FROM project_data WHERE client ="SWFWMD" AND request_date="2013-05-01")),
((SELECT id FROM employees WHERE first_name="Lisa" and last_name="Cochran"),(SELECT id FROM project_data WHERE client ="Department of Transportation" AND request_date="2016-09-01")),
((SELECT id FROM employees WHERE first_name="Bob" and last_name="Kovalcheck"),(SELECT id FROM project_data WHERE client ="Tennessee Valley Authority" AND request_date="2017-4-01")),
((SELECT id FROM employees WHERE first_name="Lisa" and last_name="Cochran"),(SELECT id FROM project_data WHERE client ="Tennessee Valley Authority" AND request_date="2017-4-01"));




