use master;
DECLARE @cols AS NVARCHAR(MAX),
		@query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.s_date) 
					FROM (select id_good, 
								 convert(varchar(10), s_date, 120) as s_date, 
								 sum(amount) as sum_day
					from sales
					where s_date >= '2014-01-01'and s_date <= '2014-08-01' --ДИАПАЗОГ ДАТ
					group by id_good, s_date) as c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT id_good, ' + @cols + ' from 
            (
                select  id_good, 
						convert(varchar(10), s_date, 120) as s_date, 
						sum(amount) as sum_day
						from sales
						where s_date >= ''2014-01-01'' and s_date <= ''2014-08-01''  --ДИАПАЗОГ ДАТ
						group by id_good, s_date
           ) x
            pivot 
            (
                 max(sum_day)
                 for s_date in (' + @cols + ')
            ) p '
execute(@query)
