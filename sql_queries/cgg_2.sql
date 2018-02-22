-- Incorrect example
-- -----------------

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
	peerNumber IN (212740619)
ORDER BY callDate LIMIT 0,50;

select * from tmg_asterisk.queue_log where callid='1518029584.9216' ;

SELECT * from tmg_customer.dialHistory where originatingCallId='1518029584.9216';

SELECT * from tmg_customer.dialHistory where customerId in ('+351212740619');

select * from tmg_customer.recordedFiles where  callId='1518029584.9216'; -- id in (1438010); 


SELECT projectJob,id,customerId,reference,created,callid,callerid,dialStart,dialEnd,conversationStarted,callState,contactResponse 
from tmg_customer.dialHistory 
where created >= '2018-02-07 00:00:00.0' and projectJob='PT-Telco/NowoInbound'
order by id desc;

-- create RecordingDetails:
SELECT *
FROM asteriskcdrdb.cdr
where disposition = 'ANSWERED' and recordingfile in ('external-3779-212740619-20180207-195321-1518029601.9218.wav',
		'q-30-212740619-20180207-195304-1518029584.9216.wav')
        GROUP BY uniqueid;

SELECT linkedid FROM asteriskcdrdb.cel WHERE eventtype='CHAN_END' AND uniqueid in (1518029601.9218); -- linkedid=1518029584.9216

SELECT id, callId FROM tmg_customer.dialHistory WHERE originatingCallId = 1518029584.9216 LIMIT 1; -- id= , callId= 

-- .uniqueId(resultSet.getString(("callId"))) --> empty
-- .customerActivityId(resultSet.getString(("id"))) --> empty
-- .dialHistoryEntryPresent(true) -->false

-- if dialHistoryEntryPresent(true) --> process the file record --> but this is false so we dont process the record file and then move it to failed folder

SELECT * FROM asteriskcdrdb.cel WHERE uniqueid in (1518029601.9218);
SELECT linkedid FROM cel
                WHERE -- uniqueid in (1518029601.9218)
				eventtime > '2018-02-07 19:58:02' 
				AND (channame LIKE "SIP/3779%" OR peer LIKE "SIP/3779%") 
                AND eventtype IN ('CHAN_END', 'BRIDGE_START') 
                ORDER BY id DESC LIMIT 10;

SELECT cid_name,cid_num,cid_ani,cid_dnid,exten FROM cel WHERE linkedid='1518029584.9216';