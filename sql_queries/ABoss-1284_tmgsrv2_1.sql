select * 
from tmg_customer.dialPlan dp
	left join tmg_customer.dialHistory dh ON dp.lastDialHistRef = dh.reference
where dialplanReferenceDate = curdate();

select * from tmg_customer.dialHistory where id=153639; -- and created > '2012-08-20';
select * from tmg_customer.dialPlan where id=153639; -- created>=curdate();

-- select dialplanReferenceDate, dialplanReferenceTime, lastDialHistRef

select created, reference, id, CAST(created AS Date) as dialplanReferenceDate, CAST(created AS Time)  as dialplanReferenceTime
from tmg_customer.dialHistory limit 20;