CREATE TABLE C1_CUSTOMERS
( customer_id number(10) NOT NULL,
  customer_f_name varchar2(50),
  customer_last_name varchar2(50),
  city varchar2(50),
  salary varchar2(50)
);

INSERT INTO C1_CUSTOMERS VALUES (1, 'Balganymka', 'Tulebayeva', 'Almaty', '90000');
INSERT INTO C1_CUSTOMERS VALUES (2, 'Harry', 'Potter', 'London', '2000');
INSERT INTO C1_CUSTOMERS VALUES (3, 'Hermione', 'Granger', 'Cambridge', '1000');
INSERT INTO C1_CUSTOMERS VALUES (4, 'Ron', 'Weasley', 'Oxford', '4000');

UPDATE C1_CUSTOMERS SET salary = 1800 WHERE customer_id = 2;

SELECT salary*3 AS "Annual" FROM C1_CUSTOMERS;

SELECT CONCAT(customer_f_name, customer_last_name) AS "Full Name" FROM C1_CUSTOMERS;

SELECT SYSDATE FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'DD:MM:YYYY') FROM C1_CUSTOMERS;

CREATE TABLE C2_CLIENT
( 
  client_id integer(10) NOT NULL,
  client_f_name varchar2(50),
  client_last_name varchar2(50),
  address varchar2(50),
  balance number(10, 2),
  officer varchar2(100),
  amend_date date,
  audit_field integer(10),
  auth_officer varchar2(100),
  auth_date DATE DEFAULT (sysdate),
  status_field number(10)
);


INSERT INTO C2_CLIENT (client_id, client_f_name, client_last_name, address, balance, 
officer, audit_field, status_filed) 
VALUES (1, 'Нурбек', 'Кабылбай', 'KBTU', 1000000, 'Balganym', 0, 0)
