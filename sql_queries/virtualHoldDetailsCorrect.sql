-- Create test case in tmgsrv2
update tmg_customer.message 
set messageBody='Vi viser til samtalen nå nettopp der du svarte ja på at Allers kan ringe deg i forbindelse med relevant markedsføring. Skulle du være uenig i at du svarte ja til dette kan svare <ANGRE Samtykke> på denne meldingen.'
where id=192788 and sessionId=0 and dialHistoryReference=1 and created = '2012-07-19 13:11:57';

update tmg_customer.message 
set messageType='receiveSms', state='responseTimeout'
where id=192788 and sessionId=0 and dialHistoryReference=1 and created = '2012-07-19 13:11:57';


select message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message, tmg_customer.dialPlan
where message.id='192788' and message.created = '2012-07-19 13:11:57' limit 1;
-- ----------------------------------------
-- Check if we have messageBody when messageType='receiveSms' and state='responseTimeout'
select message.id, message.sessionId, message.dialHistoryReference, message.address, message.created, message.transactionId, message.agent, message.messageType, message.messageBody, message.receivedResponseCode, message.state, message.report
from tmg_customer.message, tmg_customer.dialPlan
where messageType='receiveSms' and state='responseTimeout' and messageBody !='' limit 100;
-- ----------------------------------------