--###########
--File for queries required by the project

--1.) For each Job Class list all the staff members belonging to this class. 
use cecs323m39;
SELECT firstName, lastName, jobClass FROM HospitalPerson
    NATURAL JOIN Staff
    GROUP BY jobClass;

--2.) Find all Volunteers who do not have any skills. 
SELECT firstName, lastName, personID FROM HospitalPerson 
    NATURAL JOIN Volunteer 
    WHERE personID 
    NOT IN (SELECT personID FROM VolunteerSkill);

--3.) List all Patients who are also Volunteers at the Hospital. 
SELECT firstName, lastName FROM HospitalPerson 
    INNER JOIN Volunteer 
    ON HospitalPerson.personID = Volunteer.personID  
    INNER JOIN Patient 
    ON Volunteer.personID = Patient.personID;

--4.) Find each Outpatient who has been visited exactly once. 
SELECT firstName, lastName, date, personID FROM HospitalPerson
    NATURAL JOIN Outpatient
    NATURAL JOIN Visit
    GROUP BY personID
    HAVING COUNT(date) = 1;


--5.) For each Skill list the total number of volunteers and technicians that achieve this skill. 
SELECT skillName, COUNT(TechnicianSkill.personID) AS 'SkillCount', 'Technician' AS 'People' FROM TechnicianSkill
    GROUP BY skillName
    UNION
    SELECT skillName, COUNT(VolunteerSkill.personID), 'Volunteer' AS 'People' FROM VolunteerSkill
    GROUP BY skillName;

--6.) Find all Care Centers where every bed is assigned to a Patient (i.e. no beds are available).
SELECT * FROM CareCenter 
    NATURAL JOIN Bed
    WHERE roomNum
    NOT IN (SELECT roomNum FROM CareCenter 
            NATURAL JOIN Bed 
            NATURAL JOIN Resident);

--7.) List all Nurses who have an RN certificate but are not in charge of a Care Center.
SELECT firstName, lastName, personID FROM HospitalPerson 
    NATURAL JOIN RN
    WHERE (firstName, lastName, personID)
    NOT IN (SELECT firstName, lastName, personID FROM HospitalPerson 
            NATURAL JOIN HeadNurse);

--8.) List all Nurses that are in charge of a Care Center to which they are also assigned.
SELECT firstName, lastName, personID FROM HospitalPerson 
    NATURAL JOIN HeadNurse 
    WHERE assigned = 1;

--9.) List all Laboratories, where all assigned technicians to that laboratory achieve at least one skill.
SELECT name, firstName, lastName, skillName FROM Lab
    NATURAL JOIN TechLab
    NATURAL JOIN TechnicianSkill
    NATURAL JOIN HospitalPerson;

--10.) List all Resident patients that were admitted after the most current employee hire date.
SELECT firstName, lastName, personID, admittedDate FROM HospitalPerson 
    NATURAL JOIN Resident 
    WHERE admittedDate > (SELECT MAX(hiredDate) AS "Latest Hired Date" FROM Employee);

--11.) Find all Patients who have been admitted within one week of their Contact Date.
SELECT firstName, lastName, personID FROM Patient 
    NATURAL JOIN Resident
    NATURAL JOIN HospitalPerson
    WHERE DATEDIFF(contactDate, admittedDate) < 7 AND
    DATEDIFF(contactDate, admittedDate) > 0;

--12. Find all Outpatients who have not been visited by a Physician within one week of their Contact Date.
SELECT DISTINCT firstName, lastName, Outpatient.personID FROM Outpatient
    NATURAL JOIN HospitalPerson
    INNER JOIN Patient ON Patient.personID = Outpatient.personID
    INNER JOIN Visit ON Visit.pagerNum = Patient.pagerNum
    WHERE DATEDIFF(Patient.contactDate, Visit.date) > 7 OR
    DATEDIFF(Patient.contactDate, Visit.date) < 0;
    
--13. List all Physicians who have made more than 3 visits on a single day.
SELECT firstName, lastName, Physician.pagerNum, COUNT(Physician.pagerNum) AS 'Visits' FROM Physician
    INNER JOIN Visit using (pagerNum)
    INNER JOIN HospitalPerson on HospitalPerson.personID = Physician.personID
    GROUP BY pagerNum
    HAVING COUNT(pagerNum) > 3;

--14.) List all Physicians that are responsible for more Outpatients than Resident Patients.
-- CREATE VIEW PhysOut AS select firstName, lastName, Physician.pagerNum, count(Physician.pagerNum) as 'PatientsResponsible' from HospitalPerson 
--     inner join Physician on HospitalPerson.personID = Physician.personID
--     inner join Patient on Patient.pagerNum = Physician.pagerNum 
--     inner join Outpatient on Patient.personID = Outpatient.personID
--     group by Physician.pagerNum;
-- 
-- CREATE VIEW PhysIn AS select firstName, lastName, Physician.pagerNum, count(Physician.pagerNum) as 'PatientsResponsible' from HospitalPerson 
--     natural join Physician
--     inner join Patient on Patient.pagerNum = Physician.pagerNum 
--     inner join Resident on Patient.personID = Resident.personID
--     group by Physician.pagerNum;
SELECT PhysOut.firstName AS 'FirstName', PhysOut.lastName AS 'LastName', 
    PhysOut.pagerNum AS 'PagerNum', 
    PhysOut.PatientsResponsible AS 'Outpatients', 
    PhysIn.PatientsResponsible AS 'Residents' 
    FROM PhysIn
    INNER JOIN PhysOut 
    on PhysIn.pagerNum = PhysOut.pagerNum
    WHERE PhysOut.PatientsResponsible > PhysIn.PatientsResponsible;

-- create view 
-- answer for 14 is marshall dana

--15.) Find each Physician who visited an Outpatient for whom he or she was not responsible for.
select firstName, lastName, Physician.pagerNum from Patient inner join Visit on Patient.personID = Visit.personID
    inner join Physician on Physician.pagerNum = Visit.pagerNum
    inner join HospitalPerson on HospitalPerson.personID = Physician.personID
    where (Patient.pagerNum != Visit.pagerNum and Patient.personID = Visit.personID);
