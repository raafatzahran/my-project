-- Update the new columns of the table virtualhold with the correspondings values from queue_log table
UPDATE
    tmg_customer.virtualhold vh, tmg_asterisk.queue_log ql
SET
    vh.channelType = 'inbound_queue_call',
	vh.channelId = ql.queuename,
	vh.channelTransactionId = ql.callid
where 	vh.timestamp < '2017-12-12 00:00'
		and ql.TIME between vh.timestamp
		and DATE_ADD(vh.timestamp, INTERVAL 1000000 MICROSECOND)
		and ql.event='ENTERQUEUE' 
		and ql.data3 = 1;

-- Check if the update statement is correct (ql.callid = vh.channelTransactionId)
select vh.*, ql.*
from tmg_customer.virtualhold vh
		left join tmg_asterisk.queue_log ql 
			on ql.callid = vh.channelTransactionId
			and ql.event='ENTERQUEUE' 
			and ql.data3 = 1
where vh.timestamp < '2017-12-12 00:00';