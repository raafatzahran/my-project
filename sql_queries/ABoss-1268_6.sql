SELECT 
	dp.id,
	dp.customerId,
	dp.project,
	dp.job,
	dp.phoneNo,
	dp.phoneNo2,
	dp.phoneNo3,
	dp.phoneNoCountryCode,
	dp.phoneNo2CountryCode,
	dp.phoneNo3CountryCode,
	dp.lastCallState,
	dp.contactResponse,
	dp.noContactDescription,
	jc.name,
	jc.lastName,
	jc.address,
	jc.zip,
	jc.city,
	jc.country,
	jc.eMail,
	jc.webLink,
	jc.note,
	jc.customerType,
	jc.company,
	jc.companyContact,
	jc.companySector,
	jc.gender,
	jc.rejectReason,
	jc.endReason,
	jc.leadCreatedBy,
	jc.version,
	jc.prospectBy,
	dp.loadDate AS timeAddressAdded,
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

WHERE dp.id IN (1423360,1423292) AND dh2.id IS NULL GROUP BY dp.id;