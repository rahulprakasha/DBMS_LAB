Create database student_enrollment;
use student_enrollment;

CREATE TABLE student(regno VARCHAR(15),name VARCHAR(20),major VARCHAR(20),bdate DATE,PRIMARY KEY (regno) );
CREATE TABLE course(courseno INT,cname VARCHAR(20),dept VARCHAR(20),PRIMARY KEY (courseno) );
CREATE TABLE enroll(regno VARCHAR(15),courseno INT,sem INT,marks INT,PRIMARY KEY (regno,courseno),FOREIGN KEY (regno) REFERENCES student (regno),FOREIGN KEY (courseno) REFERENCES course (courseno));
CREATE TABLE text(book_isbn INT(5),book_title VARCHAR(20),publisher VARCHAR(20),author VARCHAR(20),PRIMARY KEY (book_isbn) );
CREATE TABLE book_adoption(courseno INT,sem INT,book_isbn INT,PRIMARY KEY (courseno,book_isbn),FOREIGN KEY (courseno) REFERENCES course (courseno),FOREIGN KEY (book_isbn) REFERENCES text(book_isbn) );
show tables;

INSERT INTO student VALUES('1pe11cs001','a','sr',19931230);
INSERT INTO course VALUES (111,'OS','CSE');
INSERT INTO text VALUES(10,'DATABASE SYSTEMS','PEARSON','SCHIELD');
INSERT INTO enroll VALUES ('1pe11cs001',115,3,100);
INSERT INTO book_adoption VALUES(111,5,900);
select * from text;

-- 1. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical order for courses offered 
-- by the 'CS' department that use more than two books.
	SELECT c.courseno,t.book_isbn,t.book_title
     FROM course c,book_adoption ba,text t
     WHERE c.courseno=ba.courseno
     AND ba.book_isbn=t.book_isbn
     AND c.dept='CSE'
     AND 2<(
     SELECT COUNT(book_isbn)
     FROM book_adoption b
     WHERE c.courseno=b.courseno)
     ORDER BY t.book_title;
     
 -- 2. Demonstrate how you add a new text book to the database and make this book be adopted 
 -- by some department.
	INSERT INTO text 
	VALUES (11,'DATABASE SYSTEMS','GRB','SCHIELD');
	INSERT INTO book_adoption (courseno,sem,book_isbn) VALUES(111,5,11);
     
 -- 3. List any department that has all its adopted books published by a specific publisher.
     SELECT DISTINCT c.dept
     FROM course c
     WHERE c.dept IN
     ( SELECT c.dept
     FROM course c,book_adoption b,text t
     WHERE c.courseno=b.courseno
     AND t.book_isbn=b.book_isbn
     AND t.publisher='PEARSON')
     AND c.dept NOT IN
     (SELECT c.dept
     FROM course c,book_adoption b,text t
     WHERE c.courseno=b.courseno
     AND t.book_isbn=b.book_isbn
     AND t.publisher != 'PEARSON');   

