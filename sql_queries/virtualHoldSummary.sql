-- ....................................................

select * from tmg_customer.dialHistory where created > '2017-11-29 12:00' and created < '2017-11-29 23:00' and projectJob='StigProsjekt/VirtualHoldPhonect' order by created asc;
select * from tmg_customer.virtualhold where timestamp > '2017-11-29 12:00' and timestamp < '2017-11-29 23:00' order by timestamp asc;
-- ....................................................

select 
	vh.id as vhId,
	vh.timestamp as vhTimestamp,
	vh.customerActivityId as vhCustomerActivityId,
	vh.givenToAgent as vhGivenToAgent,
	vh.project as vhProject,
	vh.job as vhJob,
	vh2.id as vhNextId,
	vh2.timestamp AS vhNextTimestamp,
	(select 
		dh.reference
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as dhReferense,
	(select 
		dh.created
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as dhCreated,
	(select 
		dh.callState
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as dhCallState,
	(select 
		dh.contactResponse
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as dhContactResponse
	from tmg_customer.virtualhold vh
		left join tmg_customer.virtualhold vh2 on vh.customerActivityId = vh2.customerActivityId
	where vh.timestamp > '2017-11-29 12:00' 
		and vh.timestamp <= '2017-11-29 23:00'
		-- and vh2.customerActivityId = vh.customerActivityId
		and (vh2.timestamp > vh.timestamp or vh2.timestamp = (select timestamp from tmg_customer.virtualhold vh3 where vh3.timestamp >= '2017-11-29 12:00' order by timestamp desc limit 1 ))
	group by vh.id
	order by vh.timestamp asc;

