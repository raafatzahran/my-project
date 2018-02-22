-- correct example
-- ---------------

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
	q.TIME >= '2018-02-07 00:00:00.0' AND 
	q.TIME < '2018-02-07 23:55:00.0' 

GROUP BY ql.callId 
HAVING state IS NOT NULL AND 
	state IN ('answer')  AND
	peerNumber IN (965190773)
ORDER BY callDate LIMIT 0,50;

select * from tmg_asterisk.queue_log where callid=1518026907.8447 ;

SELECT * from tmg_customer.dialHistory where originatingCallId=1518026907.8447;

SELECT * from tmg_customer.dialHistory where customerId in ('+351965190773');

select * from tmg_customer.recordedFiles where  callId='1518026924.8451'; -- id in (1438010); 


SELECT projectJob,id,customerId,reference,created,callid,callerid,dialStart,dialEnd,conversationStarted,callState,contactResponse 
from tmg_customer.dialHistory 
where created >= '2018-02-07 00:00:00.0' and projectJob='PT-Telco/NowoInbound'
order by id desc;


-- create RecordingDetails:
SELECT *
FROM asteriskcdrdb.cdr
where disposition = 'ANSWERED' and recordingfile in ('external-3779-965190773-20180207-190844-1518026924.8451.wav',
		'q-30-965190773-20180207-190827-1518026907.8447.wav')
        GROUP BY uniqueid;

SELECT linkedid FROM asteriskcdrdb.cel WHERE eventtype='CHAN_END' AND uniqueid in (1518026924.8451); -- linkedid=1518026907.8447

SELECT id, callId FROM tmg_customer.dialHistory WHERE originatingCallId = 1518026907.8447 LIMIT 1; -- id='1437990', callId='1518026924.8451'

-- .uniqueId(resultSet.getString(("callId")))
-- .customerActivityId(resultSet.getString(("id")))
-- .dialHistoryEntryPresent(true)

-- if dialHistoryEntryPresent(true) --> process the file record

