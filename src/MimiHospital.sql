show databases; -- show all databases
use cecs323m39; --switch to database, must call this before being able to add to it
show tables; --show all tables in current database

CREATE TABLE HospitalPerson(
    firstName   VARCHAR(40),
    lastName    VARCHAR(40),
    address     VARCHAR(40),
    personID    INT NOT NULL, --NOT NULL not necessarily needed but makes it clear what the pk is
    CONSTRAINT person_pk -- don't need CONSTRAINT, it is implied when using PRIMARY KEY
    PRIMARY KEY(personID) -- primary keys are always indexed in mySQL
);

CREATE TABLE PersonPhone(
    phoneType   VARCHAR(10) NOT NULL, 
    phoneNum    CHAR(10) NOT NULL,
    personID    INT NOT NULL,

    FOREIGN KEY(personID)
    REFERENCES HospitalPerson(personID),

    PRIMARY KEY(phoneNum, personID, phoneType)
);

--subclasses must have the same pk as the parent
CREATE TABLE Employee(
    hiredDate TIMESTAMP,
    vacaTime INT,
    personID INT NOT NULL, --parent pk needs to be a part of the child subclass
    -- constraint is implied for foreign key as well, if no constraint var is given, mySQL will generate one for you
    CONSTRAINT employee_fk 
    FOREIGN KEY (personID)
    REFERENCES HospitalPerson(personID), 

    PRIMARY KEY(personID)
);

CREATE TABLE Volunteer(
    personID INT NOT NULL,
    CONSTRAINT volunteer_fk
    FOREIGN KEY(personID) 
    REFERENCES HospitalPerson(personID),

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
    pagerNum        VARCHAR(20) NOT NULL,
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
    pagerNum        VARCHAR(20) NOT NULL,
    specialtyName   VARCHAR(40) NOT NULL,
    FOREIGN KEY (pagerNum)
    REFERENCES Physician(pagerNum),

    FOREIGN KEY (specialtyName)
    REFERENCES Specialty(specialtyName),

    PRIMARY KEY(pagerNum, specialtyName)
);

CREATE TABLE Nurse(
    certificate VARCHAR(40) NOT NULL,
    personID    INT NOT NULL,

    CONSTRAINT nurse_fk
    FOREIGN KEY(personID)
    REFERENCES Employee(personID),

    CONSTRAINT nurse_pk
    PRIMARY KEY(personID)
);

CREATE TABLE Timecard(
    date        DATE NOT NULL,
    hrsWorked   INT,
    personID    INT NOT NULL,

    CONSTRAINT timecard_fk
    FOREIGN KEY(personID)
    REFERENCES Nurse(personID),

    CONSTRAINT timecard_pk
    PRIMARY KEY(personID, date)
);

CREATE TABLE RN(
    personID        INT NOT NULL,
    licenseLoc      VARCHAR(40),
    dateReceived    DATE,

    CONSTRAINT rn_fk
    FOREIGN KEY(personID)
    REFERENCES Nurse(personID),

    CONSTRAINT rn_pk
    PRIMARY KEY(personID)
);

CREATE TABLE CareCenter(
    location        VARCHAR(40) NOT NULL,
    name            VARCHAR(40),
    personID        INT NOT NULL,

    CONSTRAINT carecenter_fk
    FOREIGN KEY (personID)
    REFERENCES RN(personID),

    CONSTRAINT carecenter_pk
    PRIMARY KEY (location, personID)
);

ALTER TABLE Nurse
    ADD location VARCHAR(40) NOT NULL,
    ADD CONSTRAINT nurseLoc_fk
    FOREIGN KEY(location)
    REFERENCES CareCenter(location);

CREATE TABLE Technician(
    personID   INT NOT NULL,

    CONSTRAINT technician_fk
    FOREIGN KEY(personID)
    REFERENCES Employee(personID),

    CONSTRAINT technician_pk
    PRIMARY KEY(personID)
);

CREATE TABLE TechnicianSkill(
    personID    INT NOT NULL, 
    skillName   VARCHAR(40) NOT NULL,

    CONSTRAINT techPers_fk
    FOREIGN KEY(personID)
    REFERENCES Technician(personID),
    
    CONSTRAINT techskill_fk
    FOREIGN KEY(skillName)
    REFERENCES Skill(skillName),

    CONSTRAINT techSkill_pk
    PRIMARY KEY(personID, skillName)
);

CREATE TABLE Lab(
    name        VARCHAR(40),
    location        VARCHAR(40) NOT NULL,
    PRIMARY KEY(location)
);

CREATE TABLE TechLab(
    location        VARCHAR(10) NOT NULL,
    personID    INT NOT NULL,

    CONSTRAINT techLabPerson_fk
    FOREIGN KEY(personID)
    REFERENCES Technician(personID),
    
    CONSTRAINT techLabRoom_fk
    FOREIGN KEY(location)
    REFERENCES Lab(location),

    CONSTRAINT techLab_pk
    PRIMARY KEY(personID, location)
);   

CREATE TABLE Staff(
    personID   INT NOT NULL,

    CONSTRAINT staff_fk
    FOREIGN KEY(personID)
    REFERENCES Employee(personID),

    CONSTRAINT staff_pk
    PRIMARY KEY(personID)
);

CREATE TABLE Patient(
    ID          INT NOT NULL,
    personID    INT NOT NULL,
    pagerNum    VARCHAR(20),
    contactDate	DATE,

    FOREIGN KEY(pagerNum)
    REFERENCES Physician(pagerNum),

    FOREIGN KEY (personID)
    REFERENCES HospitalPerson(personID),
    
    CONSTRAINT patient_pk
    PRIMARY KEY(ID, personID)
);


CREATE TABLE Resident(
    admittedDate	DATE,
    lengthStayed	INT, -- can use check() to make sure lengthstayed is within a given range?
    personID            INT NOT NULL,
    ID                  INT NOT NULL, 
    
    CONSTRAINT resident_fk
    FOREIGN KEY(personID)
    REFERENCES Patient(personID),

    CONSTRAINT resident_pk
    PRIMARY KEY (personID, ID)
);

CREATE TABLE Outpatient(
    personID        INT NOT NULL,
    ID              INT NOT NULL,
    
    CONSTRAINT outpatient_fk
    FOREIGN KEY (personID)
    REFERENCES Patient(personID),

    CONSTRAINT outpatientPatient_fk
    FOREIGN KEY(ID)
    REFERENCES Patient(ID),

    CONSTRAINT outpatient_pk
    PRIMARY KEY (personID, ID)
);

CREATE TABLE Bed(
    bedNum          VARCHAR(20) NOT NULL,
    roomNum         VARCHAR(20) NOT NULL,
    location        VARCHAR(10) NOT NULL,      
    CONSTRAINT bedCenter_fk
    FOREIGN KEY (location)
    REFERENCES CareCenter(location),
    
    CONSTRAINT bed_pk
    PRIMARY KEY (bedNum, roomNum, location)
);

CREATE TABLE Visit(
    date        DATE NOT NULL,
    comment     VARCHAR(140),
    visitHrs    VARCHAR(40),
    pagerNum    VARCHAR(20) NOT NULL,

    CONSTRAINT visit_fk
    FOREIGN KEY(pagerNum)
    REFERENCES Physician(pagerNum),

    CONSTRAINT visit_pk
    PRIMARY KEY (pagerNum, visitHrs)
);




SELECT * FROM HospitalPerson;


--DROP FOR DEBUG PURPOSES
DROP TABLE HospitalPerson;
DROP TABLE PersonPhone;

DROP TABLE Employee;

DROP TABLE Nurse;
DROP TABLE RN;
DROP TABLE Timecard;
DROP TABLE CareCenter;
-- have to drop the foreign key before being able to drop RN and Nurse
ALTER TABLE Nurse
    DROP FOREIGN KEY nurseLoc_fk;
ALTER TABLE Nurse
    DROP location;
 

DROP TABLE Volunteer;
DROP TABLE Skill;
DROP TABLE VolunteerSkill;

DROP TABLE Physician;
DROP TABLE Specialty;
DROP TABLE PhysicianSpecialty;
DROP TABLE Visit;

DROP TABLE Patient;
DROP TABLE Resident;
DROP TABLE Outpatient;
DROP TABLE Bed;

DROP TABLE Technician;
DROP TABLE TechnicianSkill;
DROP TABLE Lab;
DROP TABLE TechLab;

DROP TABLE Staff;