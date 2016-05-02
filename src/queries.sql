--###########
--File for queries required by the project

--1.) For each Job Class list all the staff members belonging to this class. 

SELECT firstName, lastName, jobClass FROM HospitalPerson
    NATURAL JOIN Staff
    GROUP BY jobClass;

--2.) Find all Volunteers who do not have any skills. 

SELECT firstName, lastName, personID FROM HospitalPerson NATURAL JOIN Volunteer WHERE personID NOT IN (SELECT personID FROM VolunteerSkill);

--3.) List all Patients who are also Volunteers at the Hospital. 

SELECT personID, firstName, lastName FROM HospitalPerson NATURAL JOIN Patient NATURAL JOIN Volunteer;

--4.) Find each Outpatient who has been visited exactly once. 

--5.) For each Skill list the total number of volunteers and technicians that achieve this skill. 
