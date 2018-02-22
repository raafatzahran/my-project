-- Queue: KivenlahtiOflow groupn by: Date, choose: 02-01-2018 (Answered: 37)
-- if we compare the row with callid=1514907267.2799 with the correspond row in (total column) in web-agent
-- we can see that the wait time is not the same, so to be sure we check the last three queries and we see that the last one is the correct
SELECT 
	MAX(CASE ql.EVENT 
			WHEN 'ABANDON' THEN 'noAnswer' 
			WHEN 'EXITEMPTY' THEN 'noAnswer' 
			WHEN 'EXITWITHTIMEOUT' THEN 'timeout' 
			WHEN 'EXITWITHKEY' THEN 'virtualHold' 
			WHEN 'COMPLETEAGENT' THEN 'answer' 
			WHEN 'COMPLETECALLER' THEN 'answer' 
			WHEN 'TRANSFER' THEN 'answer' ELSE NULL END) AS state, 

	SUM(CASE ql.EVENT 
			WHEN 'ABANDON' THEN ql.data3 
			WHEN 'EXITEMPTY' THEN ql.data3 
			WHEN 'EXITWITHTIMEOUT' THEN ql.data3 
			WHEN 'EXITWITHKEY' THEN ql.data4 
			WHEN 'CONNECT' THEN ql.data1 ELSE 0 END) AS waittime, 

	SUM(CASE ql.EVENT 
			WHEN 'COMPLETEAGENT' THEN ql.data2 
			WHEN 'COMPLETECALLER' THEN ql.data2 
			WHEN 'TRANSFER' THEN ql.data4 ELSE 0 END) AS duration, 

	MAX(CASE ql.EVENT 
		WHEN 'CONNECT' THEN ql.agent ELSE NULL END) AS agent, 

	MAX(CASE ql.EVENT 
		WHEN 'CONNECT' THEN ql.data2 ELSE NULL END) AS callIdTowardsAgent, 
	
	ql.callid AS originalCallId, 
	
	MAX(CASE ql.EVENT 
		WHEN 'DID' THEN ql.data1 ELSE NULL END) AS yourNumber, 
	MAX(CASE ql.EVENT 
		WHEN 'ENTERQUEUE' THEN ql.TIME ELSE NULL END) AS callDate, 
	MAX(CASE ql.EVENT 
		WHEN 'ENTERQUEUE' THEN ql.data2 ELSE NULL END) AS peerNumber, 
	MAX(CASE ql.EVENT 
		WHEN 'ENTERQUEUE' THEN ql.queuename ELSE NULL END) AS queueId 


 FROM queue_log ql IGNORE INDEX(EVENT) 
	LEFT JOIN queue_log q IGNORE INDEX(EVENT) ON ql.callid=q.callid AND ql.queuename=q.queuename

WHERE  	q.EVENT='ENTERQUEUE'  AND 
		ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
		q.queuename IN ('8003') AND 
		q.TIME > '2018-01-02 01:00:00.0' AND 
		q.TIME < '2018-01-03 01:00:00.0' 
GROUP BY ql.callId 
HAVING state IS NOT NULL AND state IN ('answer')-- ('answer') ('timeout', 'noAnswer') 
ORDER BY callDate DESC; -- LIMIT 0,50
-- ----------------------------------------
select * 
FROM queue_log ql IGNORE INDEX(EVENT) 
	LEFT JOIN queue_log q IGNORE INDEX(EVENT) ON ql.callid=q.callid  
WHERE  	ql.callid = '1514907267.2799' AND
		q.EVENT='ENTERQUEUE'  AND 
		ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
		q.queuename IN ('8001') AND  -- ql.queuename IN ('8001') AND 
		q.TIME > '2018-01-01 01:00:00.0' AND 
		q.TIME < '2018-02-01 00:59:00.0' ;
-- ----------------------------------------
select * 
FROM queue_log ql IGNORE INDEX(EVENT) 
	LEFT JOIN queue_log q IGNORE INDEX(EVENT) ON ql.callid=q.callid  

WHERE  	ql.callid = '1514907267.2799' AND
		q.EVENT='ENTERQUEUE'  AND 
		ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
		q.queuename IN ('8003') AND  -- ql.queuename IN ('8001') AND 
		q.TIME > '2018-01-01 01:00:00.0' AND 
		q.TIME < '2018-02-01 00:59:00.0' ;
-- ----------------------------------------
select * 
FROM queue_log ql IGNORE INDEX(EVENT) 
	LEFT JOIN queue_log q IGNORE INDEX(EVENT) ON ql.callid=q.callid AND ql.queuename = q.queuename

WHERE  	ql.callid = '1514907267.2799' AND
		q.EVENT='ENTERQUEUE'  AND 
		ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
		q.queuename IN ('8003') AND 
		q.TIME > '2018-01-01 01:00:00.0' AND 
		q.TIME < '2018-02-01 00:59:00.0' ;
-- ----------------------------------------



