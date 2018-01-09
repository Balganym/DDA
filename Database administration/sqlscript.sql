CREATE TABLE A1_OFFICERS(  
 officer_id NUMBER(10) NOT NULL,  
 officer_role_id NUMBER(10),  
 officer_last_name VARCHAR2(50),  
 officer_first_name VARCHAR2(50),  
 CONSTRAINT officer_pk PRIMARY KEY(officer_id)  
); 

INSERT INTO A1_OFFICERS (officer_id, officer_role_id, officer_last_name,   
officer_first_name)    
VALUES (1, 2, 'Tulebayeva', 'Balganym')

INSERT INTO A1_OFFICERS (officer_id, officer_role_id, officer_last_name,   
officer_first_name)    
VALUES (2, 1, 'Rakhmetov', 'Kuanysh')

CREATE TABLE A1_RECORDS(  
  record_id NUMBER(10),   
  client_id NUMBER(10),   
  CONSTRAINT record_pk PRIMARY KEY(record_id)   
);  

CREATE TABLE A1_CLIENTS(       
  client_id NUMBER(10) NOT NULL,      
  client_first_name VARCHAR2(50),      
  client_last_name VARCHAR2(50),      
  address VARCHAR2(50),      
  balance NUMBER(10, 2),      
  officer_id NUMBER(10),      
  amend_date DATE,      
  auth_officer_id NUMBER(10),      
  auth_date DATE DEFAULT (sysdate),      
  status_field NUMBER(10),   
  record_id NUMBER(10),  
  CONSTRAINT client_pk PRIMARY KEY(client_id),   
  CONSTRAINT fk_officer FOREIGN KEY(officer_id) REFERENCES A1_OFFICERS(officer_id),   
  CONSTRAINT fk_auth_officer FOREIGN KEY(auth_officer_id) REFERENCES A1_OFFICERS(officer_id),  
  CONSTRAINT fk_record_id FOREIGN KEY(record_id) REFERENCES A1_RECORDS(record_id)  
) 

CREATE TABLE A2_TRANSACTIONS(       
    
  transaction_id NUMBER(10),  
  client_id NUMBER(10),  
  transaction_date DATE DEFAULT (sysdate),  
  transaction_type NUMBER(10),  
  amount NUMBER(10, 2),  
  CONSTRAINT transaction_pk PRIMARY KEY(transaction_id),  
  CONSTRAINT fk_client FOREIGN KEY(client_id) REFERENCES A1_CLIENTS(client_id)   
) 

CREATE OR REPLACE PROCEDURE new_record(
  rec_id IN A1_RECORDS.record_id%TYPE,
  cl_id IN A1_RECORDS.client_id%TYPE)
IS
BEGIN INSERT INTO A1_RECORDS
  VALUES (new_record.rec_id, new_record.cl_id);
END new_record;
  

CREATE OR REPLACE PROCEDURE add_client(
  cl_id IN A1_CLIENTS.client_id%TYPE,
  cl_first_name IN A1_CLIENTS.client_first_name%TYPE,
  cl_last_name IN A1_CLIENTS.client_last_name%TYPE, 
  cl_address IN A1_CLIENTS.address%TYPE,
  cl_balance IN A1_CLIENTS.balance%TYPE,
  cl_officer IN A1_CLIENTS.officer_id%TYPE,
  record_id IN A1_CLIENTS.record_id%TYPE) 
  IS 
BEGIN 
    EXECUTE new_record(add_client.record_id, add_client.client_id);
    INSERT INTO A1_CLIENTS 
    VALUES(
      add_client.cl_id,add_client.cl_first_name,
      add_client.cl_last_name,add_client.address, 
      add_client.balance, add_client.officer,
      SYSDATE,0,add_client.record_id); 
END add_client;
/

EXECUTE add_client(1,'Kabylbay','Nurbek','Almaty',1000,2,1);

CREATE OR REPLACE PROCEDURE AUTH_CLIENT(
    cl_id IN A1_CLIENTS.client_id%TYPE,
    auth_officer_id IN A1_CLIENTS.auth_officer_id%TYPE,
IS
BEGIN
    SELECT d.department_name INTO v_officer_dep 
    FROM A6_DEPARTMENTS d 
    WHERE d.DEPARTMENT_ID = (SELECT department_id FROM A5_OFFICER WHERE officer_id = p_auth_officer_id);
    
    CASE v_officer_dep
        WHEN 'AUTH' THEN 
            UPDATE A1_CLIENT 
            SET STATUS = 1, auth_officer_id = p_auth_officer_id 
            WHERE CLIENT_ID = p_client_id;
        WHEN 'ADD' THEN 
            DBMS_OUTPUT.PUT_LINE('Not enough previligies');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Not enough previligies');
        END CASE;
    
END AUTH_ADD_CLIENT;
/


