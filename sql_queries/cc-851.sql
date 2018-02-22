-- create query the same as /home/tmgdev/telemagic_project/call-controller/src/cus_statistics.erl --> QNo=eng:format(....)
-- dialPlan
SELECT CONCAT(s.agent,'@',d.project,'/',d.job) as aj_id, 
		d.dialplanReferenceDate, d.dialplanReferenceTime,
	   d.domain,  d.id, d.contactResponse , d.lastCallState
	   -- COUNT(DISTINCT(d.id)) as customer_answering_no  
	   FROM tmg_customer.dialPlan AS d LEFT JOIN tmg_customer.session AS s 
		ON d.id=s.id  
	   WHERE d.dialplanReferenceDate = '2018-01-04'  
			AND d.contactResponse IN ('no') -- ~ts
			AND s.agent = '4044Vanja'
			AND d.job = 'A.Hobby_04012018' 
			AND d.project = 'CappelenBestselger'
			-- AND d.id = '230122'
			AND d.domain IS NOT NULL  ;
	   -- GROUP BY d.project,d.job,d.domain,s.agent;

-- dialHistory
SELECT dh.projectJob, dh.agent,
	   dh.domain,  dh.id, dh.created,
		dh.callState, dh.contactResponse
	   -- COUNT(DISTINCT(dh.id)) as customer_answering_no  
	   FROM tmg_customer.dialHistory AS dh LEFT JOIN tmg_customer.session AS s 
		ON dh.id=s.id  
	   WHERE dh.created >= '2018-01-04 00:00:00'
			AND dh.created < '2018-01-04 23:59:59'
			AND dh.contactResponse IN ('no') -- ~ts
			AND s.agent = '4044Vanja'
			AND dh.projectJob = 'CappelenBestselger/A.Hobby_04012018'
			-- AND dh.agent = s.agent
			AND dh.domain IS NOT NULL;  
	   -- GROUP BY dh.projectJob,dh.domain,s.agent  

-- we discover that there is 16 ids in dp which are not in dh and one id in dh which is not in dp
-- ======================================
-- check the callState and contactResponse for these 16 ids (which is in dp and not in dh) in dh table
SELECT dh.projectJob, dh.agent,
	   dh.domain,  dh.id, dh.created,
		dh.callState, dh.contactResponse
	   -- COUNT(DISTINCT(dh.id)) as customer_answering_no  
	   FROM tmg_customer.dialHistory AS dh LEFT JOIN tmg_customer.session AS s 
		ON dh.id=s.id  
	   WHERE dh.created >= '2018-01-04 00:00:00'
			AND dh.created < '2018-01-04 23:59:59'
			AND dh.id IN  ('229735', '229664', '229690', '229697', '229710', '229868', '229739', '229851', '229750','229745', '229859', '229781', '229782', '229666', '229729', '229657', '229760') -- the last id (229760) are in dh but not in dp
			-- AND dh.contactResponse IN ('no') -- ~ts
			-- AND s.agent = '4044Vanja'
			AND dh.projectJob = 'CappelenBestselger/A.Hobby_04012018'
			AND dh.agent = s.agent
			AND dh.domain IS NOT NULL;  

-- check the callState and contactResponse for the id=229760 (which is in dh but not in dp) in dp table
SELECT CONCAT(s.agent,'@',d.project,'/',d.job) as aj_id, 
	   d.domain,  d.id, d.contactResponse, d.dialplanReferenceDate, d.dialplanReferenceTime
	   -- COUNT(DISTINCT(d.id)) as customer_answering_no  
	   FROM tmg_customer.dialPlan AS d LEFT JOIN tmg_customer.session AS s 
		ON d.id=s.id  
	   WHERE d.dialplanReferenceDate = '2018-01-04'  
			-- AND d.contactResponse IN ('no') -- ~ts
			AND s.agent = '4044Vanja'
			AND d.job = 'A.Hobby_04012018' 
			AND d.project = 'CappelenBestselger'
			AND d.id in ('229760')
			AND d.domain IS NOT NULL  ;
	   -- GROUP BY d.project,d.job,d.domain,s.agent;
-- ==================================
-- check the callState and contactResponse for the id=229739 (which is dp and not in dh) in dh table
SELECT dh.projectJob, dh.agent,
	   dh.domain,  dh.id, dh.created,
		dh.callState, dh.contactResponse
	   -- COUNT(DISTINCT(dh.id)) as customer_answering_no  
	   FROM tmg_customer.dialHistory dh 
		WHERE id = '229739';

-- check the callState and contactResponse for the id=229739 (which is dp and not in dh) in dp table
SELECT CONCAT(d.project,'/',d.job) as aj_id, 
d.dialplanReferenceDate,d. dialplanReferenceTime,
d.domain,  d.id, d.contactResponse , d.lastCallState
	   -- COUNT(DISTINCT(dh.id)) as customer_answering_no  
	   FROM tmg_customer.dialPlan d
		WHERE id = '229739';
-- we discover that there is in consistency between the results !!