--###################
--VIEWS SQL FILE

--Views Required

--1. Employees-Hired: This view returns the First Name, Last Name, and Date Hired of all Hospital Employees.

CREATE VIEW EmployeesHired_View AS SELECT firstName, lastName, hiredDate FROM HospitalPerson NATURAL JOIN Employee;

--2. NursesInCharge: This view returns the name of the Nurse in Charge for each Care Center along with the phone number of the Nurse. 

CREATE VIEW NursesInCharge_View AS SELECT firstName, lastName, phoneNum, centerName FROM HospitalPerson NATURAL JOIN Nurse NATURAL JOIN PersonPhone NATURAL JOIN HeadNurse
NATURAL JOIN CareCenter WHERE assigned > 0;

--3. GoodTechnician: This view returns all the Technicians how have at least one skill. 

CREATE VIEW GoodTechnician_View AS SELECT personID, count(personID) AS "Skill Amount" FROM TechnicianSkill GROUP BY (personID) HAVING COUNT(personID)
> 0;

--4. CareCenter-Beds: This view returns the name for each Care Center along with the number of beds that are assigned to patients (occupied beds), the number of beds not assigned to patients (free beds), and the total number of beds. 

CREATE VIEW CareCenterBeds_View AS select centerName, "Taken", COUNT(centerID) as "Beds Taken" from Resident natural join CareCenter group by centerName
union
select centerName, "Total", COUNT(location) as "Beds Total" FROM Bed natural join CareCenter group by centerName
union
select null, "Open", (select COUNT(centerID) from Bed) -
(select COUNT(centerID) from Resident) from CareCenter;

--5. OutPatientsNotVisited: This view returns all OutPatients who have not been visited by a Physician yet. 

CREATE VIEW OutPatientsNotVisited_View AS select firstName, lastName, Outpatient.personID from Outpatient
inner join Patient on Patient.personID = Outpatient.personID
inner join Visit on Visit.personID = Outpatient.personID INNER JOIN HospitalPerson ON
HospitalPerson.personID = Outpatient.personID
WHERE Visit.date is NULL;

--##########################################################
--##########################################################

--Bed
CREATE VIEW Bed_View AS SELECT * FROM Bed;

--CareCenter
CREATE VIEW CareCenter_View AS SELECT * FROM CareCenter;

--Employee
CREATE VIEW Employee_View AS SELECT * FROM Employee;

--HeadNurse
CREATE VIEW HeadNurse_View AS SELECT * FROM HeadNurse;

--HospitalPerson
CREATE VIEW HospitalPerson_View AS SELECT * FROM HospitalPerson;

--Lab
CREATE VIEW Lab_View AS SELECT * FROM Lab;

--Nurse
CREATE VIEW Nurse_View AS SELECT * FROM Nurse;

--Outpatient
CREATE VIEW Outpatient_View AS SELECT * FROM Outpatient;

--Patient
CREATE VIEW Patient_View AS SELECT * FROM Patient;

--PersonPhone
CREATE VIEW PersonPhone_View AS SELECT * FROM PersonPhone;

--Physician
CREATE VIEW Physician_View AS SELECT * FROM Physician;

--PhysicianSpecialty
CREATE VIEW PhysicianSpecialty_View AS SELECT * FROM PhysicianSpecialty;

--RN
CREATE VIEW RN_View AS SELECT * FROM RN;

--Resident
CREATE VIEW Resident_View AS SELECT * FROM Resident;

--Skill
CREATE VIEW Skill_View AS SELECT * FROM Skill;

--Specialty
CREATE VIEW Specialty_View AS SELECT * FROM Specialty;

--Staff
CREATE VIEW Staff_View AS SELECT * FROM Staff;

--TechLab
CREATE VIEW TechLab_View AS SELECT * FROM TechLab;

--Technician
CREATE VIEW Technician_View AS SELECT * FROM Technician;

--TechnicianSkill
CREATE VIEW TechnicianSkill_View AS SELECT * FROM TechnicianSkill;

--Timecard
CREATE VIEW Timecard_View AS SELECT * FROM Timecard;

--Visit
CREATE VIEW Visit_View AS SELECT * FROM Visit;

--Volunteer
CREATE VIEW Volunteer_View AS SELECT * FROM Volunteer;

--VolunteerSkill
CREATE VIEW VolunteerSkill_View AS SELECT * FROM VolunteerSkill;
