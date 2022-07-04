BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Employer" (
	"Employer_ID"	INTEGER,
	"FullName"	TEXT NOT NULL,
	"JoiningDate"	DATETIME,
	"CurrentPosition"	TEXT,
	"Department"	TEXT,
	"AssignedProject"	TEXT,
	PRIMARY KEY("Employer_ID")
);
CREATE TABLE IF NOT EXISTS "Services" (
	"Software_ID"	INTEGER,
	"Name"	TEXT,
	"Category"	TEXT,
	"Size"	REAL,
	"NumberOfInstallments"	INT,
	PRIMARY KEY("Software_ID")
);
CREATE TABLE IF NOT EXISTS "SoftwareRequest" (
	"Employer_ID"	INTEGER,
	"Software_ID"	INTEGER,
	"Request_StartDate"	DATE,
	"Request_CloseDate"	DATE,
	"Status"	TEXT NOT NULL,
	FOREIGN KEY("Employer_ID") REFERENCES "Employer"("Employer_ID"),
	FOREIGN KEY("Software_ID") REFERENCES "Services"("Software_ID"),
	PRIMARY KEY("Employer_ID","Software_ID")
);
INSERT INTO "Employer" VALUES (1,'Jeff Answell','2010-12-10 11:00:00','Communication trainer','HR','Communication with confidence');
INSERT INTO "Employer" VALUES (2,'David Attemborough','2009-10-16 10:00:00','Biologist','Finance','Project Doc');
INSERT INTO "Employer" VALUES (3,'Peter Parker','2017-04-08 14:00:00','Pizza delivery man','Travel','Pizza time');
INSERT INTO "Services" VALUES (101,'Amazon Web Services','A',2000.0,20);
INSERT INTO "Services" VALUES (102,'Visual Studio Code','C',9001.0,7);
INSERT INTO "SoftwareRequest" VALUES (2,101,'2011-01-13','2011-01-16','Valid');
INSERT INTO "SoftwareRequest" VALUES (3,102,'2017-05-02','2017-05-03','Valid');
COMMIT;
