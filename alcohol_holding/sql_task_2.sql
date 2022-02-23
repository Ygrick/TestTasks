use master;

with 
	ref_goods_t as (
		select rg.id, rg.good_name, rgg.good_group_name 
		from ref_good_groups as rgg 
		left join ref_goods as rg 
		on rgg.id = rg.id_good_group),

	docs_t as (
		select docs.id, rgt.good_name, rgt.good_group_name, docs.s_date, docs.amount, docs.rate 
		from docs 
		left join ref_goods_t as rgt
		on rgt.id = docs.id_good
	), 

	docs_t2 as (
		select  
			CASE
				WHEN day(s_date)>=23 THEN 4
				WHEN day(s_date)>=16 THEN 3
				WHEN day(s_date)>=9  THEN 2
				WHEN day(s_date)>=1  THEN 1
			END WeekNum,
			*
			-- MAX(s_date) over(partition by WeekNum)
		from docs_t 
		where year(s_date) = 2013 and MONTH(s_date) = 12
	)

-- DATEPART(month, GETDATE())

select WeekNum, id, good_name, good_group_name, s_date, amount, rate 
from (
		select *, 
		MAX(s_date) over(partition by WeekNum, good_name, rate) as my_date
		from docs_t2) as t 
where s_date = my_date and rate = 1