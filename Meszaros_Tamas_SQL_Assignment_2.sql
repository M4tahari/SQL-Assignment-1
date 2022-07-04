-- 1st task

SELECT Artists.Name AS "Artist Name", IFNULL(Albums.Title, 'No album') AS "Album Name" FROM Artists LEFT JOIN Albums
ON Artists.ArtistId = Albums.Artistid ORDER BY Artists.Name;

--2nd task

SELECT Artists.Name AS "Artist Name", Albums.Title AS "Album Name" FROM Artists JOIN Albums
ON Artists.ArtistId = Albums.ArtistId GROUP BY Artists.Name ORDER BY Albums.Title DESC;

--3rd task

SELECT Artists.Name AS "Artist Name" FROM Artists
WHERE Artists.ArtistId NOT IN (SELECT Albums.ArtistId FROM Albums);

--4th task

SELECT Artists.Name AS "Artist Name", Count(Albums.AlbumId) AS "No of Albums" FROM Artists JOIN Albums
ON Artists.ArtistId = Albums.ArtistId GROUP BY Artists.Name ORDER BY Count(Albums.ArtistId) DESC, Artists.Name ASC;

--5th task

SELECT Artists.Name AS "Artist Name", Count(Albums.ArtistId) AS "No of Albums" FROM Artists JOIN Albums
ON Artists.ArtistId = Albums.ArtistId GROUP BY Artists.Name HAVING Count(Albums.AlbumId) > 9  ORDER BY Count(Albums.ArtistId) DESC, Artists.Name ASC;

--6th task

SELECT Artists.Name AS "Artist Name", Count(Albums.ArtistId) AS "No of Albums" FROM Artists JOIN Albums
ON Artists.ArtistId = Albums.ArtistId GROUP BY Artists.Name HAVING Count(Albums.AlbumId) > 9  ORDER BY Count(Albums.ArtistId) DESC LIMIT 3;

--7th task

SELECT Artists.Name AS "Artist Name", Albums.Title AS "Album Title", tracks.Name AS "Track" FROM Artists JOIN Albums JOIN tracks
ON Artists.Name = 'Santana' AND Artists.ArtistId = Albums.ArtistId AND Albums.AlbumId = tracks.AlbumId;

--8th task

CREATE VIEW IF NOT EXISTS ManagerList AS
	SELECT employees.EmployeeId, employees.FirstName || ' ' || employees.LastName AS "Manager_Name", employees.Title 
	FROM employees
	WHERE employees.Title LIKE '%Manager%';
	
SELECT * FROM ManagerList;
SELECT Employees.EmployeeId AS "Employee ID", Employees.FirstName || ' ' || employees.LastName AS "Employee Name", Employees.Title AS "Employee Title", 
employees.ReportsTo AS "Manager ID",
(SELECT ManagerList.Manager_Name FROM ManagerList WHERE employees.ReportsTo = ManagerList.EmployeeId) AS "Manager Name",
(SELECT ManagerList.Title FROM ManagerList WHERE employees.ReportsTo = ManagerList.EmployeeId) AS "Manager Title" FROM Employees
ORDER BY employees.EmployeeId;

--9th task

CREATE VIEW IF NOT EXISTS top_employees AS
	SELECT employees.EmployeeId AS "emp_id", employees.FirstName || ' ' || employees.LastName AS "emp_name",
	COUNT(customers.CustomerId) AS "cust_count" FROM employees, customers WHERE employees.EmployeeId = customers.SupportRepId
	GROUP BY employees.EmployeeId;

SELECT top_employees.emp_name AS "Top Employee", customers.FirstName || ' ' || customers.LastName AS "Customer Name"
FROM top_employees, customers WHERE customers.SupportRepId = top_employees.emp_id 
AND top_employees.cust_count = (SELECT MAX(top_employees.cust_count) FROM top_employees)
ORDER BY "Customer Name";

--10th task

INSERT INTO media_types (Name) VALUES('MP3');

CREATE TRIGGER IF NOT EXISTS prevent_MP3
BEFORE INSERT ON tracks
WHEN NEW.MediaTypeId = 6
BEGIN
	SELECT RAISE(ABORT, 'Insertion into the tracks table was succesfully prevented.');
END;

INSERT INTO tracks (MediaTypeId) VALUES (6);

--11th task

CREATE TABLE IF NOT EXISTS tracks_audit_log (
operation TEXT,
datetime DATETIME,
username TEXT,
old_value TEXT,
new_value TEXT
);

CREATE TRIGGER IF NOT EXISTS track_audit_INSERT
AFTER INSERT ON tracks
BEGIN
	INSERT INTO tracks_audit_log VALUES('INSERT', datetime('now'), 'admin', ' ', NEW.Bytes);
END;

CREATE TRIGGER IF NOT EXISTS track_audit_UPDATE
AFTER UPDATE ON tracks
BEGIN
	INSERT INTO tracks_audit_log VALUES('UPDATE', datetime('now'), 'admin', OLD.Bytes, NEW.Bytes);
END;

CREATE TRIGGER IF NOT EXISTS track_audit_DELETE
AFTER DELETE ON tracks
BEGIN
	INSERT INTO tracks_audit_log VALUES('DELETE', datetime('now'), 'admin', OLD.Bytes, ' ');
END;

INSERT INTO TRACKS (Name, MediaTypeId, Milliseconds, Bytes, UnitPrice) VALUES('Vinushka', 1, 120000, 100000, 1);
SELECT * FROM tracks_audit_log;
UPDATE tracks SET Bytes = 10000 WHERE Bytes = 1000;
SELECT * FROM tracks_audit_log;
DELETE FROM tracks WHERE Bytes = 1000;
SELECT * FROM tracks_audit_log;