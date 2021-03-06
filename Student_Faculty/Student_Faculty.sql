create database Student_Faculty;
use Student_Faculty;
CREATE TABLE STUDENT(snum INT, sname VARCHAR(10), major VARCHAR(2), lvl VARCHAR(2), age INT, primary key(snum));
CREATE TABLE FACULTY(fid INT,fname VARCHAR(20), deptid INT, PRIMARY KEY(fid));
CREATE TABLE CLASS(cname VARCHAR(20), meets_at TIMESTAMP, room VARCHAR(10), fid INT, PRIMARY KEY(cname), FOREIGN KEY(fid) REFERENCES faculty(fid));
CREATE TABLE ENROLLED(snum INT, cname VARCHAR(20), PRIMARY KEY(snum,cname), FOREIGN KEY(snum) REFERENCES student(snum), FOREIGN KEY(cname) REFERENCES class(cname));
SHOW TABLES;
INSERT INTO STUDENT VALUES('6','Corona','CS','Sr','19');
INSERT INTO FACULTY VALUES('15','Jhonny Bravo','1000');
INSERT INTO CLASS VALUES('class7','12/11/15 10:10:10.000000','R3','14');
INSERT INTO ENROLLED VALUES('5','class5');
SELECT * FROM ENROLLED;

-- i. Find the names of all Juniors (level(lvl) = Jr) who are enrolled in a class taught by Jagdesh.

SELECT DISTINCT S.Sname
FROM Student S, Class C, Enrolled E, Faculty F
WHERE S.snum = E.snum AND E.cname = C.cname AND C.fid = F.fid AND
F.fname = 'Jagdesh' AND S.lvl = 'Jr';

-- ii. Find the names of all classes that either meet in room R128 or have five or more Students enrolled.

SELECT C.cname
FROM Class C
WHERE C.room = 'R128'
OR C.cname IN (SELECT E.cname
		FROM Enrolled E
        GROUP BY E.cname
		HAVING COUNT(*) >= 5);
        
-- iii. Find the names of all students who are enrolled in two classes that meet at the same time.

SELECT DISTINCT S.sname
FROM STUDENT S
WHERE S.snum IN (SELECT E1.snum
			FROM ENROLLED E1, ENROLLED E2, CLASS C1, CLASS C2
			WHERE E1.snum = E2.snum AND E1.cname <> E2.cname
			AND E1.cname = C1.cname
			AND E2.cname = C2.cname AND C1.meets_at = C2.meets_at);


-- iv. Find the names of faculty members who teach in every room in which some class is taught.

SELECT DISTINCT F.fname
FROM Faculty F
WHERE NOT EXISTS ((SELECT C.room FROM Class C)
-
(SELECT C1.room
FROM Class C1
WHERE C1.fid = F.fid ));

-- v. Find the names of faculty members for whom the combined enrollment of the courses that they teach is less than five.

SELECT DISTINCT F.fname
FROM Faculty F
WHERE 5 > (SELECT COUNT (E.snum)
FROM Class C, Enrolled E
WHERE C.cname = E.cname
AND C.fid = F.fid)

-- vi. Find the names of students who are not enrolled in any class. 

SELECT DISTINCT S.sname
FROM Student S
WHERE S.snum NOT IN (SELECT E.snum
FROM Enrolled E);	

-- vii. For each age value that appears in Students, find the level value that appears most often. For example, if there are more FR level students aged 18 than SR, JR, or SO students aged 18, you should print the pair (18, FR).

SELECT S.age, S.lvl
FROM Student S
GROUP BY S.age, S.lvl
HAVING S.lvl IN (SELECT S1.lvl FROM Student S1
      WHERE S1.age = S.age
GROUP BY S1.lvl, S1.age
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
FROM Student S2
WHERE s1.age = S2.age
GROUP BY S2.lvl, S2.age));

