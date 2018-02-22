-- Consult tables
SELECT vh.*, ql.*
from directhouse5_test.virtualhold vh
		left join directhouse5_test.queue_log ql 
			ON ql.TIME between vh.timestamp and DATE_ADD(vh.timestamp, INTERVAL 1000000 MICROSECOND)
			and ql.event='ENTERQUEUE';
-- ======================================

-- Some rows which has ql.data3 != 1
-- ----------------------------------
-- data3 = 1
SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '1';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-10-25 11:13:17' AND '2017-10-26 11:13:17'; -- 1

-- data3 = 2
SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '12';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-11-14 09:02:10' AND '2017-11-15 09:02:10'; -- 12

SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '15';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-11-14 13:03:57' AND '2017-11-15 13:03:57'; -- 15

SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '37';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-11-23 09:12:27' AND '2017-11-24 09:12:27'; -- 37

SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '38';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-11-23 09:21:36' AND '2017-11-24 09:21:36'; -- 38

-- data3 = 3
SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '71';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-12-08 09:07:42' AND '2017-12-09 09:07:42'; -- 71

-- data3 = 4
SELECT * FROM directhouse5_test.virtualhold vh WHERE id = '95';
SELECT * FROM directhouse5_test.queue_log ql WHERE TIME BETWEEN'2017-12-13 09:22:19' AND '2017-12-14 09:22:19'; -- 95
-- ===========================

-- Update virtualhold table
UPDATE
  directhouse5_test.virtualhold vh, directhouse5_test.queue_log ql
SET
  vh.channelType = 'inbound_queue_call',
	vh.channelId = ql.queuename,
	vh.channelTransactionId = ql.callid
WHERE ql.TIME BETWEEN vh.timestamp
		AND DATE_ADD(vh.timestamp, INTERVAL 1000000 MICROSECOND)
		AND ql.event='ENTERQUEUE';
-- ===========================

-- Check if the update statement is correct (ql.callid = vh.channelTransactionId)
SELECT vh.*, ql.*
FROM directhouse5_test.virtualhold vh
		LEFT JOIN directhouse5_test.queue_log ql 
			ON ql.callid = vh.channelTransactionId
			AND ql.event='ENTERQUEUE';
-- ===========================