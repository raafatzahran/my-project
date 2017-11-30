-- ....................................................
select id, projectJob, reference, created, callState, contactResponse, callLength, customerId, dialHistoryIndex   from tmg_customer.dialHistory where created > '2017-11-28 12:00' and created < '2017-11-29 23:00' order by created asc;
select * from tmg_customer.virtualhold where timestamp > '2017-11-28 12:00' and timestamp < '2017-11-29 23:00' order by timestamp asc;
-- select * from tmg_customer.jobCustomer jc where jc.prospect > '2017-11-20 12:00';
-- ....................................................
-- All rows
select 
	vh.id as vhId,
	vh.timestamp as callDate,
	vh.customerActivityId as customerId,
	vh.givenToAgent as agent,
	vh.project as project,
	vh.job as job,
	vh.fromAddress as peerNumber ,
	vh.toAddress as yourNumber,
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
	) as dhContactResponse,
	(select 
		dh.callLength
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as duration,
	(select 
		dh.created - vh.timestamp
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as waittime
	from tmg_customer.virtualhold vh
		left join tmg_customer.virtualhold vh2 on vh.customerActivityId = vh2.customerActivityId
	where vh.timestamp > '2017-11-28 12:00' 
		and vh.timestamp <= '2017-11-29 23:00'
		and (vh2.timestamp > vh.timestamp or vh2.timestamp = (select timestamp from tmg_customer.virtualhold vh3 where vh3.timestamp >= '2017-11-28 12:00' order by timestamp desc limit 1 ))
	group by vh.id
	order by vh.timestamp asc
	LIMIT 0,50;
-- ====================================
-- processed rows
select 
	vh.id as vhId,
	vh.timestamp as callDate,
	vh.customerActivityId as customerId,
	vh.givenToAgent as agent,
	vh.project as project,
	vh.job as job,
	vh.fromAddress as peerNumber ,
	vh.toAddress as yourNumber,
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
	) as dhContactResponse,
	(select 
		dh.callLength
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as duration,
	(select 
		dh.created - vh.timestamp
	from 
		tmg_customer.dialHistory dh
    where 
	dh.id = vh.customerActivityId and
	(dh.created > vh.timestamp) and 
	(dh.created < vh2.timestamp or vh.timestamp = vh2.timestamp)
	order by dh.created desc
	Limit 1
	) as waittime
	from tmg_customer.virtualhold vh
		left join tmg_customer.virtualhold vh2 on vh.customerActivityId = vh2.customerActivityId
	where vh.timestamp > '2017-11-28 12:00' 
		and vh.timestamp <= '2017-11-29 23:00'
		and (vh2.timestamp > vh.timestamp or vh2.timestamp = (select timestamp from tmg_customer.virtualhold vh3 where vh3.timestamp >= '2017-11-28 12:00' order by timestamp desc limit 1 ))
	group by vh.id
	HAVING dhCallState IS NOT NULL
	AND dhCallState IN ('contact')
	order by vh.timestamp asc
	LIMIT 0,50;
-- ====================================
