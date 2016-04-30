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

CREATE TABLE Staff(
    personID   INT NOT NULL,
    jobClass    VARCHAR(50),

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
    bedID           INT NOT NULL,
    CONSTRAINT bedCenter_fk
    FOREIGN KEY (location)
    REFERENCES CareCenter(location),

    CONSTRAINT bed_pk
    PRIMARY KEY (bedNum, roomNum, location, bedID)
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

--#################################################
--#################################################
--#################################################
--##################################################

--BEGIN INSERTING VALUES INTO TABLES

--First 10
--Inserting values into HospitalPerson

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Keefe","Bevis","P.O. Box 645, 7391 Taciti St.","5790");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Carolyn","Rashad","9346 Vel Av.","4800");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Raymond","Rachel","613-7523 Tellus Av.","4092");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Xena","Nigel","9682 Sociosqu Ave","9626");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Nicholas","Melanie","794-6884 Nunc. Rd.","3572");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Ifeoma","Omar","4920 Congue Road","2118");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Wade","Tashya","532-3597 Dapibus Ave","5518");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Salvador","Yoshi","261-4878 Neque Ave","6611");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Channing","Leroy","P.O. Box 334, 1030 A St.","3379");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Jenna","Jasper","P.O. Box 184, 5350 Ligula. Road","5111");


--11-20

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Velma","Germaine","Ap #591-1029 Elit Road","6401");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Moses","Aladdin","P.O. Box 306, 3379 A Road","4503");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Kenneth","Sonya","Ap #409-7641 Dolor Ave","4142");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Kato","Sacha","306-6814 Suscipit Av.","2138");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Lesley","Arthur","Ap #702-992 Tortor. St.","1968");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Jacob","Hannah","Ap #210-1923 Tristique Road","1139");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Sophia","Sarah","Ap #901-2871 Maecenas Ave","7471");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Katell","Sara","P.O. Box 453, 7928 Scelerisque Rd.","1236");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Shannon","Vivian","Ap #979-8877 Adipiscing, St.","1778");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Noah","Dylan","8796 Quis Rd.","9968");

--####
--####
--#### inserting values into Volunteer
INSERT INTO Volunteer (`personID`)
    VALUES  (6401),
            (4503),
            (4142),
            (2138),
            (1968),
            (1139),
            (7471),
            (1236),
            (1778),
            (9968);

--####
-- INSERTING VALUE INTO SKILL TABLE
--####
INSERT INTO Skill (`skillName`)
    VALUES ('Timeliness'),
        ('Leadership'),
        ('Organized'),
        ('Flexible');

--####
--INSERTING INTO ASSOCIATION VOLUNTEERSKILL TABLE
--###
INSERT INTO VolunteerSkill (`personID`, `skillName`)
    VALUES (6401, 'Timeliness'),
    (6401, 'Organized'),
    (4503, 'Leadership'),
    (4142, 'Timeliness'),
    (2138, 'Flexible'),
    (1968, 'Leadership'),
    (1139, 'Organized'),
    (7471, 'Flexible'),
    (1236, 'Timeliness'); -- person 1778, 9968 don't have any skills ):


--21-30

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Kirestin","Blossom","P.O. Box 165, 4506 Pellentesque St.","1495");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Evangeline","Prescott","3575 Malesuada St.","1163");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Tanisha","Sybil","134-6137 Elit Rd.","2783");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Azalia","Quyn","Ap #275-5476 Ut, St.","3830");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Vera","Shannon","3066 Nisi St.","7382");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Marshall","Dana","1254 Eu Av.","1940");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Uriel","Anastasia","Ap #472-2681 Sem Rd.","1118");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Hiram","Yeo","Ap #172-3126 Nunc St.","4351");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Timon","Elizabeth","5355 Sit Rd.","2672");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Merrill","Jin","260-3863 Nullam Avenue","9947");


--31-40

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Dahlia","Karyn","3112 At, St.","5312");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Oscar","Jada","P.O. Box 420, 6516 Eu St.","7492");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Echo","Roary","3273 Eu St.","5733");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Rebecca","Jada","P.O. Box 461, 2850 Integer Street","8342");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Joshua","Zelda","4557 Senectus Street","7219");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Wyatt","Jaime","9803 Eget Rd.","9894");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Sylvia","Laura","3117 Vitae Ave","2607");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Mollie","Nissim","P.O. Box 223, 9633 Arcu St.","9723");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Sara","Branden","P.O. Box 516, 1747 Integer Av.","6847");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Leroy","Tyrone","181 Est Avenue","4272");


--41-50

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Sonia","Josephine","6791 Pede Ave","9256");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Abdul","Alvin","P.O. Box 798, 5116 Sagittis Street","6055");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Tamara","Paki","Ap #727-680 Diam Av.","1879");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Karen","Ann","P.O. Box 232, 120 Nulla. Street","8780");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Eagan","Tatiana","7941 Tincidunt, St.","7448");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Brynn","Kiara","Ap #728-2744 Enim. Street","7602");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Maile","Daphne","8829 Varius. Rd.","4051");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Uriel","Natalie","4510 Tellus, Road","6726");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Yuli","Rinah","P.O. Box 971, 2158 Malesuada Rd.","7064");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Addison","Gil","591-2874 Libero St.","9792");

--###############
--Insert into employees

INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("1995-08-30","5","5790");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2000-09-25","1","4800");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2001-12-12","14","4092");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2008-03-30","3","9626");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("1999-07-04","11","3572");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("1998-01-17","12","2118");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("1997-05-21","13","5518");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2006-11-15","6","6611");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2006-11-14","0","3379");
INSERT INTO `Employee` (`hiredDate`,`vacaTime`,`personID`) VALUES ("2012-09-11","3","5111");

--################
--INSERTING VALUES INTO PHYSICIAN (21-30)

INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("345-346-3463","1495");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("453-634-6363","1163" );
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("235-356-5474","2783");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("457-457-6558","3830");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("432-754-2765","7382");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("234-546-8468","1940");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("234-865-4564","1118");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("275-852-5485","4351");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("346-875-2745","2672");
INSERT INTO `Physician` (`pagerNum`,`personID`) VALUES ("857-458-2474","9947");

--#####################
--Insert values into Lab

INSERT INTO `Lab` (`name`,`location`) VALUES ("TechLab","201");
INSERT INTO `Lab` (`name`,`location`) VALUES ("BioLab","204");
INSERT INTO `Lab` (`name`,`location`) VALUES ("Neurolab","305");

--#####################
--INSERTING VALUES FOR Patient
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("0123","5312","345-346-3463","2016-04-29");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("2384","7492","453-634-6363","2015-03-22");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("9433","5733","235-356-5474","2012-06-19");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("3948","8342","457-457-6558","2016-01-16");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("2091","7219","432-754-2765","2015-12-25");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("3485","9894","234-546-8468","2016-04-20");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("6094","2607","234-865-4564","2016-04-01");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("1039","9723","275-852-5485","2015-10-01");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("5920","6847","346-875-2745","2015-12-31");
INSERT INTO `Patient` (`ID`,`personID`,`pagerNum`,`contactDate`) VALUES ("2985","4272","857-458-2474","2016-01-01");

--#####################
-- Insert values for technician
INSERT INTO `Technician` (`personID`) VALUES ("5790");
INSERT INTO `Technician` (`personID`) VALUES ("4800");
INSERT INTO `Technician` (`personID`) VALUES ("4092");

--#####################
--Instert Values into Visit
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2016-04-29","He seems to be recovering well.","3:00pm-4:00pm","345-346-3463");
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2016-02-14","Happy Valentines day!","6:00pm-8:00pm","453-634-6363");
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2015-12-25","Sad Christmas day for her.","8:00am-10:00am","235-356-5474");
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2016-01-11","Leg still fractured badly.","10:00am-11:00am","457-457-6558");
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2016-04-20","Hand still badly burned.","4:00pm-5:00pm","432-754-2765");
INSERT INTO `Visit` (`date`,`comment`,`visitHrs`,`pagerNum`) VALUES ("2016-02-21","Fixed dislocated shoulder.","8:00am-11:00am","234-546-8468");

--#####################
--Insert values into Resident
INSERT INTO `Resident` (`admittedDate`,`lengthStayed`,`personID`,`ID`) VALUES ("2012-09-12","4","5312","0123");
INSERT INTO `Resident` (`admittedDate`,`lengthStayed`,`personID`,`ID`) VALUES ("2013-03-20","6","7492","2384");
INSERT INTO `Resident` (`admittedDate`,`lengthStayed`,`personID`,`ID`) VALUES ("2015-11-12","12","5733","9433");
INSERT INTO `Resident` (`admittedDate`,`lengthStayed`,`personID`,`ID`) VALUES ("2016-06-25","10","8342","3948");
INSERT INTO `Resident` (`admittedDate`,`lengthStayed`,`personID`,`ID`) VALUES ("2002-12-12","15","7219","2091");

--#####################
--Insert values into TechLab
INSERT INTO `TechLab` (`location`,`personID`, `startDate`) VALUES ("201","5790","2014-11-22");

--#####################
--Insert values into Nurse
INSERT INTO `Nurse` (`certificate`,`personID`) VALUES ("RN","2118");
INSERT INTO `Nurse` (`certificate`,`personID`) VALUES ("General","5518");
INSERT INTO `Nurse` (`certificate`,`personID`) VALUES ("General","6611");
INSERT INTO `Nurse` (`certificate`,`personID`) VALUES ("General","3379");
INSERT INTO `Nurse` (`certificate`,`personID`) VALUES ("General","5111");

--Insert values into Staff
INSERT INTO `Staff` (`jobClass`,`personID`) VALUES ("Janitor","9626");
INSERT INTO `Staff` (`jobClass`,`personID`) VALUES ("Maintenance","3572");

--#####################
--Insert values into Outpatient
INSERT INTO `Outpatient` (`personID`,`ID`) VALUES ("9894","3485");
INSERT INTO `Outpatient` (`personID`,`ID`) VALUES ("2607","6094");
INSERT INTO `Outpatient` (`personID`,`ID`) VALUES ("9723","1039");
INSERT INTO `Outpatient` (`personID`,`ID`) VALUES ("6847","5920");
INSERT INTO `Outpatient` (`personID`,`ID`) VALUES ("4272","2985");

--#####################
--Insert values into RN
INSERT INTO `RN` (`personID`,`licenseLoc`,`dateReceived`) VALUES ("2118","Stanford","2010-05-15");

--#####################
--Insert values into CareCenter
INSERT INTO `CareCenter` (`location`,`name`,`personID`) VALUES ("West Wing","Happy CareCenter","2118");

--#####################
--Insert values into TimeCard
INSERT INTO `Timecard` (`date`,`hrsWorked`,`personID`) VALUES ("2016-04-29","40","2118");
INSERT INTO `Timecard` (`date`,`hrsWorked`,`personID`) VALUES ("2016-04-21","60","5518");
INSERT INTO `Timecard` (`date`,`hrsWorked`,`personID`) VALUES ("2016-04-17","50","6611");
INSERT INTO `Timecard` (`date`,`hrsWorked`,`personID`) VALUES ("2016-03-24","50","3379");
INSERT INTO `Timecard` (`date`,`hrsWorked`,`personID`) VALUES ("2016-04-29","40","5111");


--#####################
--Insert values into Bed
INSERT INTO `Bed` (`bedNum`,`roomNum`,`locaion`) VALUES ("1","145","West Wing");
INSERT INTO `Bed` (`bedNum`,`roomNum`,`locaion`) VALUES ("2","145","West Wing");
INSERT INTO `Bed` (`bedNum`,`roomNum`,`locaion`) VALUES ("3","145","West Wing");
INSERT INTO `Bed` (`bedNum`,`roomNum`,`locaion`) VALUES ("4","145","West Wing");
INSERT INTO `Bed` (`bedNum`,`roomNum`,`locaion`) VALUES ("5","145","West Wing");

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
