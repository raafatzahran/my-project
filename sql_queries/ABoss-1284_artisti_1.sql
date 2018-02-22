-- dialplanReferenceDate, dialplanReferenceTime = dh.created, lastDialHistRef = dh.reference

select * from tmg_customer.dialPlan where contactResponse='obsolete' and domain != '' limit 10;
select * from tmg_customer.dialHistory where created>=curdate();
-- -----------------------------------------
-- phpAdmin customerInfo.php
select * from tmg_customer.dialPlan where id=11832280;
select * from tmg_customer.dialHistory where id=11832280;
select * from jobCustomer where customerId='+4732133220' and id=11832280 ;

select dialPlan.projectJob,
	dialPlan.customerId,
	dialPlan.phoneNo,
	dialPlan.phoneNo2,
	dialPlan.phoneNo3,
	dialPlan.loadDate,
	CAST(dh.created AS Date) as dialplanReferenceDate,
	CAST(dh.created AS Time)  as dialplanReferenceTime,
	if (dialPlan.lastCallState='contact', dialPlan.contactResponse, dialPlan.lastCallState) as lastCallState,
	dialPlan.noContactDescription,
	dialPlan.dialTimeToAnsweringMachinePhoneNo,
	dialPlan.dialTimeToAnsweringMachinePhoneNo2,
	dialPlan.dialTimeToAnsweringMachinePhoneNo3,
	dialPlan.cntRedial,
	dialPlan.cntNoAnswer,
	dialPlan.cntBusy,
	dialPlan.cntWrongPerson,
	dialPlan.cntNoAnswerWorkshift,
	dialPlan.cntAbandonToday,
	dialPlan.cntAbandon,
	dialPlan.cntCallBack,
	dialPlan.cntAnsweringMachine,
	dialPlan.cntExtensionFailurePhoneNo,
	dialPlan.cntExtensionFailurePhoneNo2,
	dialPlan.cntExtensionFailurePhoneNo3,
	dialPlan.cntMessageAttempt,
	dialPlan.cntMessageAttemptWithFailure,
	dialPlan.block,
	dialPlan.domain,
	dialPlan.cntTotRedial,
	dialPlan.cntTotNoAnswer,
	dialPlan.cntTotWrongPerson,
	dialPlan.cntTotAbandon,
	name, lastName, address, zip, city, eMail, webLink, note, customerType, company, companyContact, companySector, gender, dialPlan.id as id,
	IF(dialPlan.disqualified IS NULL, '', IF(dialPlan.disqualified='', '', dialPlan.disqualified)) as disqualified
	from jobCustomer,dialPlan , dialHistory dh
	where jobCustomer.id=dialPlan.id
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and jobCustomer.customerId ='+4732133220'
	and dialPlan.project = 'Aller-HB' 
	and dialPlan.job = 'Aller_ks';
-- -----------------------------------------
-- phpAdmin statusCustomerInfo.php

select * from tmg_customer.dialPlan where id=11832471;
select * from tmg_customer.dialHistory where id=11832471;
select * from jobCustomer where id=11832471 ;
select * from session where id=11832471 ;

select CAST(dh.created AS Date) as dialplanReferenceDate
	, CAST(dh.created AS Time)  as dialplanReferenceTime
	, dialPlan.projectJob
	, dialPlan.customerId
	, lastCallState
	, dialPlan.contactResponse -- modified 
	, name
	, lastName
	, session.agent -- modified 
from dialPlan, jobCustomer, session, dialHistory dh
where dialPlan.id=jobCustomer.id 
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and dialPlan.id=session.id 
	and dialPlan.projectJob='Aller-HB/Aller_ks'
	and CAST(dh.created AS Date)='2018-02-15'
	and session.saleClosedBy='6090ChristofferLa'
	and dialPlan.lastCallState='contact' 
	and dialPlan.contactResponse IN ('confirmed','yes','no');

-- -----------------------------------------
-- phpAdmin dailyStatisticsReport.php

select * from tmg_customer.dialPlan where id=5155406;
select * from tmg_customer.dialHistory where id=5155406;
select * from jobCustomer where id=5155406 ;

select CAST(dh.created AS Date) as Date
	,jobCustomer.rejectReason
	,count(jobCustomer.rejectReason) as rejectReasonCount 
from dialPlan, jobCustomer, dialHistory dh
where dialPlan.id = jobCustomer.id 
	and jobCustomer.rejectReason!='' 
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and CAST(dh.created AS Date)>='2016-11-24'
	and CAST(dh.created AS Date)<='2016-11-25'
	-- ".$sql_RejectReasonProject." ".$sql_RejectReasonJob."
	and dialPlan.project='AMEDIA-TB'
	and dialPlan.job='amedia_tbbench1116'
	and dialPlan.lastCallState='contact' and dialPlan.contactResponse='no' and dialPlan.domain IN ('Lillestrøm')
group by jobCustomer.rejectReason, CAST(dh.created AS Date) order by CAST(dh.created AS Date);
				-- ------------------------ --
				-- ------------------------ --

select * from tmg_customer.dialPlan where id=9787779;
select * from tmg_customer.dialHistory where id=9787779;

select CAST(dh.created AS Date) as Date, count(dialPlan.lastCallState) as Deleted 
from dialPlan, dialHistory dh
	where dialPlan.lastCallState='contact' 
	and dialPlan.contactResponse='obsolete'
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and CAST(dh.created AS Date)>='2017-08-24'
	and CAST(dh.created AS Date)<='2017-08-24'
	and dialPlan.domain IN ('Torskeholmen')
	and dialPlan.project='Aller-Alfrahag'
	and dialPlan.job='alla_alfrahag0717'
group by CAST(dh.created AS Date);

-- -----------------------------------------
-- phpAdmin projectSummary.php  ==>>>>> We don't use this side now!!


SELECT distinct 
        dp.job
        
        FROM ( 
            SELECT distinct 
            dialPlan.loadDate, 
            CAST(dh.created AS Date) as createdDate, 
            dialPlan.job, 
            COUNT(1) AS antallSaker, 
            SUM(IF(dialPlan.cntTotRedial > 0, 1, 0)) AS antallUnikeSaker 
            FROM dialPlan, dialHistory dh
			-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
			WHERE dialPlan.id=dh.id
			and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
			and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
			-- and dialPlan.lastDialHistRef=dh.reference
			-- ------------------
			GROUP BY dialPlan.loadDate) AS dp 
        
		INNER JOIN (
            SELECT
            distinct dp1.loadDate, 
            tmg_pd_day.jh_counter.call_answered AS samtaler, 
            ROUND((tmg_pd_day.jh_counter.customer_with_sale), 2) AS PTP_Total, 
            tmg_pd_day.jh_counter.customer_with_sale AS PTP_YES, 
            tmg_pd_day.jh_counter.confirmed_sales AS PTP_SMS, 
            tmg_pd_day.jh_counter.call_extension_failure AS feilNummer, 
            tmg_pd_day.jh_counter.customer_answering_no AS PTP_NO 
            FROM tmg_pd_day.jh_counter 
            INNER JOIN 
				(SELECT dialPlan.project, dialPlan.job, dialPlan.domain, dialPlan.loadDate, CAST(dh1.created AS Date) as createdDate
				FROM dialPlan, dialHistory dh1 
				-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
				WHERE dialPlan.id=dh1.id
				and dialPlan.dialplanReferenceDate=CAST(dh1.created AS Date)
				and dialPlan.dialplanReferenceTime=CAST(dh1.created AS Time)
				-- and dialPlan.lastDialHistRef=dh.reference
				-- ------------------
				) AS dp1 
            ON CONCAT(dp1.project, '/', dp1.job) = tmg_pd_day.jh_counter.jh_id 
            AND dp1.createdDate = tmg_pd_day.jh_counter.date 
            AND dp1.domain = tmg_pd_day.jh_counter.domain 
            GROUP BY dp1.loadDate) AS jh 
        ON jh.loadDate = dp.loadDate 

		INNER JOIN ( 
            SELECT 
            SUM(distinct tmg_pd_day.ajh_counter.nonZero_agent_logging) AS TotalHours,
            date 
            FROM tmg_pd_day.ajh_counter 
            INNER JOIN 
				(SELECT dialPlan.project, dialPlan.job, dialPlan.domain, CAST(dh2.created AS Date) as createdDate 
				FROM dialPlan, dialHistory dh2
				-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
				WHERE dialPlan.id=dh2.id
				and dialPlan.dialplanReferenceDate=CAST(dh2.created AS Date)
				and dialPlan.dialplanReferenceTime=CAST(dh2.created AS Time)
				-- and dialPlan.lastDialHistRef=dh.reference
				-- ------------------
				) AS dp2
            ON CONCAT(dp2.project, '/', dp2.job) = SUBSTRING_INDEX(tmg_pd_day.ajh_counter.ajh_id, '@', - 1) 
            AND CAST(dp2.createdDate AS Date) = tmg_pd_day.ajh_counter.date 
            AND dp2.domain = tmg_pd_day.ajh_counter.domain 
            GROUP BY date) AS ajh 
        ON dp.createdDate = ajh.date 
        
        where dp.loadDate >= '2017-08-24' AND dp.loadDate <= '2017-08-24' and dp.job like 'Santander'-- dp.job = 'alla_alfrahag0717'  -- $whereClause
        GROUP BY dp.loadDate 
        ORDER BY dp.loadDate ;
-- -----------------------------------------
-- phpAdmin webReport_bookingas.php

select CAST(dh.created AS Date) as Date
	,jobCustomer.rejectReason
	,count(jobCustomer.rejectReason) as rejectReasonCount 
from dialPlan, jobCustomer, dialHistory dh
where dialPlan.id = jobCustomer.id 
	and jobCustomer.rejectReason!='' 
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and CAST(dh.created AS Date)>='2016-11-24'
	and CAST(dh.created AS Date)<='2016-11-25'
	-- ".$sql_RejectReasonProject." ".$sql_RejectReasonJob."
	and dialPlan.project='AMEDIA-TB'
	and dialPlan.job='amedia_tbbench1116'
	and dialPlan.lastCallState='contact' and dialPlan.contactResponse='no'
group by jobCustomer.rejectReason, CAST(dh.created AS Date) order by CAST(dh.created AS Date);

				-- ------------------------ --
				-- ------------------------ --

select CAST(dh.created AS Date) as Date, count(dialPlan.lastCallState) as Deleted 
from dialPlan, dialHistory dh
	where dialPlan.lastCallState='contact' 
	and dialPlan.contactResponse='obsolete'
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and CAST(dh.created AS Date)>='2017-08-24'
	and CAST(dh.created AS Date)<='2017-08-24'
	and dialPlan.project='Aller-Alfrahag'
	and dialPlan.job='alla_alfrahag0717'
	group by CAST(dh.created AS Date);
-- -----------------------------------------
-- phpAdmin webReport.php


select CAST(dh.created AS Date) as Date
	,jobCustomer.rejectReason
	,count(jobCustomer.rejectReason) as rejectReasonCount 
from dialPlan, jobCustomer, dialHistory dh
where dialPlan.id = jobCustomer.id 
	-- equivalent to check [dialPlan.lastDialHistRef=dh.reference]
	and dialPlan.id=dh.id
	and dialPlan.dialplanReferenceDate=CAST(dh.created AS Date)
	and dialPlan.dialplanReferenceTime=CAST(dh.created AS Time)
	-- and dialPlan.lastDialHistRef=dh.reference
	-- ------------------
	and jobCustomer.rejectReason!='' 
	and CAST(dh.created AS Date)>='2016-11-24'
	and CAST(dh.created AS Date)<='2016-11-24'
	and dialPlan.project='AMEDIA-TB'
	and dialPlan.job='amedia_tbbench1116'
group by jobCustomer.rejectReason, CAST(dh.created AS Date) order by CAST(dh.created AS Date);
-- -----------------------------------------
