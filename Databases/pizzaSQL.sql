
create table person  (
name nvarchar(40),
age int NOT NULL,
gender nvarchar(6) NOT NULL,
PRIMARY KEY (name));

create table frequents (
name nvarchar(40),
pizzeria nvarchar(40),
PRIMARY KEY (name, pizzeria)); 

create table eats (
name nvarchar(40),
pizza nvarchar(40),
PRIMARY KEY (name, pizza));


create table serves(
pizzeria nvarchar(40),
pizza nvarchar(40),
price decimal(6,2) NOT NULL,
PRIMARY KEY (pizzeria, pizza)); 

insert into person values ('Amy', 16, 'female');
insert into person values ('Ben', 21, 'male');
insert into person values ('Cal', 33, 'male');
insert into person values ('Dan', 13, 'male');
insert into person values ('Eli', 45, 'male');
insert into person values ('Fay', 21, 'female');
insert into person values ('Gus', 24, 'male');
insert into person values ('Hil', 30, 'female');
insert into person values ('Ian', 18, 'male');

insert into frequents values ('Amy',	'Pizza Hut');
insert into frequents values ('Ben',	'Chicago Pizza');
insert into frequents values ('Ben',	'Pizza Hut');
insert into frequents values ('Cal',	'New York Pizza');
insert into frequents values ('Cal',	'Straw Hat');
insert into frequents values ('Dan',	'New York Pizza');
insert into frequents values ('Dan',	'Straw Hat');
insert into frequents values ('Eli',	'Chicago Pizza');
insert into frequents values ('Eli',	'Straw Hat');
insert into frequents values ('Fay',	'Dominos');
insert into frequents values ('Fay',	'Little Caesars');
insert into frequents values ('Gus',	'Chicago Pizza');
insert into frequents values ('Gus',	'Pizza Hut');
insert into frequents values ('Hil',	'Dominos');
insert into frequents values ('Hil',	'Pizza Hut');
insert into frequents values ('Hil',	'Straw Hat');
insert into frequents values ('Ian', 'Dominos');
insert into frequents values ('Ian',	'New York Pizza');
insert into frequents values ('Ian',	'Straw Hat');

select * from frequents;

insert into eats values ('Amy',	'mushroom');
insert into eats values ('Amy',	'pepperoni');
insert into eats values ('Ben',	'cheese');
insert into eats values ('Ben',	'pepperoni');
insert into eats values ('Cal',	'supreme');
insert into eats values ('Dan',	'cheese');
insert into eats values ('Dan',	'mushroom');
insert into eats values ('Dan',	'pepperoni');
insert into eats values ('Dan',	'sausage');
insert into eats values ('Dan',	'supreme');
insert into eats values ('Eli',	'cheese');
insert into eats values ('Eli',	'supreme');
insert into eats values ('Fay',	'mushroom');
insert into eats values ('Gus',	'cheese');
insert into eats values ('Gus',	'mushroom');
insert into eats values ('Gus',	'supreme');
insert into eats values ('Hil',	'cheese');
insert into eats values ('Hil',	'supreme');
insert into eats values ('Ian',	'pepperoni');
insert into eats values ('Ian',	'supreme');

select * from eats;

insert into serves values ('Chicago Pizza',	'Cheese',	7.75);
insert into serves values ('Chicago Pizza',	'supreme',	8.5);
insert into serves values ('Dominos',	'Cheese',	9.75);
insert into serves values ('Dominos',	'mushroom',	11);
insert into serves values ('Little Caesars',	'Cheese',	7);
insert into serves values ('Little Caesars',	'mushroom',	9.25);
insert into serves values ('Little Caesars',	'pepperoni',	9.75);
insert into serves values ('Little Caesars',	'sausage',	9.5);
insert into serves values ('New York Pizza',	'Cheese',	7);
insert into serves values ('New York Pizza',	'pepperoni',	8.5);
insert into serves values ('New York Pizza',	'supreme',	9);
insert into serves values ('Pizza Hut',	'Cheese',	9);
insert into serves values ('Pizza Hut',	'pepperoni',	12);
insert into serves values ('Pizza Hut',	'sausage',	12);
insert into serves values ('Pizza Hut',	'supreme',	12);
insert into serves values ('Straw Hat',	'Cheese',	9.25);
insert into serves values ('Straw Hat',	'pepperoni',	8);
insert into serves values ('Straw Hat',	'sausage',	9.75);

select * from serves;

--1. Find all pizzas eaten by at least one male over the age of 15.

select distinct pizza
from eats e, person p
where e.name = p.name and age > 15 and gender = 'male';

-- Query qith nested subqueries. Set Membership
select distinct pizza
from eats
where eats.name in 
(select name
from person
where age > 15 and gender = 'female');

-- Query with join
select distinct pizza
from eats inner join person on
	eats.name = person.name 
	where age > 15 and gender = 'male';

--2. Find the names of all females who eat at least one pizza served by Straw Hat.
select person.name
from person, serves, eats
where person.gender = 'female' and serves.pizzeria = 'Straw Hat'
		and person.name = eats.name and eats.pizza = serves.pizza;

select person.name
from (person join  eats on person.name = eats.name ) 
	join  serves on eats.pizza = serves.pizza 
where person.gender = 'female' and serves.pizzeria = 'Straw Hat';

select name from person where  gender = 'female' and name IN (
	select e.name from eats e where e.pizza IN (
 select serves.pizza from serves where serves.pizzeria = 'Straw Hat'));
	

--3. Find all pizzerias that serve at least one pizza for less than $10 that either Amy or Fay (or both) eat.

--4. Find all pizzerias frequented by at least one person under the age of 18.


--5. Find the names of all females who eat either mushroom or pepperoni pizza (or both).

--6. Find all pizzerias that serve at least one pizza that Amy eats for less than $10.00.

--1.	Find all pizzerias that serve at least one pizza for less than $10 that both Amy and Fay eat.
select serves.pizzeria
from serves
where serves.price < 10.00 and serves.pizza in (
			select e1.pizza
			from eats e1, eats e2
			where e1.pizza = e2.pizza and 
				e1.name = 'amy' and e2.name = 'fay');


select serves.pizzeria
from serves
where serves.price < 10.00 and serves.pizza in (
select e1.pizza
from eats e1
where e1.name = 'Amy'
		intersect
select e1.pizza
from eats e1
where e1.name = 'Fay');

--2.	Find the names of all people who eat at least one pizza served by Dominos but who do not frequent Dominos.


--3.	Find the names of all females who eat both mushroom and pepperoni pizza.

--4.	Find all pizzerias that are frequented by only females or only males.

--5.	For each person, find all pizzas the person eats that are not served by any pizzeria the person frequents. 
--Return all such person (name) / pizza pairs.

select *
from eats
EXCEPT
select name, pizza
from frequents, serves
where frequents.pizzeria = serves.pizzeria;

--6.	Find the names of all people who frequent only pizzerias serving at least one pizza they eat.
--7.	Find the names of all people who frequent every pizzeria serving at least one pizza they eat.
--8.	Find the pizzeria serving the cheapest pepperoni pizza. In the case of ties, return all of the cheapest-pepperoni pizzerias.



