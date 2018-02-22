-- check the situation which we have in youtrack
select message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message, tmg_customer.dialPlan 
where message.id='7276036' and message.created = '2018-02-01 03:03:27' limit 1;

-- check if we have messageBody when messageType='receiveSms' and state='responseTimeout'
select message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message, tmg_customer.dialPlan
where messageType='receiveSms' and state='responseTimeout' and messageBody!='' limit 10;

-- -------------------------------------------
-- Check if we have messageBody when messageType='receiveSms' and state='responseTimeout'
select 

message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, 
message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message, tmg_customer.dialPlan
where messageType='receiveSms' and state='responseTimeout' and created > '2017-11-01 00:00:00' limit 10000;

select 
message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, 
message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message
where messageType='receiveSms' and state='responseTimeout' and created > '2018-01-01 00:00:00' limit 10000;

select
message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, 
message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message
where messageType='receiveSms' and state='responseTimeout' and date(created)=curdate() limit 10000;