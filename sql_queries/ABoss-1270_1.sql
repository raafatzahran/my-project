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
	q.TIME > '2018-01-23 00:00:00.0' AND 
	q.TIME < '2018-01-30 23:55:00.0' 

GROUP BY ql.callId 
HAVING state IS NOT NULL AND 
	state IN ('answer')  AND
	peerNumber IN (272688049, 217919139, 965536268, 968225573, 253672203, 918475000,933522208)
ORDER BY callDate LIMIT 0,50;

SELECT * from tmg_customer.dialHistory where customerId in ('+351272688049', '+351217919139', '+351965536268', '+351968225573','+351253672203', '+351918475000','+351933522208');

SELECT * from tmg_customer.dialPlan where phoneNo in ('+351272688049', '+351217919139', '+351965536268', '+351968225573','+351253672203', '+351918475000','+351933522208');

select * from tmg_customer.recordedFiles where id in (1423515, 1423544,1423481,1427506, 1428158, 1428020,1424606); 
select * from tmg_customer.recordedFiles limit 10;

SELECT projectJob,id,customerId,reference,created,callid,callerid,dialStart,dialEnd,conversationStarted,callState,contactResponse 
from tmg_customer.dialHistory 
where created >= '2018-02-01 00:00:00.0' and projectJob='PT-Telco/NowoInbound'
order by id desc;

SELECT dh.id,rf.id,rf.autoId,rf.created,rf.location,rf.direction
from tmg_customer.dialHistory dh
	left join tmg_customer.recordedFiles rf on dh.id =rf.id
where dh.created >= '2018-02-01 00:00:00.0' and dh.projectJob='PT-Telco/NowoInbound'
order by dh.id desc;

SELECT *
        FROM asteriskcdrdb.cdr
        -- WHERE recordingfile =  AND 
where disposition = 'ANSWERED' and customerActivityId in (1423515, 1423544,1423481,1427506, 1428158, 1428020,1424606) 
        GROUP BY uniqueid limit 10;

SELECT *
        FROM asteriskcdrdb.cdr limit 10;

SELECT *
        FROM asteriskcdrdb.cdr
where disposition = 'ANSWERED' and customerActivityId in (1428018,1427450,1427433)
        GROUP BY uniqueid limit 10;

-- '1517592321.7137'

SELECT *
FROM asteriskcdrdb.cdr
where disposition = 'ANSWERED' and recordingfile in ('external-1049-272688049-20180123-154553-1516718753.2370.wav',
		'external-1049-217919139-20180123-163333-1516721613.2887.wav',
		'external-1048-965536268-20180123-144817-1516715297.2114.wav',
		'external-1048-968225573-20180130-130130-1517313690.1273.wav','q-30-968225573-20180130-130114-1517313674.1271.wav',
		'external-1048-253672203-20180130-173150-1517329910.4213.wav','q-30-253672203-20180130-173133-1517329893.4197.wav',
		'external-1049-918475000-20180130-134253-1517316173.1852.wav','q-30-918475000-20180130-134237-1517316157.1843.wav')
        GROUP BY uniqueid;

SELECT linkedid FROM asteriskcdrdb.cel WHERE eventtype='CHAN_END' AND uniqueid in (1377673163.2,1516715297.2114,1516718753.2370,1516721613.2887,1517313674.1271,1517313690.1273,1517316157.1843,1517316173.1852,1517329893.4197,1517329910.4213 ); -- 1516718753.2370 1516721613.2887 1517313674.1271 1517313690.1273 1517316157.1843 1517316173.1852 1517329893.4197 1517329910.4213
SELECT linkedid FROM asteriskcdrdb.cel WHERE eventtype='CHAN_END' AND uniqueid in (1517308591.445, 1517308608.448, 1517309608.637, 1517309625.639, 1517316030.1787, 1517316046.1800); -- 1517308591.445
SELECT * FROM asteriskcdrdb.cel limit 10;

SELECT id, callId FROM dialHistory WHERE originatingCallId = linkedId LIMIT 1;

-- 1517308591.445, 1517308608.448, 1517309608.637, 1517309625.639, 1517316030.1787, 1517316046.1800