select 

MAX(CASE ql.EVENT 
WHEN 'ABANDON' THEN 'noAnswer'
WHEN 'EXITEMPTY' THEN 'noAnswer'
WHEN 'EXITWITHTIMEOUT' THEN 'timeout'
WHEN 'EXITWITHKEY' THEN 'virtualHold'
WHEN 'COMPLETEAGENT' THEN 'answer'
WHEN 'COMPLETECALLER' THEN 'answer'
WHEN 'TRANSFER' THEN 'answer'
ELSE NULL END) AS state,

MAX(CASE ql.EVENT WHEN 'DID' THEN ql.data1 ELSE NULL END) AS yourNumber,
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.data2 ELSE NULL END) AS peerNumber,
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.TIME ELSE NULL END) AS callDate,
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.queuename ELSE NULL END) AS queueId,
MAX(CASE ql.EVENT WHEN 'CONNECT' THEN ql.data2 ELSE NULL END) AS callIdTowardsAgent,
MAX(CASE ql.EVENT WHEN 'CONNECT' THEN ql.agent ELSE NULL END) AS agent,
SUM(CASE ql.EVENT WHEN 
'COMPLETEAGENT' THEN ql.data2 
WHEN 'COMPLETECALLER' THEN ql.data2
WHEN 'TRANSFER' THEN ql.data4
ELSE 0 END) AS duration,
SUM(CASE ql.EVENT
WHEN 'ABANDON' THEN ql.data3
WHEN 'EXITEMPTY' THEN ql.data3
WHEN 'EXITWITHTIMEOUT' THEN ql.data3
WHEN 'EXITWITHKEY' THEN ql.data4
WHEN 'CONNECT' THEN ql.data1
ELSE 0 END) AS waittime,
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.callid ELSE NULL END) AS calll

FROM tmg_asterisk.queue_log ql IGNORE INDEX(EVENT)
LEFT JOIN tmg_asterisk.queue_log q IGNORE INDEX(EVENT) ON ql.callid=q.callid
WHERE 
q.EVENT='ENTERQUEUE'
AND ql.EVENT IN ('ENTERQUEUE', 'DID', 'CONNECT', 'COMPLETEAGENT', 'COMPLETECALLER', 'TRANSFER',
														'EXITWITHKEY', 'ABANDON', 'EXITEMPTY', 'EXITWITHTIMEOUT')
AND q.queuename NOT LIKE '1____'
AND q.TIME > '2017-11-29 12:00'
AND q.TIME < '2017-11-29 23:00'
GROUP BY ql.callId
HAVING state IS NOT NULL
AND state IN ('timeout', 'virtualHold')
ORDER BY callDate ASC;
-- ....................................................
Select * FROM tmg_asterisk.queue_log ql IGNORE INDEX(EVENT) where ql.TIME > '2017-11-29 12:00'AND ql.TIME < '2017-11-29 23:00';
select id, reference, created, callState, contactResponse, agent, callLength from tmg_customer.dialHistory where created > '2017-11-29 12:00' and created < '2017-11-29 23:00' and projectJob='StigProsjekt/VirtualHoldPhonect' order by created asc;
select id, customerActivityId, timestamp, project, job, givenToAgent from tmg_customer.virtualhold where timestamp > '2017-11-29 12:00' and timestamp < '2017-11-29 23:00' order by timestamp asc;
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

