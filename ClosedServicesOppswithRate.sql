SELECT o.id									as "opportunityID"
,a.id 										as "accountID"
,u.struserfullname  						as "opportunityOwner"
,a.straccountname 							as "accountName "
,o.stropportunityname 						as "opportunityName" 
,o.strcmmstier  							as "currentTier"
,o.dtmdateopportunityclose  				as "closeDate"
,o.stropportunitytype  						as "type"
,u1.struserfullname 						as "proServConsultant"
,o.intservicehours  						as "serviceHours"
,o.dblamountservices/o.intservicehours 		as "rate"
--,o.amountservicescurrency	(unavailable)	as "amountServicesCurrency"
,o.dblamountservices 						as "amountServices"
,a.inttenantid  							as "tenantID"
,a.strnetsuiteid 			  				as "netsuiteID" --incorrect 
,o.intservicehoursfixedfee 					as "serviceHourFixedFee"
FROM schsales.tblopportunity o
LEFT JOIN schsales.tblaccount a on a.id = o.straccountid 
LEFT JOIN schsales.tbltaskrayprojects t on t.stropportunityid = o.id
LEFT JOIN schcentral.tbluser u on u.id = o.strownerid 
LEFT JOIN schcentral.tbluser u1 on u1.id = o.strproserveconsultantuserid
WHERE o.id LIKE '006f200001y087K%';

select o.id            					as "opportunityID"
,a.id 										as "accountID"
,u.name 									as "opportunityOwner"
,o."name" 									as "opportunityName"
,a."name" 									as "accountName "
,o.current_tier__c 							as "currentTier"
,o.closedate 								as "closeDate"
,o."type" 									as "type"
,o.proserv_consultant__c 					as "proServConsultant"
,o.service_hours__c  						as "serviceHours"
,o.amount_services__c /o.service_hours__c 	as "rate"
,a.currencyisocode 							as "amountServicesCurrency"
,o.amount_services__c 						as "amountServices"
,a.tenantid__c 								as "tenantID"
,o.bmi_sf_ns__netsuiteid__c 				as "netsuiteID"
--,o.servicehourfixedfee  (unavailable) 	as "serviceHourFixedFee"
FROM
salesforce.opportunity o
LEFT JOIN salesforce.account a on a.id = o.accountid
LEFT JOIN salesforce."user" u on u.id = o.ownerid 
WHERE o.id LIKE '006f200001y087K%'
;