-- /home/tmgdev/telemagic_project/agent-boss/src/main/java/no/telemagic/agentboss/dao/TmgPdDAO.java --> function: selectStatisticsByDateAndStatisticsId

-- selectFromPdH
SELECT IFNULL(aj.agent, SUBSTRING_INDEX(aj.agh_id, '@', 1)) AS agent, 
	aj.domain, 
	aj.project, 
	aj.job, 
	ajh.h_id   AS h_id_day, 
	answered_callback, answered_deadperson, 
	answered_wrongperson, answered_prospect, 
	customer_with_sale_confirmed,
	contacts,
	(customer_with_sale + customer_answering_no) AS numberOfUniqueContacts,
	customer_with_sale AS numberOfUniqueContactsWithSale, 
	customer_answering_no AS numberOfUniqueContactsWithoutSale
	
	FROM tmg_pd_h.ajh_counter ajh 
		LEFT JOIN tmg_pd_h.agentjob_h aj 
			ON aj.agh_id = ajh.ajh_id AND aj.domain = ajh.domain 
			AND aj.h_id = ajh.h_id
	WHERE ajh.h_id >= DATE('2018-01-04 12:00:00.0')
	AND ajh.h_id < ('2018-01-04 12:00:00.0') -- use the same date here !!!
	AND aj.domain IS NOT NULL
AND agent ='4044Vanja' AND job='A.Hobby_04012018'
GROUP BY ajh.ajh_id, ajh.domain, date(ajh.h_id); -- and add this statement !!!
-- =======================================================
-- selectFromPdDay -- Without results !!!!
SELECT IFNULL(aj.agent, SUBSTRING_INDEX(aj.agh_id, '@', 1)) AS agent, 
	aj.domain, 
	aj.project, 
	aj.job, 
	ajh.date   AS h_id_day, 
	answered_callback, answered_deadperson, 
	answered_wrongperson, answered_prospect, 
	customer_with_sale_confirmed,
	contacts,
	(customer_with_sale + customer_answering_no) AS numberOfUniqueContacts,
	customer_with_sale AS numberOfUniqueContactsWithSale, 
	customer_answering_no AS numberOfUniqueContactsWithoutSale
	
	FROM tmg_pd_day.ajh_counter ajh 
		LEFT JOIN tmg_pd_day.agentjob_h aj 
			ON aj.agh_id = ajh.ajh_id 
			AND aj.domain = ajh.domain 
			AND aj.date = ajh.date
	WHERE ajh.date >= DATE('2018-01-04 12:00:00.0')
	AND ajh.date < DATE('2018-01-05 23:59:00.0')
	AND aj.domain IS NOT NULL
AND agent ='4044Vanja' AND job='A.Hobby_04012018';
-- ======================================
-- selectFromPd
SELECT aj.agent AS agent, 
	aj.domain, 
	aj.project, 
	aj.job, 
	CURDATE()   AS h_id_day, 
	answered_callback, answered_deadperson, 
	answered_wrongperson, answered_prospect, 
	customer_with_sale_confirmed,
	contacts,
	(customer_with_sale + customer_answering_no) AS numberOfUniqueContacts,
	customer_with_sale AS numberOfUniqueContactsWithSale, 
	customer_answering_no AS numberOfUniqueContactsWithoutSale
	
	FROM tmg_pd.aj_counter ajh 
		LEFT JOIN tmg_pd.agentjob aj 
			ON aj.ag_id = ajh.aj_id AND aj.domain = ajh.domain 

	WHERE aj.domain IS NOT NULL
	AND agent ='4044Vanja' AND job='A.Hobby_04012018';
-- ======================================
-- Salestatistics

SELECT 
        dp.project AS project, 
		dp.job AS job, 
		IFNULL(dp.domain, 'defaultDomain') AS domain, 
		s.saleClosedBy AS agent, 
        IFNULL(SUM(p.salesAmount), 0) AS salesAmount, 
        COUNT(DISTINCT(s.id)) AS numOfCustSales, 
        COUNT(DISTINCT(CONCAT_WS('-', s.id, s.sessionId))) AS numOfSessions, 
        COUNT(DISTINCT(IF(lastContact.id, (CONCAT_WS('-', s.id, s.sessionId)), NULL)))AS numOfSessionsMan, 
        SUM(p.quantum) AS numOfProducts, 
		COUNT(s.backofficeVerified) AS numOfBackofficeVerified 
		FROM tmg_customer.session s 
			LEFT JOIN tmg_customer.product p ON s.id = p.id AND s.sessionId = p.sessionId 
			LEFT JOIN tmg_customer.dialPlan dp ON s.id = dp.id 
			LEFT JOIN( 
						SELECT dh.id, 
						dh.trafficCase 
						FROM tmg_customer.dialHistory dh 
						LEFT JOIN tmg_customer.dialHistory dh2 
							ON dh.id = dh2.id 
							AND dh.conversationStarted < dh2.conversationStarted 
						WHERE dh.id IN( 
							SELECT id FROM session WHERE saleClosed  BETWEEN '2018-01-01' AND '2018-01-04'
						) 
						AND dh2.id IS NULL 
						AND dh.conversationStarted IS NOT NULL 
						AND dh.conversationStarted BETWEEN '2018-01-01' AND '2018-01-04'    
						AND dh.contactResponse IS NOT NULL 
						AND dh.trafficCase = 'manual'
			) AS lastContact ON s.id = lastContact.id 
		WHERE s.saleClosed  BETWEEN '2018-01-01' AND '2018-01-04'
		GROUP BY dp.project, dp.job, IFNULL(dp.domain, 'defaultDomain'), s.saleClosedBy;

