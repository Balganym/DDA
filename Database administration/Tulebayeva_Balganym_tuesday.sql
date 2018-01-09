CREATE TABLE A6_DEPARTMENTS (
  department_id   NUMBER(10),
  department_name VARCHAR2(50),
  CONSTRAINT department_id_pk PRIMARY KEY (department_id)
)

INSERT INTO A6_DEPARTMENTS(department_id, department_name)    
VALUES (1, 'ADD');

INSERT INTO A6_DEPARTMENTS(department_id, department_name)    
VALUES (2, 'AUTH');

CREATE TABLE A5_OFFICERS (
  officer_id NUMBER(10),
  fisrt_name VARCHAR2(50),
  last_name VARCHAR2(50),
  department_id NUMBER(10),
  CONSTRAINT officer_id_pk PRIMARY KEY (officer_Id),
  FOREIGN KEY (department_id) REFERENCES A6_DEPARTMENTS(department_id)
)

INSERT INTO A5_OFFICERS(officer_id, first_name, last_name, department_id)    
VALUES (1,'Kuanysh', 'Rakhmetov', 1);

INSERT INTO A5_OFFICERS(officer_id, first_name, last_name, department_id)    
VALUES (2,'Arthur', 'Abdalimov', 2);

CREATE TABLE A1_CLIENTS(
  cl_id NUMBER(6),
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  address VARCHAR2(50),
  officer_id NUMBER(6),
  auth_officer_id NUMBER(6),
  status NUMBER(1),
  CONSTRAINT cl_id_pk PRIMARY KEY (cl_id),
  FOREIGN KEY (officer_id) REFERENCES A5_OFFICERS(officer_id),
  FOREIGN KEY (auth_officer_id) REFERENCES A5_OFFICERS(officer_id)
)

CREATE TABLE A4_ACCOUNTS(
  ac_id NUMBER(6),
  cl_id NUMBER(6),
  balance NUMBER(8),
  ammend_date DATE,
  auth_date DATE,
  CONSTRAINT ac_id_pk PRIMARY KEY (ac_id),
  FOREIGN KEY (cl_id) REFERENCES A1_CLIENTS(cl_id)
)

CREATE TABLE A3_TRANSACTIONS(
  transaction_id NUMBER(6),
  ac_id NUMBER(6),
  amount NUMBER(8, 2),
  balance NUMBER(8, 2),
  commit_date DATE,
  FOREIGN KEY (ac_id) REFERENCES A4_ACCOUNTS(ac_id)
)

CREATE TABLE A2_UPDATED(
  cl_id NUMBER(6),
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  address VARCHAR2(50),
  officer_id NUMBER(6),
  auth_officer_id NUMBER(6),
  status NUMBER(1),
  UPDATE_DATE DATE default SYSDATE,
  FOREIGN KEY (cl_id) REFERENCES A1_CLIENTS(cl_id)
);

CREATE SEQUENCE s_clients_seq
  START WITH 1
  INCREMENT BY 1
  CACHE 100
  NOCYCLE;

CREATE SEQUENCE s_transactions_seq
  START WITH 1
  INCREMENT BY 1
  CACHE 100
  NOCYCLE;

CREATE OR REPLACE PROCEDURE add_client(
    p_first_name in A1_CLIENTS.first_name%type,
    p_last_name  in A1_CLIENTS.last_name%type,
    p_address    in A1_CLIENTS.address%type,
    p_officer_id in A1_CLIENTS.officer_id%type,
    p_status     in A1_CLIENTS.status%type default 0)
IS
    v_officer_dep A6_DEPARTMENTS.department_name%TYPE;
BEGIN
    
    SELECT d.department_name INTO v_officer_dep 
    FROM A6_DEPARTMENTS d 
    WHERE d.DEPARTMENT_ID = (SELECT department_id FROM A5_OFFICERS WHERE officer_id = p_officer_id);
    
    CASE v_officer_dep
        WHEN 'ADD' THEN 
          INSERT INTO A1_CLIENTS(client_id, first_name, last_name, address, officer_id, auth_officer_id, status)
          VALUES (S_CLIENTS_SEQ.nextval, p_first_name, p_last_name, p_address, p_officer_id, NULL, p_status);
        ELSE 
          DBMS_OUTPUT.PUT_LINE('Not enough previligies');
        END CASE;
END add_client;
/

EXECUTE add_client('Balganym', 'Tulebayeva', 'KBTU', 1, 0);

CREATE OR REPLACE PROCEDURE auth_client(
    p_client_id IN A1_CLIENTS.client_id%TYPE,
    p_auth_officer_id IN A1_CLIENTS.auth_officer_id%TYPE)
IS
    v_officer_dep A6_DEPARTMENTS.department_name%TYPE;
BEGIN
    SELECT d.department_name INTO v_officer_dep 
    FROM A6_DEPARTMENTS d 
    WHERE d.department_id = (SELECT department_id FROM A5_OFFICERS 
        WHERE officer_id = p_auth_officer_id);
    
    CASE v_officer_dep
        WHEN 'AUTH' THEN 
            UPDATE A1_CLIENTS 
            SET STATUS = 1, auth_officer_id = p_auth_officer_id 
            WHERE CLIENT_ID = p_client_id;
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Not enough previligies');
        END CASE;
END auth_client;
/

EXECUTE auth_client(1, 2);

CREATE OR REPLACE PROCEDURE update_client(
    p_cl_id IN A1_CLIENTS.cl_id%TYPE,
    p_first_name IN A1_CLIENTS.first_name%TYPE,
    p_last_name IN A1_CLIENTS.last_name%TYPE,
    p_address IN A1_CLIENTS.address%TYPE)
IS
    v_officer_id A1_CLIENTS.officer_id%TYPE;
    v_officer_auth_id A1_CLIENTS.auth_officer_id%TYPE;
BEGIN

    SELECT officer_id, auth_officer_id 
    INTO v_officer_id, v_officer_auth_id
    FROM A1_CLIENTS 
    WHERE client_id = p_client_id;

    INSERT INTO A2_UPDATED(client_id, first_name, last_name, address, officer_id, auth_officer_id)
    VALUES (p_client_id, p_first_name, p_last_name, p_address, v_officer_id, v_officer_auth_id);
    
    UPDATE A1_CLIENTS 
    SET first_name = p_first_name, last_name = p_last_name, address = p_address
    WHERE client_id = p_client_id;
END update_client;
/

CREATE OR REPLACE PROCEDURE auth_delete(
    p_client_id IN A2_UPDATED.client_id%TYPE)
IS
BEGIN
    UPDATE A1_CLIENTS SET STATUS = 3 WHERE client_id = p_client_id;
    UPDATE A2_UPDATED SET STATUS = 3 WHERE client_id = p_client_id;
END;
/

CREATE OR REPLACE PROCEDURE delete_cl(
    p_client_id IN A1_CLIENTS.client_id%TYPE)
IS
BEGIN
    UPDATE A1_CLIENTS SET STATUS = 2 WHERE client_id = p_client_id;
END;

/

CREATE OR REPLACE FUNCTION get_client(
  p_officer_id in A1_CLIENTS.officer_id%type)
RETURN SYS_REFCURSOR
IS
  v_info SYS_REFCURSOR;
BEGIN
  OPEN v_info FOR
    SELECT c.first_name, c.last_name, c.address, a.balance
    FROM A1_CLIENTS c, A4_ACCOUNTS a
    WHERE c.client_id = a.client_id AND c.officer_id = p_officer_id;
  RETURN v_info;
END;
/

CREATE OR REPLACE FUNCTION add_balance(
    p_client_id IN A1_CLIENTS.client_id%TYPE,
    p_account_id IN A4_ACCOUNTS.account_id%type,
    p_amount IN A3_TRANSACTIONS.amount%TYPE) RETURN NUMBER
IS
    v_balance A4_ACCOUNTS.balance%type;
    v_result_status NUMBER;
BEGIN
    SELECT balance INTO v_balance
        FROM A4_ACCOUNTS
        WHERE account_id = p_account_id;
        INSERT INTO A3_TRANSACTIONS(transaction_id, account_id, amount, balance, commit_date)
        VALUES(s_transactions_seq.nextval, p_account_id, p_amount, v_balance + p_amount, sysdate);        
        v_result_status := 0;
    END IF;
    RETURN(v_result_status);
END add_balance;
/

CREATE OR REPLACE FUNCTION withdraw(
    p_client_id IN A1_CLIENTS.client_id%TYPE,
    p_account_id IN A4_ACCOUNTS.account_id%type,
    p_amount IN A3_TRANSACTIONS.amount%TYPE) RETURN NUMBER
IS
    v_balance A4_ACCOUNTS.balance%type;
    v_result_status NUMBER;
BEGIN
    SELECT balance INTO v_balance
        FROM A4_ACCOUNTS
        WHERE account_id = p_account_id;
    IF (v_balance - p_amount > 0) THEN
        INSERT INTO A3_TRANSACTIONS(transaction_id, account_id, amount, balance, commit_date)
        VALUES(s_transactions_seq.nextval, p_account_id, p_amount, v_balance - p_amount, sysdate);        
        v_result_status := 0;
    ELSE
        v_result_status := -1;
    END IF;
    RETURN(v_result_status);
END withdraw;
/

DECLARE
  l_clients SYS_REFCURSOR;
  v_last_name A1_CLIENTS.last_name%TYPE;
  v_first_name A1_CLIENTS.first_name%TYPE;
  v_address A1_CLIENTS.address%TYPE;
  v_balance A1_CLIENTS.balance%TYPE;
BEGIN
  l_clients := get_client(&officer_id);
  LOOP
    FETCH l_clients INTO v_last_name, v_first_name, v_address, v_balance;
    EXIT WHEN l_clients%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name || ', last name: ' || v_last_name
                        || ', address: ' || v_address || ', balance: '|| v_balance);
  END LOOP;
END;
/
