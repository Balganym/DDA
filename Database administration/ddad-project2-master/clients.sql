  
  INSERT INTO 
    B6_DEPARTMENTS (department_id, department_name)
  VALUES (1, 'Finance');

  INSERT INTO 
    B5_OFFICER (officer_id, first_name, last_name, department_id) 
  VALUES (s_officers_seq.nextval, 'Nurbek', 'Kabylbai', 1);

  EXECUTE client_pkg.add_client('Mariyam', 'Sisengali', 
    'Aiteke bi street, 16', 1, '+7(777)4566767');

  EXECUTE client_pkg.auth_client(1, 1);

  EXECUTE client_pkg.add_client('Firuza', 'Mamirova', 
    'Magzhan Zhumabayev street, 57', 1, '+7(747)6642378');

  EXECUTE client_pkg.auth_client(2, 1);

  EXECUTE client_pkg.update_client(1, 'Mariyam', 'Sisengali', 'Kazybek bi 47', 1, 200);

  EXECUTE client_pkg.delete_client(2);

  EXECUTE client_pkg.auth_delete_client(2, 1);

  EXECUTE client_pkg.check_credit_score(1);
  EXECUTE client_pkg.add_new_card(1, 'USD');

  EXECUTE card_pkg.create_client_payment(1, 0.5, SYSDATE);
  EXECUTE card_pkg.make_client_payment(1, 100);
