-- Incorrect examples: --> zd:10035
-- --------------------------------
SELECT 
ql.id,ql.callid,
MAX(CASE ql.EVENT WHEN 'ABANDON' THEN 'noAnswer' 
WHEN 'EXITEMPTY' THEN 'noAnswer' 
WHEN 'EXITWITHTIMEOUT' THEN 'timeout' 
WHEN 'EXITWITHKEY' THEN 'virtualHold' 
WHEN 'COMPLETEAGENT' THEN 'answer' 
WHEN 'COMPLETECALLER' THEN 'answer' 
WHEN 'TRANSFER' THEN 'answer' ELSE NULL END) AS state, 

SUM(CASE ql.EVENT WHEN 'ABANDON' THEN ql.data3 
WHEN 'EXITEMPTY' THEN ql.data3 
WHEN 'EXITWITHTIMEOUT' THEN ql.data3 
WHEN 'EXITWITHKEY' THEN ql.data4 
WHEN 'CONNECT' THEN ql.data1 ELSE 0 END) AS waittime, 

SUM(CASE ql.EVENT WHEN 'COMPLETEAGENT' THEN ql.data2 
WHEN 'COMPLETECALLER' THEN ql.data2 
WHEN 'TRANSFER' THEN ql.data4 ELSE 0 END) AS duration, 

MAX(CASE ql.EVENT WHEN 'CONNECT' THEN ql.agent ELSE NULL END) AS agent, 
MAX(CASE ql.EVENT WHEN 'CONNECT' THEN ql.data2 ELSE NULL END) AS callIdTowardsAgent, 
ql.callid AS originalCallId, 
MAX(CASE ql.EVENT WHEN 'DID' THEN ql.data1 ELSE NULL END) AS yourNumber, 
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.TIME ELSE NULL END) AS callDate, 
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.data2 ELSE NULL END) AS peerNumber, 
MAX(CASE ql.EVENT WHEN 'ENTERQUEUE' THEN ql.queuename ELSE NULL END) AS queueId 

FROM tmg_asterisk.queue_log ql IGNORE INDEX(EVENT) 
	LEFT JOIN tmg_asterisk.queue_log q IGNORE INDEX(EVENT) 
		ON ql.callid=q.callid 

WHERE  q.EVENT='ENTERQUEUE'  AND 
	ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
	q.queuename NOT LIKE '1____' AND 
	q.TIME > '2018-02-07 00:00:00.0' AND 
	q.TIME < '2018-02-07 23:55:00.0' 

GROUP BY ql.callId 
HAVING state IS NOT NULL AND 
	state IN ('answer')  AND
	peerNumber IN (12340000)
ORDER BY callDate LIMIT 0,50;

SELECT * from tmg_customer.dialHistory where created > '2018-02-07 00:00:00.0' and agent='raafatzahran' order by created asc;-- customerId in ('+351272688049', '+351217919139', '+351965536268', '+351968225573','+351253672203', '+351918475000');

SELECT * from tmg_customer.dialPlan where  dialplanReferenceDate >= '2018-02-07';-- phoneNo in ('+4712340000');

select * from tmg_customer.recordedFiles where id in ('5067310','5067311','5067312'); 
