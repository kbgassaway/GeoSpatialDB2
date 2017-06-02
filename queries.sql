SELECT first_name, last_name, job_title, city, cert_name FROM employees e
LEFT JOIN offices o ON o.id = e.office
LEFT JOIN employee_cert ec ON ec.eid=e.id
LEFT JOIN certifications c ON c.id=ec.cid;




--Select the employee data and the city the employee is associated with
SELECT first_name, last_name, job_title, department, salary, city FROM employees e LEFT JOIN offices o ON e.office= o.id; 



INSERT INTO employees(`first_name`,`last_name`,`job_title`,`department`,`salary`,`office`) VALUES ("Ralph","Wiggim","Photogrammetrist","Photogrammetry",25000,(Select id from offices where city ="lakeland"));

SELECT first_name, last_name FROM employees 
where id= (SELECT eid from works_on w
INNER JOIN project_data pd on pd.id=w.proj_id
WHERE client='USGS' AND request_date='2016-11-03' group by id); 

DELETE FROM employees 
where id= (SELECT eid from works_on w
INNER JOIN project_data pd on pd.id=w.proj_id
WHERE client='USGS' AND request_date='2016-11-03' group by id); 