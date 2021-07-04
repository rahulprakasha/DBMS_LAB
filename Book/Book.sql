create database book;
use book;
CREATE TABLE author(author_id INT,author_name VARCHAR(20),author_city VARCHAR(20),author_country VARCHAR(20),PRIMARY KEY(author_id));
CREATE TABLE publisher(publisher_id INT,publisher_name VARCHAR(20),publisher_city VARCHAR(20),publisher_country VARCHAR(20),PRIMARY KEY(publisher_id));
CREATE TABLE category(category_id INT,description VARCHAR(30),PRIMARY KEY(category_id) );
CREATE TABLE catalogue(book_id INT,book_title VARCHAR(30),author_id INT,publisher_id INT,category_id INT,year INT,price INT,PRIMARY KEY(book_id),FOREIGN KEY(author_id) REFERENCES author(author_id),FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id),FOREIGN KEY(category_id) REFERENCES category(category_id) );
CREATE TABLE orderdetails1(order_id INT,book_id INT,quantity INT,PRIMARY KEY(order_id),FOREIGN KEY(book_id) REFERENCES catalogue(book_id));
show tables;

INSERT INTO author VALUES(1001,'JK Rowling','London','England');
INSERT INTO publisher VALUES(2001,'Bloomsbury','London','England');
INSERT INTO category VALUES(3001,'Fiction');
INSERT INTO catalogue VALUES(4001,'HP and Goblet Of Fire',1001,2001,3001,2002,600);
INSERT INTO orderdetails1 VALUES(5001,4001,5);
select * from author;

-- 1: Give the details of the authors who have 2 or more books in the catalog and the price of the books is greater than the average price of the books in the catalog and the year of publication is after 2000

 SELECT * FROM author
		  WHERE author_id IN
          (SELECT author_id FROM catalogue WHERE
          year>2000 AND price>
          (SELECT AVG(price) FROM catalogue)
          GROUP BY author_id HAVING COUNT(*)>1);
          
-- 2: Find the author of the book which has maximum sales.

 SELECT author_name FROM author a,catalogue c WHERE a.author_id=c.author_id AND book_id IN (SELECT book_id FROM orderdetails1 WHERE quantity= (SELECT MAX(quantity) FROM orderdetails1));
 
-- 3: Demonstrate how you increase the price of books published by a specific publisher1 by 10%.
          
          UPDATE catalogue SET price=1.1*price
          WHERE publisher_id IN
          (SELECT publisher_id FROM publisher WHERE
         publisher_name='pearson');