--Number of rows far exceeds those in Salesforce


SELECT t.strprojectname				as "projectName"
,o.stropportunityname 				as "opportunityName"
--t.completed (unavailable)			as "completed"
FROM 
schsales.tbltaskrayprojects t 
LEFT JOIN schsales.tblopportunity o ON t.stropportunityid = o.id
ORDER BY t.strprojectname desc;

-------------------------------------------------------------------------------
select ,tpc."name"                  as "projectName"
,o."name" 							as "opportunityName"
,tpc.taskray__trcompleted__c		as "completed"
from salesforce.taskray__project__c tpc 
left join salesforce.opportunity o on o.id = tpc.taskray__tropportunity__c
where tpc.taskray;

--------------------------------------------------------------------------------
select distinct tptc."name" 		as "projectName"
,o."name" 							as "opportunityName"
,tptc.taskray__trcompleted__c 		as "completed"b
from salesforce.taskray__project_task__c tptc 
left join salesforce.opportunity o on o.id = tptc.taskray__tropportunity__c
where tptc.taskray__archived__c is true OR tptc.taskray__trcompleted__c is true;