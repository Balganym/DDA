Create proc checkTran
	@ac_id_to int, 
	@ac_id_from int,
	@amount float

	AS

		IF @amount <= (Select balance from Account a where a.ac_id = @ac_id_from)
			begin tran tr1
				INSERT INTO Transfer(ac_id_to, ac_id_from, amount,date, c_id)
				VALUES (@ac_id_to, @ac_id_from, @amount, getdate(), (SELECT TOP 1 customer_id from Account where ac_id = @ac_id_to))
				UPDATE Account
					SET balance = (SELECT TOP 1 balance from Account where ac_id = @ac_id_from) - @amount WHERE ac_id = @ac_id_from
				Update Account
					SET balance = (SELECT TOP 1 balance from Account where ac_id = @ac_id_to) + @amount WHERE ac_id = @ac_id_to

				COMMIT;
	GO

	EXEC  checkTran @ac_id_to = 5, @ac_id_from = 4, @amount = 8

	SELECT * from Transfer
	SELECT * from Account
	Select * from all_information