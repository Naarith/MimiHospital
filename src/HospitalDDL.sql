use cecs323m39; --switch to database, must call this before being able to add to it

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
    phoneNum    CHAR(20) NOT NULL,
    personID    INT NOT NULL,

    FOREIGN KEY(personID)
    REFERENCES HospitalPerson(personID),

    PRIMARY KEY(phoneNum, personID, phoneType)
);


--subclasses must have the same pk as the parent
CREATE TABLE Employee(
    hiredDate DATE,
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

    CONSTRAINT volunteer_pk
    PRIMARY KEY(personID)
);
CREATE TABLE Skill(
    skillName VARCHAR(40) NOT NULL,
    PRIMARY KEY(skillName)
);
--association table for volunteer and skill, enumerated values(M2M)
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


CREATE TABLE Staff(
    personID   INT NOT NULL,
    jobClass    VARCHAR(50),

    CONSTRAINT staff_fk
    FOREIGN KEY(personID)
    REFERENCES Employee(personID),

    CONSTRAINT staff_pk
    PRIMARY KEY(personID)
);


CREATE TABLE Technician(
    personID   INT NOT NULL,

    CONSTRAINT technician_fk
    FOREIGN KEY(personID)
    REFERENCES Employee(personID),

    CONSTRAINT technician_pk
    PRIMARY KEY(personID)
);
--association table for Technician, Skill
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
    name            VARCHAR(40),
    location        VARCHAR(40) NOT NULL,
    PRIMARY KEY(location)
);
--Association table for technician, lab
CREATE TABLE TechLab(
    location        VARCHAR(10) NOT NULL,
    personID        INT NOT NULL,
    startDate       DATE,

    CONSTRAINT techLabPerson_fk
    FOREIGN KEY(personID)
    REFERENCES Technician(personID),

    CONSTRAINT techLabRoom_fk
    FOREIGN KEY(location)
    REFERENCES Lab(location),

    CONSTRAINT techLab_pk
    PRIMARY KEY(personID, location)
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
CREATE TABLE Visit(
    date        DATE,
    comment     VARCHAR(140),
    visitHrs    VARCHAR(40),
    pagerNum    VARCHAR(20) NOT NULL,

    CONSTRAINT visit_fk
    FOREIGN KEY(pagerNum)
    REFERENCES Physician(pagerNum),

    CONSTRAINT visit_pk
    PRIMARY KEY (pagerNum, visitHrs)
);


CREATE TABLE CareCenter(
    location        VARCHAR(40) NOT NULL,
    centerName      VARCHAR(40) NOT NULL,
    centerID        VARCHAR(40) NOT NULL,

    CONSTRAINT carecenter_pk
    PRIMARY KEY (centerID)
);
CREATE TABLE Bed(
    bedNum          VARCHAR(20) NOT NULL,
    roomNum         VARCHAR(20) NOT NULL,
    centerID        VARCHAR(40) NOT NULL,

    CONSTRAINT bed_fk
    FOREIGN KEY (centerID)
    REFERENCES CareCenter(centerID),
    
    CONSTRAINT bed_pk
    PRIMARY KEY (bedNum, roomNum, centerID)
);
CREATE TABLE Resident(
    admittedDate	DATE,
    lengthStayed	INT, -- can use check() to make sure lengthstayed is within a given range?
    personID            INT NOT NULL,
    ID                  INT NOT NULL,
    centerID            VARCHAR(40) NOT NULL,
    bedNum              VARCHAR(20),
    roomNum             VARCHAR(20),

    CONSTRAINT resident_fk
    FOREIGN KEY(personID)
    REFERENCES Patient(personID),
    
    CONSTRAINT residentcenter_fk
    FOREIGN KEY(centerID)
    REFERENCES CareCenter(centerID),

    CONSTRAINT residentbedroom_fk
    FOREIGN KEY(bedNum, roomNum)
    REFERENCES Bed(bedNum, roomNum),

--     CONSTRAINT residentroom_fk
--     FOREIGN KEY(roomNum)
--     REFERENCES Bed(roomNum),

    CONSTRAINT resident_pk
    PRIMARY KEY (personID, ID)
);


CREATE TABLE Nurse(
    certificate VARCHAR(40),
    personID    INT NOT NULL,
    centerID    VARCHAR(40) NOT NULL,

    CONSTRAINT nurseCenter_fk
    FOREIGN KEY(centerID)
    REFERENCES CareCenter(centerID),

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
CREATE TABLE HeadNurse(
    personID        INT NOT NULL,
    assigned        BIT,

    CONSTRAINT headNurse_fk
    FOREIGN KEY (personID)
    REFERENCES RN(personID),

    CONSTRAINT headNurse_pk
    PRIMARY KEY (personID)
);


-- DROP TABLE Staff;
-- 
-- DROP TABLE Resident;
-- DROP TABLE Bed;
-- DROP TABLE HeadNurse;
-- DROP TABLE RN;
-- DROP TABLE Timecard;
-- DROP TABLE Nurse;
-- DROP TABLE CareCenter;
-- 
-- DROP TABLE Visit;
-- DROP TABLE Outpatient;
-- DROP TABLE Patient;
-- 
-- DROP TABLE TechLab;
-- DROP TABLE TechnicianSkill;
-- DROP TABLE Lab;
-- DROP TABLE Technician;
-- 
-- 
-- DROP TABLE PhysicianSpecialty;
-- DROP TABLE Physician;
-- DROP TABLE Specialty;
-- 
-- DROP TABLE VolunteerSkill;
-- DROP TABLE Volunteer;
-- 
-- DROP TABLE Skill;
-- 
-- DROP TABLE Employee;
-- 
-- DROP TABLE PersonPhone;
-- DROP TABLE HospitalPerson;