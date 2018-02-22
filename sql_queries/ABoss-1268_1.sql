select * from tmg_asterisk.queue_log where TIME = '2018-01-23 11:30:48';

select *, (dialEnd - conversationStarted) as myCallLength 
from tmg_customer.dialHistory dh
	LEFT JOIN tmg_asterisk.queue_log ql ON dh.originatingCallId = ql.callId
 where ql.callId = '1516703431.245';
-- -------------------------------------------------------------
select * from tmg_asterisk.queue_log where TIME = '2018-01-23 11:53:07';

select *, (dialEnd - conversationStarted) as myCallLength 
from tmg_customer.dialHistory dh
	LEFT JOIN tmg_asterisk.queue_log ql ON dh.originatingCallId = ql.callId
 where ql.callId = '1516704770.698';
-- -------------------------------------------------------------
select * from tmg_asterisk.queue_log where TIME = '2018-01-23 11:14:42';

select *, (dialEnd - conversationStarted) as myCallLength 
from tmg_customer.dialHistory dh
	LEFT JOIN tmg_asterisk.queue_log ql ON dh.originatingCallId = ql.callId
 where ql.callId = '1516702384.74';
-- -------------------------------------
select * from tmg_asterisk.queue_log where TIME > '2018-01-23 10:00:00' AND TIME < '2018-01-23 12:00:00' ORDER BY TIME DESC;