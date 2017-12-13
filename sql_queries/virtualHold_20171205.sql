select id, projectJob, reference, created, callState, contactResponse, callLength, customerId, dialHistoryIndex   
from tmg_customer.dialHistory 
where created > '2017-09-20 00:00' and created < '2017-11-30 23:59' 
order by created asc;

select *
from tmg_customer.virtualhold vh
where vh.timestamp > '2017-09-20 00:00' and vh.timestamp <= '2017-11-30 23:59'
-- group by vh.id
order by vh.timestamp asc
LIMIT 0,1000;

select * from tmg_asterisk.queue_log where TIME > '2017-11-20 00:00' 
		and TIME < '2017-11-30 23:59';-- callid = '1511955441.31';

Select * from tmg_customer.virtualhold where timestamp > '2017-12-01 00:00'; 

select * from tmg_asterisk.queue_log;

SELECT 
dp.id,dp.customerId,dp.project,dp.job,dp.phoneNo,dp.phoneNo2,
dp.phoneNo3,dp.phoneNoCountryCode,dp.phoneNo2CountryCode,
dp.phoneNo3CountryCode,dp.lastCallState,dp.contactResponse,
dp.noContactDescription,jc.name,jc.lastName,jc.address,jc.zip,
jc.city,jc.country,jc.eMail,jc.webLink,jc.note,jc.customerType,
jc.company,jc.companyContact,jc.companySector,jc.gender,jc.rejectReason,
jc.endReason,jc.leadCreatedBy,jc.version,
jc.prospectBy,dp.loadDate AS timeAddressAdded,
dh.created AS timeLastHandled,
dh.agent AS handlingAgent,
max(s.saleClosed) as timeLastSaleClosed, 
max(s.saleConfirmed) as timeLastSaleConfirmed, 
max(s.saleCancelled) as timeLastSaleCancelled,
GROUP_CONCAT(s.sessionId, '-' , s.state) as sessionStates,
SUM(IF ((s.state='closed' OR s.state='confirmed'),p.salesAmount,0)) as totSalesAmount ,
(SELECT count(*) FROM tmg_customer.recordedFiles rf WHERE rf.id=jc.id)  as nrOfRecordings 
FROM tmg_customer.dialPlan dp 
LEFT JOIN tmg_customer.jobCustomer jc ON dp.id=jc.id 
LEFT JOIN tmg_customer.session s ON dp.id=s.id 
LEFT JOIN tmg_customer.dialHistory dh ON dp.id=dh.id 
LEFT JOIN tmg_customer.product p ON dp.id=p.id AND s.sessionId=p.sessionId 
LEFT JOIN tmg_customer.dialHistory dh2 ON dh2.id=dh.id AND dh2.created > dh.created 
WHERE dp.id IN (5067158) AND dh2.id IS NULL
GROUP BY dp.id;

SELECT id,callId,location,created,direction FROM tmg_customer.recordedFiles rf WHERE rf.id IN (5067158);

select * from tmg_customer.dialPlan dp 
WHERE dp.id IN (5067158);
-- GROUP BY dp.id;

select * from tmg_customer.jobCustomer jc 
WHERE jc.id IN (5067158);

select * from tmg_customer.session s 
WHERE s.id IN (5067158);

select id, projectJob, created, reference, callLength, callState, contactResponse, customerId, dialHistoryIndex from tmg_customer.dialHistory dh 
WHERE dh.id IN (5067158);

select * from tmg_customer.product p 
WHERE p.id IN (5067158);

select * from tmg_customer.virtualhold vh 
WHERE vh.timestamp > '2017-09-01 00:00' and vh.timestamp <= '2017-12-11 23:59';

select * from tmg_customer.virtualhold vh 
WHERE vh.timestamp > '2017-09-01 00:00' and vh.timestamp <= '2017-12-11 23:59';

SELECT extension,descr FROM asterisk.queues_config WHERE extension NOT LIKE '1____';

