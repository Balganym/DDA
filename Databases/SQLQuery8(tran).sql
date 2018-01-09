select * from cust_acc

select * from A_transactions

select * from Transactions

select * from Transfer

exec insert_to_A @ac_id1 = 4, @ac_id2 = 5, @name1 = Almat,@surname1 = Kenen, @name2 = Almat , @surname2 = Kenen, @amount = 20000
exec insert_to_A @ac_id1 = 1, @ac_id2 = null, @name1 = Balganym,@surname1 = Tulebayeva, @name2 = null , @surname2 = null, @amount = -100000
exec insert_to_A @ac_id1 = 2, @ac_id2 = null, @name1 = Akzharkyn,@surname1 = Sagidullina, @name2 = null , @surname2 = null, @amount = 4090
exec insert_to_A @ac_id1 = 3, @ac_id2 = 4, @name1 = Indira,@surname1 = Baimbetova, @name2 = Almat, @surname2 = Kenen, @amount = 2000000

exec fromA_toTran

select * from cust_acc