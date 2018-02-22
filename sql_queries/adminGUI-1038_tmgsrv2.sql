-- $_SESSION['domian'] = 'avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg'
-- $_SESSION['domians'] = 'void','avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg'
-- select distinct j_id,state from j_counter where state=1 and domain IN (".str_replace("'void',", "", $_SESSION['domains']).") ORDER BY j_id"
-- -----------------------------------------------------------------------------------
select distinct j_id,state from j_counter where state=1 and domain IN ('void','avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg') ORDER BY j_id; -- NOT CORRECT
select distinct j_id,state from j_counter where state=1 and domain IN ('avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg') ORDER BY j_id; -- CORRECT

select * from j_counter;

select sum(listsize_not_called),
	sum(listsize_busy),
	sum(listsize_abandoned),
	sum(listsize_noanswer),
	sum(listsize_callback),
	sum(listsize_prospect),
	sum(listsize_wrongperson),
	sum(listsize_obsolete),
	sum(listsize_answered),
	sum(listremain_busy),
	sum(listremain_abandoned),
	sum(listremain_noanswer),
	sum(listremain_callback),
	sum(listremain_wrongperson),
	sum(listqual_busy),
	sum(listqual_abandoned),
	sum(listqual_noanswer),
	sum(listqual_noanswer_workshift),
	sum(listqual_callback),
	sum(listqual_wrongperson),
	sum(listqual_wrongperson_workshift),
	sum(channel_seized),
	sum(assigned_agents),
	sum(listqual_rescheduled_callback),
	sum(listqual_pending),
	sum(listqual_outbox),
	sum(listremain_rescheduled_callback),
	sum(listremain_pending),
	sum(listremain_outbox),
	sum(listsize_rescheduled_callback),
	sum(listsize_pending),
	sum(listsize_outbox),
	sum(listsize_confirmed),
	sum(call_extension_failure),
	sum(timeout_sms_confirmation),
	sum(failed_sms),
	sum(sent_sms),
	sum(listqual_not_called),
	sum(listsize_extension_failure),
	sum(listsize_answered_yes),
	sum(listsize_answered_no)
from j_counter 
where j_id='raafatnew/rz_job2' and domain IN ('void','avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg');

select distinct SUM(agent_seized),
	SUM(sales_amount),
	SUM(sales),
	SUM(confirmed_sales_amount),
	SUM(confirmed_sales),SUM(contacts),SUM(call_answered_by_agent),SUM(answered_wrongperson),
	SUM(agent_talking),
	SUM(agent_processing_customer)
from aj_counter where aj_id like 'raafatzahran@raafatnew/rz_job2' and domain IN ('void','avd grimstad','defaultDomain','nrk','rør','test mellomrom','Tønsberg');
-- -------------------------------------------------------------


