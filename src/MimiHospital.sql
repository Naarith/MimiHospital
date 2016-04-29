show databases; -- show all databases
use cecs323m39; --switch to database, must call this before being able to add to it
show tables; --show all tables in current database

CREATE TABLE HospitalPerson(
    firstName VARCHAR(40),
    lastName VARCHAR(40),
    address VARCHAR(40),
    personID INT NOT NULL, --NOT NULL not necessarily needed but makes it clear what the pk is
    CONSTRAINT person_pk -- don't need CONSTRAINT, it is implied when using PRIMARY KEY
    PRIMARY KEY(personID) -- primary keys are always indexed in mySQL
);

CREATE TABLE PersonPhone(
    phoneType   VARCHAR(10),
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
DROP TABLE Physician;

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
    ADD CONSTRAINT
    FOREIGN KEY(location)
    REFERENCES CareCenter(location);


ALTER TABLE Nurse
    DROP location;

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

--#################################################
--#################################################
--#################################################
--##################################################

--BEGIN INSERTING VALUES INTO TABLES

--First 10
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Edan","Shana","P.O. Box 304, 2922 Odio Ave","9584"),("Unity","Sloane","P.O. Box 407, 7726 A, St.","1255"),("Benjamin","Barbara","185-1542 Lorem, Ave","7224"),("Xantha","Boris","3531 Vel, Road","3211"),("Iris","Maisie","P.O. Box 553, 4877 Morbi Street","1810"),("Mikayla","Mechelle","5545 Ligula. Rd.","1443"),("Deborah","Nero","9821 Aliquam St.","1830"),("Keefe","Harriet","Ap #837-5769 Mi Road","9729"),("Wallace","Melanie","837-2248 Risus Ave","3717"),("Ursula","Deirdre","P.O. Box 791, 2010 Laoreet, Road","2502");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Jamal","Basil","8231 Dolor, Rd.","3299"),("Eliana","Shaeleigh","Ap #508-4843 Semper Rd.","8373"),("Honorato","Gemma","Ap #871-6276 Et, St.","7166"),("Ian","Coby","543-2426 Enim. Road","3407"),("Abdul","Madaline","9915 Sed St.","8447"),("Guy","Melanie","1283 Nascetur Ave","8675"),("Adria","Raven","Ap #667-5618 In, Road","1767"),("Ulric","Germane","Ap #206-9642 Nec Avenue","7841"),("Stephanie","Danielle","P.O. Box 454, 5020 Lacus Avenue","5755"),("Joelle","Teagan","803-4710 Sodales Ave","1836");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Burton","Carl","6041 Ornare, Road","2997"),("Beau","Rafael","8834 Ut Avenue","4685"),("Keane","Madaline","P.O. Box 238, 7298 In St.","5851"),("David","Bert","4979 Non, Avenue","9874"),("Tyrone","Willow","1821 Montes, Av.","2920"),("Myles","Keiko","Ap #298-4930 Quis, Ave","9088"),("Patrick","Kendall","4314 Ipsum Av.","3492"),("Jada","Naida","P.O. Box 656, 564 Dictum Street","3387"),("Kuame","Marvin","Ap #849-2730 Amet, St.","4443"),("Elizabeth","Daphne","Ap #929-377 Auctor Av.","1854");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Chester","Keane","P.O. Box 809, 7218 Sed Rd.","7576"),("Zenia","Beatrice","463-7886 Ante St.","6575"),("Yoshio","Jelani","761-1469 Urna. Av.","9040"),("Lewis","Kalia","5061 Pede. Rd.","8161"),("Aiko","Adrienne","Ap #408-5855 Amet Rd.","6535"),("Timon","Virginia","Ap #189-5761 Odio, Rd.","1542"),("Griffith","Althea","Ap #901-6751 Iaculis, St.","3147"),("Bert","Demetria","Ap #397-8108 Convallis St.","3198"),("Chloe","Kai","703-1888 Elit Avenue","4555"),("Alexandra","Wallace","P.O. Box 453, 7907 Ac Avenue","5302");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Fulton","Cameran","P.O. Box 140, 1411 Quis Av.","9543"),("Rinah","Julie","7299 Aenean Avenue","6139"),("Clementine","Brock","1481 Id Avenue","5900"),("Rooney","Amanda","617-7649 Morbi St.","6842"),("Hannah","Chastity","P.O. Box 884, 6724 Primis Road","3697"),("Rana","Burton","2674 Neque. St.","9521"),("Macy","Simone","921-6085 Odio. Street","7647"),("Aimee","Thaddeus","Ap #942-2051 Ultrices Ave","7751"),("Marsden","Amy","P.O. Box 598, 5181 Nullam St.","2411"),("Germane","Beatrice","Ap #583-3234 Ornare St.","7132");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Craig","Dai","708-671 In, Road","8563"),("Lunea","Laurel","P.O. Box 441, 5397 Phasellus Rd.","7299"),("Uriel","Alea","Ap #539-7794 Sem Ave","1441"),("Brett","Ainsley","P.O. Box 669, 3285 Quis St.","9892"),("Armand","Nita","P.O. Box 751, 7850 Fringilla Ave","3394"),("Xyla","Winter","4917 Et, Avenue","6479"),("Hop","Nicole","P.O. Box 292, 8615 Aliquam Rd.","7376"),("Rajah","Violet","P.O. Box 459, 9665 Augue. Avenue","3477"),("Ezekiel","Drew","P.O. Box 780, 2439 Posuere St.","7850"),("Ashely","Joseph","617-1903 Neque Ave","6155");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Zelenia","Andrew","5895 Dolor. Ave","9277"),("Castor","Leslie","6621 Sollicitudin Street","5638"),("Rhona","Sopoline","Ap #246-2945 Donec Ave","7455"),("Graiden","Tiger","P.O. Box 378, 5206 Sapien St.","3812"),("Cameran","Lance","P.O. Box 888, 1346 Ipsum St.","8724"),("Kaseem","Kermit","Ap #132-1101 Mauris, St.","1961"),("Charles","Keaton","P.O. Box 944, 2285 Nunc Av.","2060"),("Amelia","Zephr","Ap #704-6314 Ornare Av.","6057"),("Keiko","Calvin","766 Lacus. Av.","3677"),("Paki","Janna","Ap #483-5837 Ipsum. Road","9117");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Eve","Melissa","4592 Eget Avenue","8201"),("Ryan","George","697-6588 Ligula Av.","2334"),("Lucius","Kamal","Ap #496-1066 Donec St.","1308"),("Bell","Astra","321-8696 Sagittis St.","4153"),("Medge","Cooper","392-899 Pede. Rd.","1545"),("Fay","Galena","P.O. Box 873, 7610 Montes, Ave","7966"),("Laura","Hedwig","P.O. Box 319, 2340 Non, St.","1300"),("Yen","Elvis","4471 Posuere Rd.","7439"),("Neve","Thane","Ap #555-259 Nec, Street","3230"),("Lani","Savannah","P.O. Box 814, 3167 Vestibulum Rd.","1287");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Noel","Dante","3554 Sed St.","4899"),("Erich","Avye","442-1712 Augue. Rd.","1427"),("Jaquelyn","Nicholas","Ap #388-6532 Enim St.","4403"),("Kirsten","Rhea","269-4842 Nonummy St.","8958"),("Halee","Felicia","846-4855 Integer Rd.","5046"),("Judith","Garth","385-2749 Rutrum Street","6081"),("Howard","Ingrid","137-8844 Sed Avenue","6066"),("Chaim","Paula","Ap #217-114 Dui, Rd.","8542"),("Murphy","Amela","669-7935 Velit Rd.","4301"),("Kelsey","Jenna","919-8328 Aliquam St.","3285");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Rhoda","Eve","Ap #791-6319 Vitae St.","2877"),("Gillian","Helen","Ap #715-623 Mauris Rd.","6120"),("Elizabeth","Iola","P.O. Box 748, 1917 Libero. Ave","5813"),("Germaine","Eden","Ap #693-1509 A, Av.","2389"),("Kelsie","Courtney","780-4740 Eros. Av.","3550"),("Dexter","Dominic","1568 Eros. Av.","8535"),("Dustin","Kareem","354-9577 Nulla Rd.","3501"),("Yolanda","Xander","Ap #692-1476 Vestibulum. Rd.","6601"),("Wylie","Megan","P.O. Box 784, 3982 Nulla Street","4439"),("Wallace","Sonya","P.O. Box 999, 3819 Tempus Road","7851");

--11-20

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Amela","Amber","Ap #692-4893 Enim. Rd.","3989"),("Kevyn","Colette","4245 A, Av.","9840"),("Claudia","Maia","603-206 Nam Street","7321"),("Lacota","Leandra","P.O. Box 342, 7039 Pulvinar Road","4143"),("Pascale","Beck","Ap #267-5423 Consectetuer, Rd.","6887"),("Xavier","Kylan","Ap #232-7010 Habitant St.","5229"),("Kameko","Montana","266-2162 Ac Road","3659"),("Pandora","Dorothy","Ap #692-1530 Amet, Avenue","7314"),("Alan","Bell","Ap #857-5877 Sed, St.","3344"),("Yeo","Angelica","P.O. Box 242, 6798 Non Av.","1382");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Chiquita","Charles","4168 Sed Road","5163"),("Avye","Delilah","137-823 Proin Street","1592"),("Diana","Cherokee","Ap #288-3651 Nibh Street","8303"),("Leah","Jamal","9810 Nullam Av.","4360"),("Macon","Thane","154-6998 Nisi. Av.","7399"),("Zephania","Iona","Ap #587-9261 Sollicitudin Rd.","5592"),("Ora","Ali","P.O. Box 470, 5494 Lobortis Av.","1684"),("Holmes","Erasmus","457-8511 Ut St.","2287"),("Leila","Veronica","Ap #940-6652 Sed Av.","6274"),("Germaine","Gray","Ap #347-6233 Lectus. Rd.","3975");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Tamekah","Steven","410 Eget, Street","7446"),("Hunter","Hannah","3433 Ipsum Road","5698"),("Candice","Mary","371-7323 Aliquet Avenue","8299"),("Morgan","Drake","9113 Luctus. Avenue","2509"),("Kellie","Libby","Ap #944-1028 Lectus, Rd.","2174"),("Eve","Tallulah","776-4332 Cursus Ave","9486"),("Hilda","Leonard","Ap #387-4661 Consequat Rd.","9890"),("Lacey","Martin","791-2932 Nunc Av.","8153"),("Frances","Patricia","Ap #916-2886 Sapien Rd.","6449"),("Brenda","Kiara","Ap #338-6224 Phasellus Street","2647");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Noble","Paula","662-3672 Risus. Street","4980"),("Julie","Vivien","4725 Rutrum. Rd.","1649"),("Yvette","Lester","434-6699 Nonummy Avenue","1483"),("Lucas","Giacomo","8739 Felis St.","6817"),("Gage","Whilemina","5022 Nec Avenue","9468"),("Austin","Alma","496-3351 Eros Rd.","9931"),("Benjamin","Tyler","3212 Lectus St.","5063"),("Ora","Murphy","Ap #855-4167 Mi Av.","6524"),("Cecilia","Ali","P.O. Box 564, 5643 Ornare Ave","8165"),("Malachi","Harriet","Ap #745-1064 Malesuada Rd.","7815");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Dominic","Amela","214-7781 Dolor Rd.","6597"),("Rina","Magee","444-4807 Netus Street","5046"),("Jenette","Davis","P.O. Box 194, 8778 Ac St.","8493"),("Anthony","Brian","7018 Non Rd.","6242"),("Kyle","Germaine","Ap #233-4966 Mi Ave","2003"),("Ayanna","Kirby","558-9280 Elit, Rd.","5538"),("Aimee","Charissa","P.O. Box 865, 4179 Pede, Rd.","5766"),("Deacon","Desiree","Ap #801-8895 Dolor. Av.","2719"),("Taylor","Alexandra","P.O. Box 632, 3107 Ligula Rd.","5821"),("Jade","Selma","176-8356 Vulputate St.","8764");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Tamara","Derek","Ap #728-2175 Nullam Road","6057"),("Gillian","Elizabeth","184-8719 Sit Rd.","6099"),("Bruce","Jonas","240-9457 Amet Rd.","2038"),("Victoria","Leonard","Ap #137-7435 Egestas. Road","2543"),("Piper","Clio","671-3985 Sagittis St.","9099"),("Sonya","Luke","8961 Non Av.","8563"),("Dorian","Owen","691-6703 Lobortis. St.","9062"),("Oscar","Haley","226-1255 Libero. Road","7760"),("Larissa","Akeem","923-6938 Primis Street","4486"),("Harlan","Galvin","198-4095 Facilisis Rd.","2501");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Ryan","Lamar","2466 Vitae Rd.","8094"),("Cherokee","Jermaine","Ap #633-2745 Interdum Street","8285"),("Sybill","Harrison","890 Lectus. St.","9911"),("Maisie","Leroy","426-4394 Cursus St.","7116"),("Peter","Brielle","9193 Amet Rd.","1646"),("Harrison","Wylie","Ap #616-7892 Magna. Road","1659"),("Elton","Hope","Ap #376-9887 Sed Rd.","5344"),("Kameko","Nolan","1149 Nullam St.","1552"),("Deborah","Laith","Ap #931-4262 Tristique Road","8960"),("Baker","Yvonne","P.O. Box 144, 3298 Accumsan Avenue","4154");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Acton","Nicholas","526-809 Faucibus Road","9868"),("Fulton","Anastasia","1141 Suspendisse Rd.","4568"),("Scarlet","Amal","Ap #747-6658 Etiam Av.","2152"),("Isaac","Zephania","9842 Mauris St.","2509"),("Carlos","Cameron","284-8151 Vestibulum Ave","4869"),("Margaret","Alan","Ap #856-2784 Turpis Rd.","5122"),("Palmer","Mariam","Ap #985-2859 Varius. Avenue","6644"),("Rhoda","Addison","5379 Est Rd.","8456"),("Hilary","Robin","208-3824 Cursus Avenue","5222"),("Jena","Gannon","P.O. Box 223, 9058 Lacus. St.","8875");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Preston","Arsenio","5516 Nec Rd.","4625"),("Aubrey","Peter","946-5979 Fringilla Rd.","2186"),("Eugenia","Duncan","P.O. Box 904, 7254 Egestas Rd.","7758"),("Brock","Risa","P.O. Box 122, 4887 Maecenas Rd.","5259"),("Lacey","Debra","4491 Vel, Av.","4683"),("Kalia","Zelda","1109 Vestibulum Rd.","7869"),("Merrill","Tyler","P.O. Box 365, 8211 A St.","6797"),("Jana","Jaime","P.O. Box 715, 856 Ligula Avenue","4043"),("Brittany","Ryder","Ap #999-7647 Posuere Avenue","8360"),("Jaden","Yael","526-8148 Nec Street","8948");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Mia","Nathaniel","181-5805 Pede. St.","8911"),("Griffith","Ezekiel","3778 Dui Avenue","3861"),("Hashim","Melodie","Ap #819-4133 Lorem, St.","8790"),("Chadwick","Jolie","554-5040 Tincidunt Rd.","3950"),("Rahim","Vaughan","2605 Eu Road","9032"),("Margaret","Jocelyn","Ap #341-8636 Ipsum Rd.","2772"),("Abraham","Bell","2824 Lorem Road","3080"),("Ivana","Karina","Ap #758-7075 Et Street","5111"),("Erin","Tarik","501-6763 Fermentum Rd.","1295"),("Wynter","Akeem","P.O. Box 260, 5906 Magna Avenue","4933");

--21-30

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Kaye","Colt","3397 Cursus St.","1487"),("Audra","Ashton","P.O. Box 370, 2206 Elit. Rd.","5651"),("Cameron","Farrah","3194 Lacinia Street","4244"),("Hadassah","Joelle","P.O. Box 699, 9246 Integer St.","6230"),("Victoria","Georgia","Ap #303-1800 Eget Rd.","3168"),("India","Hunter","802-3448 Aenean Rd.","5368"),("Scott","Justin","Ap #534-3599 Mauris Street","6536"),("Armand","Buffy","Ap #870-2187 Pede. Ave","2507"),("Daphne","Rose","896-7127 Interdum Street","5496"),("Regina","TaShya","649-3597 Curabitur Street","8280");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Imogene","Kennan","P.O. Box 964, 4196 Nec Ave","6203"),("Troy","Skyler","P.O. Box 182, 9121 Eget Av.","9364"),("Raja","Rae","683-6890 Lectus Street","5425"),("Quon","Amanda","902-1069 Phasellus Av.","2672"),("Imelda","Yardley","P.O. Box 765, 3493 Sociis St.","4402"),("Naida","Freya","883-975 Rhoncus Street","2504"),("Helen","Aristotle","446-2423 Urna. Street","3579"),("Travis","Damon","706-1663 Eget St.","5190"),("Yael","Ross","363-8972 Hymenaeos. Rd.","8422"),("Vladimir","Benjamin","1822 Tristique Av.","1431");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Lysandra","Hadassah","248-4807 Semper. St.","2397"),("Fulton","Allen","516-6154 Urna Street","3277"),("Lance","Rebekah","Ap #317-8328 Consequat St.","3355"),("Shafira","Bethany","Ap #791-1283 Enim, St.","2093"),("Alyssa","Preston","Ap #796-9848 Quis, Av.","3947"),("Ahmed","Jaquelyn","167-3883 Auctor Road","3299"),("Kylee","Lane","666-2920 Phasellus Avenue","5265"),("Ali","Hiram","830-676 Dui St.","7011"),("Lamar","Zelda","6258 Nunc Av.","7907"),("Calvin","September","700-3275 Congue. Ave","2184");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Karleigh","Odysseus","8295 Sit Ave","5108"),("Jemima","Harriet","4633 In Rd.","8462"),("Thaddeus","Jemima","Ap #742-4545 Mollis. Rd.","2408"),("Colin","Leandra","133 Proin St.","6046"),("Igor","Stone","4546 Phasellus Avenue","4687"),("Leilani","Moana","Ap #511-1592 Neque Av.","3356"),("Dale","Quail","416-8194 Eget, Rd.","3073"),("Brittany","Beau","P.O. Box 760, 1106 Eros. Avenue","5899"),("Blythe","Tasha","P.O. Box 171, 6915 Ligula. Street","7094"),("Richard","Dennis","Ap #725-3948 Accumsan Road","1972");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Aristotle","Christen","950-5814 Eu St.","9515"),("Hasad","Chaim","667-6163 Libero. Av.","1766"),("Ciara","Sharon","772-4975 Phasellus Ave","3576"),("Hunter","Violet","Ap #892-682 Ut Rd.","3022"),("Libby","Riley","P.O. Box 251, 2211 Netus Street","4964"),("Cassidy","Giselle","510-4066 Nullam Av.","3079"),("Dakota","Keefe","P.O. Box 670, 5519 Orci, St.","7563"),("Ina","Wynter","Ap #783-2369 Elit, Rd.","9655"),("Marvin","Hammett","P.O. Box 946, 6544 Habitant Road","6414"),("Xanthus","Sasha","6220 Laoreet, St.","1909");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Naida","Jenette","6072 Facilisis Rd.","6873"),("Darius","Lacey","P.O. Box 453, 8186 Lectus Rd.","9876"),("Regina","Kimberly","7673 Purus, St.","5084"),("Tana","Dominique","P.O. Box 929, 6911 Fusce Street","9880"),("Astra","Cain","495-7400 Aliquam Av.","5147"),("Flavia","Xenos","P.O. Box 696, 6584 Arcu. Street","7150"),("Dahlia","Noble","196-8986 Urna. Street","3829"),("Urielle","Isadora","8055 Quis Av.","5212"),("Lucy","Wyatt","Ap #620-3347 Ac, Road","3398"),("Gillian","Lev","6817 Aliquam Rd.","8324");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Gary","Omar","3158 In St.","5780"),("Stacy","Jin","P.O. Box 955, 4781 Nam Road","9186"),("Astra","Veda","613-5823 Convallis Street","6912"),("Lacy","Jocelyn","Ap #854-168 Nunc Rd.","8975"),("Nell","Jerry","Ap #674-5935 Montes, Road","4416"),("Denise","Maggy","8289 Duis Avenue","1960"),("Armando","Magee","4174 Ac, Street","3751"),("Sage","Grady","Ap #597-3630 Nunc Av.","5570"),("Alice","Athena","2259 Nunc Rd.","3268"),("Alfonso","Aquila","907-5625 Ac St.","9726");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Meghan","Inga","Ap #779-4293 Enim St.","3813"),("Gregory","Erich","Ap #690-8957 Ac Rd.","5055"),("Hu","Dean","946-2426 Fusce Rd.","8869"),("Dustin","Maite","P.O. Box 316, 1767 Erat St.","9678"),("Chester","Quinn","Ap #711-4602 Torquent St.","7497"),("Keiko","Micah","P.O. Box 295, 2471 Ac Av.","9679"),("Charissa","Dana","P.O. Box 702, 5215 Vehicula St.","3164"),("Lilah","Shana","Ap #910-6997 Convallis Ave","6029"),("Raja","Nomlanga","1856 Sed Rd.","1140"),("Mia","Bertha","Ap #249-7450 Velit Av.","5449");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Olivia","Elizabeth","P.O. Box 423, 5276 Massa. Ave","9891"),("Kelsey","Yen","8307 Aenean Street","2968"),("Amber","Sybill","Ap #559-3780 Tincidunt Rd.","6125"),("Yvette","Chava","7776 Nascetur Street","5291"),("Stone","Lillith","822-6389 Cras St.","8329"),("Faith","Akeem","P.O. Box 924, 145 Facilisis Ave","9012"),("Fallon","Sharon","Ap #851-5427 Ut Avenue","8236"),("Hammett","Hasad","595-5866 Nibh Street","7671"),("Mollie","Sloane","1617 Ridiculus Av.","9919"),("Noble","Irene","Ap #331-6348 Eu, Rd.","9053");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Brenna","Orson","Ap #466-3466 Suspendisse St.","4095"),("Talon","Steel","Ap #297-3873 Fermentum St.","2914"),("Sage","Travis","2264 Praesent Avenue","1236"),("Akeem","Wallace","713-1415 Neque St.","7179"),("Jemima","Zeph","4717 Pretium Rd.","1949"),("Quinn","Keegan","P.O. Box 632, 5655 Eu, Av.","8331"),("Keegan","Samantha","Ap #229-3959 Ligula Rd.","3721"),("Damon","Quinlan","3031 Vestibulum Rd.","1341"),("Jordan","Cleo","P.O. Box 691, 1065 Sed Avenue","4200"),("Valentine","Karleigh","3983 Quisque Rd.","1227");

--31-40

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Liberty","Minerva","5672 Ac Road","6415"),("Kyra","Violet","798-1050 Erat. Ave","6278"),("Harriet","Jorden","9671 Convallis St.","2559"),("Rylee","Emi","409 Tortor. Rd.","9033"),("Blythe","Lester","2683 Etiam Rd.","4051"),("Sawyer","Bruce","3526 Pellentesque Avenue","2208"),("Gay","Camille","903-9390 Sagittis St.","3445"),("Demetrius","Jael","Ap #380-5594 Dolor. Rd.","9384"),("James","Hermione","Ap #288-4666 Aliquet. St.","9854"),("Abraham","Gregory","9636 Luctus St.","1878");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Tamara","Cole","1502 Vitae Street","6328"),("Knox","Upton","141-5379 Arcu St.","1589"),("Hasad","Gareth","2711 Vitae St.","1116"),("Sonya","Wing","P.O. Box 695, 8508 Eros. Road","3755"),("Cleo","Wanda","P.O. Box 161, 5167 Ultrices St.","6304"),("Halee","Quamar","P.O. Box 765, 2387 Molestie St.","2862"),("Geoffrey","Tobias","Ap #573-3512 Lacinia Avenue","2529"),("Madaline","Deacon","Ap #155-8102 Ultrices St.","4175"),("Charles","Molly","Ap #308-6255 Amet Ave","6558"),("Sierra","Ray","Ap #275-5755 Ac Rd.","5860");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Jared","Claudia","P.O. Box 136, 9704 Sit St.","7377"),("Erica","Meredith","P.O. Box 337, 5693 Eleifend, Street","1938"),("Rana","Barry","Ap #862-7290 Vestibulum. St.","8579"),("Roanna","Josephine","688-4581 Enim Rd.","7888"),("Brianna","Camille","P.O. Box 977, 6753 Ut, Av.","5005"),("Bradley","Jordan","927-4824 Eu Avenue","2723"),("Leslie","Chantale","7959 Mi Road","2656"),("Maggy","Salvador","Ap #881-739 At Av.","3473"),("Bevis","Christian","P.O. Box 153, 2881 Nullam Rd.","9083"),("Dustin","Merritt","Ap #901-7761 Dui Rd.","6929");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Bo","Nicole","5655 Magnis St.","2559"),("Sharon","Mannix","637-7104 Ac, St.","7175"),("Plato","Victoria","3404 Dui Ave","2186"),("Delilah","Garrison","P.O. Box 674, 3134 Dolor Ave","3456"),("Bell","Oprah","7735 Consequat St.","2592"),("Aphrodite","Robert","P.O. Box 748, 5180 Tristique St.","8333"),("Fletcher","Pamela","261 Molestie St.","3886"),("Maggie","Perry","P.O. Box 514, 3599 Quam Rd.","9347"),("Quon","Ursula","P.O. Box 698, 2287 A, Road","3130"),("Josiah","Marsden","P.O. Box 694, 7530 Duis Street","8020");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Reuben","Kai","P.O. Box 403, 3683 Elit Rd.","5695"),("Yael","Martina","Ap #512-7490 Egestas Avenue","3793"),("Ariana","Mark","7004 Tristique Street","9798"),("Herman","Rashad","491-7887 Ligula. Avenue","5275"),("Joan","Bernard","9224 Cras Avenue","7894"),("Charde","Gareth","P.O. Box 473, 376 Duis Rd.","9495"),("Xandra","Logan","388-7316 Vehicula St.","6115"),("Kyla","Cullen","701-1473 Nec, St.","5512"),("Armand","Florence","Ap #743-5393 Vitae, Road","1214"),("Tad","Violet","954-369 Lobortis St.","6910");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Reuben","Alyssa","P.O. Box 833, 7828 Elementum, Road","1419"),("Anthony","Lila","Ap #187-8436 Id, St.","9609"),("Wesley","Allegra","9784 Nisi. Ave","1165"),("Griffith","Benjamin","671-4673 Et, Av.","5018"),("Tate","Kylan","P.O. Box 198, 2364 Augue. St.","8538"),("Tasha","Hiram","P.O. Box 616, 6395 Quis Avenue","6141"),("Jennifer","Matthew","P.O. Box 919, 2687 Nonummy. Av.","6447"),("Ann","Kyra","3174 Diam Av.","4127"),("Addison","Gail","4814 Parturient Rd.","8393"),("Rowan","Rinah","2343 Augue Street","7787");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Kyla","Jeremy","6432 Sagittis. St.","8158"),("Basia","Fleur","8182 Odio. Avenue","1671"),("Alice","Irene","Ap #471-7208 Sem, Av.","7579"),("Alfreda","Eve","P.O. Box 488, 3084 Aliquam Road","8326"),("Shoshana","Cora","383-3864 Nonummy Avenue","3562"),("Steel","Cynthia","9683 Eu Road","2185"),("Kaitlin","Jillian","496-2220 Faucibus Ave","7681"),("Odysseus","Victor","2931 Adipiscing Rd.","7281"),("Tanek","Briar","Ap #901-5324 In, Avenue","7733"),("Martena","Audrey","617-5645 Sapien, Ave","8170");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Brielle","Reed","Ap #512-4208 Laoreet St.","7198"),("Avye","Steel","P.O. Box 144, 3113 Duis Rd.","5710"),("Keiko","Donna","765-1104 Duis Avenue","2772"),("Jordan","Brendan","Ap #245-7019 Lacus. Avenue","5308"),("Nash","Brandon","8914 Orci. Road","1569"),("Paula","Cameran","699-7191 Velit St.","6911"),("Xandra","Yuri","7572 Ultrices, Av.","5070"),("Alyssa","Quamar","Ap #183-954 Nascetur Ave","2632"),("Colette","Donovan","729-2981 Ac Av.","7695"),("Jared","Jarrod","Ap #785-5791 Quam Avenue","8908");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Uriel","Hayley","P.O. Box 466, 4637 Mollis. Av.","1715"),("Bianca","Erasmus","933-3945 In St.","7739"),("Brendan","Leigh","P.O. Box 826, 3514 Consectetuer Rd.","6087"),("Vladimir","Scarlett","P.O. Box 318, 6532 Rhoncus St.","5966"),("Caesar","Jada","P.O. Box 795, 5185 Adipiscing St.","9492"),("Jolie","Giacomo","4541 Et, Road","7427"),("Montana","Hanna","Ap #105-5002 Congue Road","3285"),("Belle","Nayda","188-5092 Eu, Street","1350"),("Magee","Zia","Ap #617-9294 Tincidunt Avenue","4336"),("Karyn","Winifred","502-5710 Non, Ave","2457");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Haley","Paul","580-4892 Nibh. Av.","6111"),("Damon","Alexandra","P.O. Box 645, 1218 Nunc Avenue","4221"),("Courtney","Alexa","8281 Sit St.","9696"),("Gray","Lester","4677 Aliquam Rd.","2012"),("Penelope","Herman","264-8833 Sociis Ave","4792"),("Lamar","Jelani","627 A Road","2064"),("Paula","Claudia","839 Orci, Ave","7807"),("Eugenia","Noel","Ap #469-8087 Curabitur Road","5923"),("Travis","Cruz","P.O. Box 361, 3266 Elit, Ave","2431"),("Jarrod","Zephr","P.O. Box 134, 3266 Egestas St.","3056");

--41-50

INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Stephanie","Vera","6913 Et St.","3346"),("Olympia","Flynn","201-3485 In Av.","7327"),("Jesse","Keegan","P.O. Box 648, 4484 Non, Street","5847"),("Asher","Chloe","P.O. Box 371, 8287 Donec Avenue","2540"),("Farrah","Regina","783-1618 Diam. Ave","4894"),("Dakota","Keiko","Ap #313-1021 Habitant Ave","9196"),("Slade","Iola","Ap #594-8101 Torquent Road","5513"),("Rudyard","Rina","1599 Integer St.","9545"),("Chloe","Armando","Ap #137-1421 Metus. Street","2653"),("Eugenia","Winter","782-7274 Montes, Rd.","4866");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Charlotte","Georgia","564-8068 Lorem St.","3382"),("Kimberley","Sonia","2381 Dolor St.","7563"),("Mufutau","Dacey","P.O. Box 538, 9239 Ante St.","5743"),("Colin","Martha","313 Turpis St.","3965"),("Savannah","Lee","872-4685 Vel St.","6439"),("Eric","Gil","P.O. Box 701, 9629 Nisl Ave","5021"),("Rae","Kerry","8951 Curabitur Road","8428"),("Joelle","Theodore","540-7347 Maecenas Street","9491"),("Blair","Ivy","P.O. Box 300, 6101 Vitae Rd.","7446"),("Hashim","Allistair","P.O. Box 365, 2464 Curabitur Ave","2471");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Iliana","Yeo","P.O. Box 855, 5301 Ac Street","1170"),("Shana","Jelani","6410 Augue Street","9686"),("Freya","Hammett","Ap #557-5207 Amet Rd.","4525"),("TaShya","Amelia","Ap #647-5303 Odio St.","2443"),("Lisandra","Tatiana","P.O. Box 480, 9548 Consectetuer Street","5568"),("Meghan","Quon","836-7811 Pede Road","4498"),("Aphrodite","Rowan","726-9747 Tempor Av.","2640"),("Amal","Leslie","8127 Magnis Av.","8614"),("Vance","Whoopi","Ap #296-6124 Nec, St.","5532"),("Michael","Bryar","Ap #453-769 Nunc. Rd.","1742");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Maia","Sybil","Ap #278-3966 Elit. Avenue","7842"),("Eden","Tanisha","Ap #224-4814 Orci Av.","3082"),("Bertha","Fletcher","5509 Urna. Rd.","5656"),("Ramona","Molly","822-2581 Tellus Rd.","4488"),("Octavia","Maggie","Ap #264-4305 Ipsum Av.","1850"),("Jana","Jaden","Ap #365-3554 Nulla St.","6717"),("Desirae","Piper","P.O. Box 547, 7960 Sagittis Rd.","7453"),("Adara","James","Ap #254-2327 Auctor. Rd.","2935"),("Isaiah","Maite","748-1095 Lorem, Rd.","6059"),("Jermaine","Madaline","Ap #726-7538 Pretium Avenue","8674");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Cameron","Hayden","Ap #949-775 Fames Rd.","8456"),("Rana","Scarlett","Ap #318-3584 A Road","4384"),("Ulysses","Kaseem","388-8837 Sapien, Avenue","5715"),("Zachery","Anastasia","Ap #640-2830 Ante St.","5528"),("Henry","Mariko","2799 Sed Road","7594"),("Christopher","Heidi","4758 Eu Rd.","7119"),("Kimberley","Xanthus","Ap #981-2064 Nec Av.","4497"),("Price","Lacota","1477 Aliquam Street","7431"),("Brody","Kessie","768-5989 Euismod Rd.","2037"),("Jaquelyn","Thaddeus","P.O. Box 942, 4137 Amet St.","2612");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Xerxes","Lacey","Ap #609-8454 Tortor. Street","5969"),("Wyatt","Colton","Ap #929-1537 Aliquam Rd.","6219"),("Kylan","Shelley","P.O. Box 798, 2173 Gravida St.","4274"),("Evangeline","Blake","365-8678 Rutrum Road","3997"),("Otto","Gisela","P.O. Box 661, 4879 Tortor. St.","4029"),("Ocean","Alma","Ap #154-6337 Nisl Road","7052"),("Deacon","Jeanette","650-8285 Dis Rd.","8877"),("Mara","Gil","P.O. Box 678, 7245 Ut Street","7264"),("Phoebe","Zenia","3298 Non Av.","5280"),("Eaton","Jordan","2273 Semper, St.","9664");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Ayanna","Quyn","P.O. Box 674, 5609 Cras St.","9463"),("Samantha","Quyn","533 Magna. Street","4585"),("Allistair","Kirsten","P.O. Box 721, 8859 Ligula. St.","7212"),("Bradley","Vivien","872-3033 Donec St.","5833"),("Macey","Cathleen","937-5796 Commodo Avenue","3420"),("Mikayla","Colorado","Ap #278-434 Ridiculus St.","1808"),("James","Harding","P.O. Box 737, 4315 Ac Rd.","7185"),("Adele","Clio","P.O. Box 944, 1867 Id, St.","8931"),("April","Sandra","217-9030 Mus. Road","4300"),("Gillian","Laith","195-4572 Neque Rd.","2119");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Victoria","MacKensie","185-4916 Cras Road","8955"),("Mallory","Samson","258-6778 Id Road","8057"),("Ryan","Bernard","Ap #425-635 Euismod Rd.","4696"),("Ryder","Oleg","Ap #237-2279 Aliquam Rd.","5180"),("Belle","Meghan","462 Vivamus Ave","2566"),("Rashad","Thor","604-8089 Lacus. Av.","4630"),("Oren","Gage","P.O. Box 399, 6260 Imperdiet St.","3308"),("Amos","Rana","979-9237 Eu Rd.","4856"),("Jesse","Liberty","P.O. Box 176, 103 Phasellus Street","1715"),("Keely","Evangeline","2564 Id St.","9606");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Ayanna","Vaughan","923-1611 Porttitor Ave","3250"),("Noel","Inez","P.O. Box 529, 1943 Dignissim. St.","3387"),("Lucian","Shelley","8972 Molestie Avenue","5224"),("Oliver","Kessie","383-4867 Ornare, St.","6428"),("Anjolie","Justine","1355 Nunc Av.","8707"),("Giselle","Asher","P.O. Box 753, 6858 Vulputate Rd.","6030"),("Amir","Iris","P.O. Box 207, 4116 Et, Street","3631"),("Brock","Ivor","P.O. Box 367, 6223 Arcu Rd.","7664"),("Sage","Illana","853-4460 Mi. Road","7480"),("Hadassah","Emmanuel","1162 Dolor Rd.","5720");
INSERT INTO `HospitalPerson` (`firstName`,`lastName`,`address`,`personID`) VALUES ("Isadora","Adrian","P.O. Box 983, 4528 Tristique St.","1696"),("Leilani","Orla","Ap #313-2786 Amet, Rd.","8764"),("Faith","Jolie","1701 Mi St.","5002"),("Neil","Halee","734-6244 Mi. St.","5192"),("Kane","Emi","P.O. Box 152, 254 Duis St.","8603"),("Colton","Phyllis","P.O. Box 272, 3349 Est Rd.","2180"),("Ella","Zenaida","6518 Et St.","2311"),("Lewis","Owen","Ap #707-907 Consequat Rd.","9089"),("August","Bevis","583-7152 Arcu. Rd.","5811"),("Igor","Quincy","Ap #727-9823 Pharetra. Avenue","5067");


SELECT * FROM HospitalPerson;




--DROP FOR DEBUG PURPOSES
DROP TABLE HospitalPerson;
DROP TABLE PersonPhone;

DROP TABLE Employee;

DROP TABLE Nurse;
DROP TABLE RN;
DROP TABLE Timecard;
DROP TABLE CareCenter;

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
DROP TABLE Lab;
DROP TABLE TechLab;

DROP TABLE Staff;
