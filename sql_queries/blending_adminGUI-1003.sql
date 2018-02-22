select projectJob, id, created, agent, phoneNoCalled, callerId, callState, contactResponse  
from tmg_customer.dialHistory 
where projectJob = 'raafatnew/raafajobb' AND created >= '2018-01-05 15:20' order by created asc ;

select projectJob, phoneNo, dialplanReferenceDate,dialplanReferenceTime, lastCallState , contactResponse 
from tmg_customer.dialPlan 
where projectJob = 'raafatnew/raafajobb'AND dialplanReferenceDate >= '2018-01-05' And dialplanReferenceTime > '15:20' order by dialplanReferenceDate, dialplanReferenceTime asc ;


-- Blending: +4737403777