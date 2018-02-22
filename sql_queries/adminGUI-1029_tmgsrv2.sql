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
-- delete from tmg_customer.smstransaction where date(created)=curdate();
select * from tmg_customer.message where date(created) = curdate();
select * from tmg_customer.smstransaction where date(created)=curdate();
select * from tmg_customer.smslog where date(created) = curdate();
select * from tmg_config.smsworkflow where id = 47;
select * from tmg_customer.session where id = 5067225;
select * from tmg_customer.sessionField where id = 5067225;
select * from tmg_customer.product where id = 5067225;
SELECT *, lastName as sureName FROM tmg_customer.jobCustomer WHERE id=5067225;
SELECT phoneNo, phoneNo2, phoneNo3 FROM tmg_customer.dialPlan WHERE id=5067225;
SELECT * from tmg_customer.customerField WHERE id=5067225;
SELECT * FROM tmg_customer.booking WHERE id=5067225 ORDER BY bookingId;

SELECT t.id, t.customerActivityId, t.agent, t.responseurl, t.reference, l.peerNumber, l.message
	FROM tmg_customer.smstransaction t LEFT JOIN tmg_customer.smslog l ON t.reference = l.reference AND l.state='queued'  -- WHERE t.timeout < NOW();
        
-- ----------------------------------------

 