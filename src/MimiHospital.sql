show databases; -- show all databases
use cecs323m39; --switch to database, must call this before being able to add to it
show tables; --show all tables in current database

CREATE TABLE HospitalPerson(
    firstName VARCHAR(40),
    lastName VARCHAR(40),
    address VARCHAR(40),
    phone VARCHAR(10), -- needs to be a subkey later
    personID INT NOT NULL, --NOT NULL not necessarily needed but makes it clear what the pk is
    CONSTRAINT person_pk -- don't need CONSTRAINT, it is implied when using PRIMARY KEY
    PRIMARY KEY(personID) -- primary keys are always indexed in mySQL
);

--subclasses must have the same pk as the parent
CREATE TABLE Employee(
    hiredDate TIMESTAMP,
    vacaTime INT,
    employeeID INT NOT NULL,
    personID INT NOT NULL, --parent pk needs to be a part of the child subclass
    -- constraint is implied for foreign key as well, if no constraint var is given, mySQL will generate one for you
    CONSTRAINT employee_fk 
    FOREIGN KEY (personID)
    REFERENCES HospitalPerson(personID), 

    PRIMARY KEY(employeeID, personID)
);

CREATE TABLE Volunteer(
    personID INT NOT NULL,
    CONSTRAINT volunteer_fk
    FOREIGN KEY person_pk(personID) REFERENCES HospitalPerson(personID),

    PRIMARY KEY(personID)
);

CREATE TABLE Skill(
    skillName VARCHAR(40) NOT NULL,
    PRIMARY KEY(skillName)
);

--association table for volunteer and skill, enumerated values
CREATE TABLE VolunteerSkill(
    personID INT NOT NULL,
    skillName VARCHAR(40) NOT NULL,
    CONSTRAINT v_fk
    FOREIGN KEY (personID)
    REFERENCES Volunteer(personID),

    CONSTRAINT s_fk
    FOREIGN KEY (skillName) -- if neither constraint/index name is supplied the column attr will be used to create an index
    REFERENCES Skill(skillName),

    PRIMARY KEY(personID, skillName)
);

CREATE TABLE Physician(
    pagerNum        INT NOT NULL,
    personID        INT NOT NULL,

    FOREIGN KEY (personID)
    REFERENCES HospitalPerson(personID),

    PRIMARY KEY(pagerNum)
);

CREATE TABLE Specialty(
    specialtyName   VARCHAR(40) NOT NULL,
    PRIMARY KEY (specialtyName)
);

CREATE TABLE PhysicianSpecialty(
    pagerNum        INT NOT NULL,
    specialtyName   VARCHAR(40) NOT NULL,
    FOREIGN KEY (pagerNum)
    REFERENCES Physician(pagerNum),

    FOREIGN KEY (specialtyName)
    REFERENCES Specialty(specialtyName),

    PRIMARY KEY(pagerNum, specialtyName)
);

CREATE TABLE Patient(
    ID          VARCHAR(40) NOT NULL,
    personID    INT NOT NULL,
    contactDate	DATE,
    FOREIGN KEY (personID)
    REFERENCES HospitalPerson(personID),
    
    PRIMARY KEY(ID)
);
-- 
-- 
-- CREATE TABLE resident(
--   admittedDate	DATE,
--   lengthStayed	VARCHAR(40), -- can use check() to make sure lengthstayed is within a given range?
--   CONSTRAINT fk_constraint
--   FOREIGN KEY fk_personID(personID)
--   REFERENCES patient (personID)
-- );
-- 
-- CREATE TABLE outpatient(
--   CONSTRAINT fk_outpatient
--   FOREIGN KEY pk_patient(personID)
--   REFERENCES patient (personID)-- make pk
-- );
-- 
-- CREATE TABLE bed(
--   bedNum	VARCHAR(20),
--   roomNum	VARCHAR(20)
-- );
-- 
-- CREATE TABLE visit(
--   date    VARCHAR(40) NOT NULL,	-- DATE DATA TYPE
--   comment VARCHAR(40)         ,
--   visitHrs   VARCHAR(40)         ,   
--   CONSTRAINT recordingStudio PRIMARY KEY (stName)
-- );

SELECT * FROM HospitalPerson;


--DROP FOR DEBUG PURPOSES
DROP TABLE HospitalPerson;

DROP TABLE Employee;

DROP TABLE Volunteer;
DROP TABLE VolunteerSkill;
DROP TABLE Skill;

DROP TABLE Physician;
DROP TABLE PhysicianSpecialty;
DROP TABLE Specialty;