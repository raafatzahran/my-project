-- Queue: {KivenlahtiOflow:8003,KivenlahtiBf:8001} or {all queues: q.queuename NOT LIKE '1____' } 
-- group by: hour

-- choose 1: {2018-01-16 16:00:00.0} 	-- TIME > [{EET timestamp --> '2018-01-16 17:00:00.0'} ,{Norsk timestamp --> '2018-01-16 16:00:00.0'}] 
										-- TIME < [{EET timestamp --> '2018-01-16 18:00:00.0'} ,{Norsk timestamp --> '2018-01-17 16:00:00.0'}]

-- choose 1: {2018-01-02 12:00:00.0} 	-- TIME > [{EET timestamp --> '2018-01-16 13:00:00.0'} ,{Norsk timestamp --> '2018-01-16 12:00:00.0'}] 
										-- TIME < [{EET timestamp --> '2018-01-16 14:00:00.0'} ,{Norsk timestamp --> '2018-01-17 13:00:00.0'}]
-- ---------------------------------------------------------------------
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
	LEFT JOIN queue_log q IGNORE INDEX(EVENT) USE INDEX(TIME) ON ql.callid=q.callid AND ql.queuename=q.queuename

WHERE  	q.EVENT='ENTERQUEUE'  AND 
		ql.EVENT IN ('ENTERQUEUE','DID','CONNECT','COMPLETEAGENT','COMPLETECALLER','TRANSFER','EXITWITHKEY','ABANDON','EXITEMPTY','EXITWITHTIMEOUT') AND 
		q.queuename IN ('8001','8003') AND  -- NOT LIKE '1____'   IN ('8001','8003')
		q.TIME > '2018-01-02 12:00:00.0'  AND 
		q.TIME < '2018-01-02 13:00:00.0' 
GROUP BY ql.callId , ql.queuename
HAVING state IS NOT NULL AND state IN ('timeout', 'noAnswer') -- ('timeout', 'noAnswer') -- ('answer')
ORDER BY callDate DESC; -- LIMIT 0,50

-- ----------------------
-- Summary:
-- ========

select 
	DATE(q.TIME) as date_q, 
	HOUR(q.TIME) as time_q,
	MAX(CASE q1.EVENT 
			WHEN 'ABANDON' THEN 'noAnswer' 
			WHEN 'EXITEMPTY' THEN 'noAnswer' 
			WHEN 'EXITWITHTIMEOUT' THEN 'timeout' 
			WHEN 'EXITWITHKEY' THEN 'virtualHold' 
			WHEN 'COMPLETEAGENT' THEN 'answer' 
			WHEN 'COMPLETECALLER' THEN 'answer' 
			WHEN 'TRANSFER' THEN 'answer' ELSE NULL END) AS state, 
	MAX(CASE q1.EVENT 
		WHEN 'ENTERQUEUE' THEN q1.queuename ELSE NULL END) AS queueId,

	q1.queuename AS groupValue,
	SUM(q1.EVENT IN ('ABANDON', 'CONNECT','EXITWITHKEY','EXITEMPTY','EXITWITHTIMEOUT')) AS qenter,
	SUM(CASE q1.EVENT WHEN 'ABANDON' THEN 1 ELSE 0 END) AS qabandon,
	SUM(CASE q1.EVENT WHEN 'COMPLETEAGENT' THEN 1 WHEN 'COMPLETECALLER' THEN 1 ELSE 0 END) AS qconnected,
	SUM(q1.EVENT='CONNECT' AND q1.data1<=20) AS qansweredwithinlimit,
	SUM(CASE q1.EVENT WHEN 'EXITWITHKEY' THEN 1 ELSE 0 END) AS qvirtualhold,
	MAX(CASE q1.EVENT 
		WHEN 'CONNECT' THEN CAST(q1.data1 AS UNSIGNED) 
		WHEN 'EXITWITHKEY' THEN CAST(q1.data4 AS UNSIGNED) ELSE 0 END) AS qmaxholdtime,
	SUM(CASE q1.EVENT 
		WHEN 'CONNECT' THEN CAST(q1.data1 AS UNSIGNED) 
		WHEN 'EXITWITHKEY' THEN CAST(q1.data4 AS UNSIGNED) ELSE 0 END) AS qholdtime,
	MAX(CASE q1.EVENT 
		WHEN 'COMPLETEAGENT' THEN CAST(q1.data2 AS UNSIGNED) 
		WHEN 'COMPLETECALLER' THEN CAST(q1.data2 AS UNSIGNED) 
		WHEN 'TRANSFER' THEN CAST(q1.data4 AS UNSIGNED) ELSE 0 END) AS qmaxcalltime,
	SUM(CASE q1.EVENT 
		WHEN 'COMPLETEAGENT' THEN CAST(q1.data2 AS UNSIGNED) 
		WHEN 'COMPLETECALLER' THEN CAST(q1.data2 AS UNSIGNED) 
		WHEN 'TRANSFER' THEN CAST(q1.data4 AS UNSIGNED) ELSE 0 END) AS qcalltime,
	MAX(CASE q1.EVENT 
		WHEN 'ABANDON' THEN CAST(q1.data3  AS UNSIGNED) 
		WHEN 'EXITEMPTY' THEN CAST(q1.data3  AS UNSIGNED) 
		WHEN 'EXITWITHTIMEOUT' THEN CAST(q1.data3  AS UNSIGNED)  ELSE 0 END) AS qmaxabandontime,
	SUM(CASE q1.EVENT 
			WHEN 'ABANDON' THEN CAST(q1.data3  AS UNSIGNED) 
			WHEN 'EXITEMPTY' THEN CAST(q1.data3  AS UNSIGNED) 
			WHEN 'EXITWITHTIMEOUT' THEN CAST(q1.data3  AS UNSIGNED) ELSE 0 END) AS qabandontime 

FROM queue_log q IGNORE INDEX(EVENT) USE INDEX(TIME) 
	INNER JOIN queue_log q1 IGNORE INDEX(EVENT) ON q.callid=q1.callid 

WHERE 	q.Event='ENTERQUEUE' AND 
		q1.Event IN ('ABANDON', 'COMPLETEAGENT','COMPLETECALLER', 'CONNECT','EXITWITHKEY','EXITEMPTY','EXITWITHTIMEOUT', 'TRANSFER') AND 
		q.queuename = q1.queuename  AND 
		q.queuename IN ('8003','8001')AND 
		q.TIME > '2018-01-01 01:00:00.0' AND 
		q.TIME < '2018-01-31 23:59:00.0' 
GROUP BY DATE(q.TIME), HOUR(q.TIME), q.queuename;






