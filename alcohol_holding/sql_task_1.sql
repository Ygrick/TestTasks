use master;

with 
	YTD_T as
		(select id_good, sum(amount) as Y
		from dbo.sales 
		where year(s_date) = 2017  --2017 заменить на year(getdate())
		group by id_good), 

	MTD_T as
		(select id_good, sum(amount) as M
		from dbo.sales 
		where month(s_date) = month(getdate())
		and year(s_date) = 2017   --2017 заменить на year(getdate())
		group by id_good),

	QTD_T as
		(select id_good, sum(amount) as Q
		from dbo.sales 
		where DATEPART(qq, s_date) = DATEPART(qq, getdate())
		and year(s_date) = 2017   --2017 заменить на year(getdate())
		group by id_good),

	PYTD_T as
		(select id_good, sum(amount) as PY
		from dbo.sales 
		where year(s_date) = 2017 - 1 -- 2017 заменить на year(getdate())
		and s_date <= DATEADD(year, -6, GETDATE()) -- заменить -6 на -1 
		group by id_good),

	PMTD_T as
		(select id_good, sum(amount) as PM
		from dbo.sales 
		where year(s_date) = 2017 - 1 -- 2017 заменить на year(getdate())
		and s_date <= DATEADD(year, -6, GETDATE()) -- заменить -6 на -1 
		and month(s_date) = month(GETDATE())
		group by id_good),

	PQTD_T as
		(select id_good, sum(amount) as PQ
		from dbo.sales 
		where year(s_date) = 2017 - 1 -- 2017 заменить на year(getdate())
		and s_date <= DATEADD(year, -6, GETDATE()) -- заменить -6 на -1 
		and DATEPART(qq, s_date) = DATEPART(qq, getdate())
		group by id_good)


select rg.good_name, Y as YTD, M as MTD, Q as QTD, PY as PYTD, PM as PMTD, PQ as PQTD
from dbo.ref_goods as rg
inner join YTD_T 
	on YTD_T.id_good = rg.id

inner join MTD_T 
	on MTD_T.id_good = rg.id

inner join QTD_T 
	on QTD_T.id_good = rg.id

inner join PYTD_T 
	on PYTD_T.id_good = rg.id

inner join PMTD_T 
	on PMTD_T.id_good = rg.id

inner join PQTD_T 
	on PQTD_T.id_good = rg.id