
INSERT INTO `azs`(`mark_id`, `c_date`, `c_l`) VALUES 
	(93, CONVERT("2017-03-01 10:22:42", DATETIME),30),
	(95, CONVERT("2017-03-01 09:22:48", DATETIME),10),
	(95, CONVERT("2017-03-01 10:22:42", DATETIME),12),
	(93, CONVERT("2017-03-02 10:22:42", DATETIME),40),
	(93, CONVERT("2017-03-02 10:20:23", DATETIME),17),
	(95, CONVERT("2017-03-02 10:22:42", DATETIME),32)

INSERT INTO `dict`(`mark_id`, `c_mark`) VALUES 
	(93, "АИ-93"),
	(95, "АИ-95"),
	(95, "АИ-95"),
	(93, "АИ-93"),
	(93, "АИ-93"),
	(95, "АИ-95")


1)SELECT DATE(azs.c_date) c_date, SUM(c_l) FROM azs GROUP BY DATE(azs.c_date)

2)SELECT case when DAYOFWEEK(DATE(a.c_date)) = 2 then "ПН" 
	when DAYOFWEEK(DATE(a.c_date)) = 3 then "ВТ" 
	when DAYOFWEEK(DATE(a.c_date)) = 4 then "СР" 
	when DAYOFWEEK(DATE(a.c_date)) = 5 then "ЧТ" 
	when DAYOFWEEK(DATE(a.c_date)) = 6 then "ПТ" 
	when DAYOFWEEK(DATE(a.c_date)) = 7 then "СБ" 
	else "ВС" end day ,sum(c_l), 
	case when d.c_mark = "АИ-93" then "regular"
	else "super" end mark from azs a 
	JOIN dict d on a.mark_id = d.mark_id 
	GROUP BY d.c_mark, DATE(a.c_date) 
	ORDER BY DATE(a.c_date)

 3)Select res.day, max(res.lit), res.mark 
	From (SELECT case when DAYOFWEEK(DATE(a.c_date)) = 2 then "ПН" 
	when DAYOFWEEK(DATE(a.c_date)) = 3 then "ВТ"
	when DAYOFWEEK(DATE(a.c_date)) = 4 then "СР"
	when DAYOFWEEK(DATE(a.c_date)) = 5 then "ЧТ" 
	when DAYOFWEEK(DATE(a.c_date)) = 6 then "ПТ" 
	when DAYOFWEEK(DATE(a.c_date)) = 7 then "СБ" 
	else "ВС" end day, case when d.c_mark = "АИ-93" 
	then "regular" else "super" end mark,sum(c_l) lit 
	from azs a JOIN dict d on a.mark_id = d.mark_id 
	GROUP BY d.c_mark, DATE(a.c_date) 
	ORDER BY DATE(a.c_date), sum(a.c_l) DESC) res 
	GROUP BY res.day

4)DELETE a FROM azs a, azs aa 
	WHERE a.id > aa.id 
	AND a.c_date = a.c_date 
	AND a.c_l = aa.c_l 
	AND a.mark_id = aa.mark_id




	

4) DELETE FROM azs  
	WHERE id 
	IN (SELECT * FROM (SELECT id FROM azs
		GROUP BY c_date, c_l, mark_id 
			HAVING (COUNT(*) > 1)) AS res);
