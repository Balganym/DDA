Create view Accounts_with_types
	as
		Select ac_id, balance, ac_type, customer_id 
			from AccountType t 
			join Account a on 
			t.ac_type_id = a.ac_type_id


Select c_id, fname, sname, ac_id, balance,ac_type
	from Customers c
	 right outer join Accounts_with_types a on 
		c.c_id = a.customer_id 

Select * from  Accounts_with_types

create view all_information
	as
	Select c_id, fname, sname, ac_id, balance,ac_type
		from Customers c
		right outer join Accounts_with_types a on 
			c.c_id = a.customer_id 

Select * from all_information