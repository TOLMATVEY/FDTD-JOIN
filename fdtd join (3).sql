-- Подготовка таблиц
drop table seil_salary_hist;
drop table seil_departments_hist;

create table seil_salary_hist( 
id int, 
salary int, 
start_dt timestamp,
end_dt timestamp);

create table seil_departments_hist(
id int,
department varchar(20),
start_dt timestamp,
end_dt timestamp);
 
----------------------------------------------------
--заполнение таблиц 1
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (1, 5000, '2012-12-12', '2015-12-12' );
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (1, 10000, '2015-12-13', '2017-12-12' );
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (1, 20000, '2017-12-13', '2020-12-12' );

insert into seil_departments_hist( id, department, start_dt, end_dt)
values (1, 'office1', '2012-12-12', '2016-12-12');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (1, 'office2', '2016-12-13', '2020-12-12');

--решение 1.1
with tab as(
	select id, start_dt::date start_dt, 
		   coalesce(lead(start_dt) over(partition by id order by start_dt) - interval '1 day',to_date('2999-12-12', 'yyyy-mm-dd'))::date as end_dt 
	from 
	(
		select id, start_dt from seil_salary_hist sh 
	    union
	    select id, start_dt from seil_departments_hist dh	    
   	) t
)
select t.id, t.start_dt, t.end_dt, 
	sh.salary,-- sh.start_dt, sh.end_dt
	dh.department--, dh.start_dt, hd.end_dt
from tab t left join seil_salary_hist sh 
	on t.id=sh.id and t.start_dt between sh.start_dt and sh.end_dt
		   left join seil_departments_hist dh 
	on t.id=dh.id and t.start_dt between dh.start_dt and dh.end_dt;

-- решение 1.2
select sh.id, sh.salary, dh.department,
	   case when sh.start_dt between dh.start_dt and dh.end_dt then sh.start_dt
	   		when dh.start_dt between sh.start_dt and sh.end_dt then dh.start_dt end start_dt,
	   case when sh.start_dt between dh.start_dt and dh.end_dt then least(sh.end_dt, dh.end_dt)
	   		when dh.start_dt between sh.start_dt and sh.end_dt then least(sh.end_dt, dh.end_dt) end end_dt
	   --, sh.start_dt, sh.end_dt, dh.start_dt, dh.end_dt
from seil_salary_hist sh inner join seil_departments_hist dh
--on sh.id = dh.id and (sh.start_dt between dh.start_dt and dh.end_dt or dh.start_dt between sh.start_dt and sh.end_dt)
on sh.id = dh.id and dh.start_dt<=sh.end_dt and sh.start_dt<=dh.end_dt;
----------------------------------------------------
--заполнение таблиц 2
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (1, 20000, '2012-12-12', '2020-01-26' );
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (1, 23000, '2020-01-27', '2999-12-12');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (2, 25000, '2018-01-04', '2019-03-10');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (2, 2000, '2019-03-11', '2999-12-12');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (3, 50000, '2013-02-20', '2015-12-01');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (3, 55000, '2015-12-02', '2020-07-22');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (3, 10000, '2020-07-23', '2999-12-12');
insert into seil_salary_hist (id, salary, start_dt, end_dt)
values (4, 32000, '2017-10-23', '2999-12-12');

insert into seil_departments_hist( id, department, start_dt, end_dt)
values (1, 'office', '2015-04-04', '2999-12-12');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (2, 'office', '2018-04-04', '2019-01-01');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (2, 'cppd', '2019-01-02', '2022-12-30');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (2, 'ccppnn', '2022-12-31', '2999-12-12');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (3, '1-o', '2010-10-02', '2014-11-06');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (3, '1-oy', '2016-10-02', '2020-11-06');
insert into seil_departments_hist( id, department, start_dt, end_dt)
values (3, '1-zzzz', '2020-11-07', '2999-12-12');