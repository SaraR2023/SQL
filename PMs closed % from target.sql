
select v.* 
, CAST(((v.PMs_closed_cum / v.PMs_total) *100) AS SIGNED) as "%"
, v.Pm_Daily * .9 as "goal lt 95"
, v.Pm_Daily * .95 as "goal gt 95"

from 
(
	select q."date"
	, q.PMs_closed
	, (@sum := @sum + q.PMs_closed) as PMs_closed_cum
	, q.PMs_total,
	CAST((@sum1 := @sum1 + (select count(*) / (abs(datediff('2021-04-01 00:00:00','2021-04-30 23:59:59'))+1)
							from tblWorkOrder wo 
							where wo.intTenantID = 5889
							and wo.intMaintenanceTypeID = 15181
							and wo.intScheduledMaintenanceID is not null
							and wo.dtmDateCompleted between '2021-04-01 00:00:00' and '2021-04-30 23:59:59')) as signed) as PM_daily

						from (
								select date(wo.dtmDateCompleted) as "date"
								, count(*) as PMs_closed,
								(select count(*)
								from tblWorkOrder wo 
								where wo.intTenantID = 5889
								and wo.intMaintenanceTypeID = 15181
								and wo.intScheduledMaintenanceID is not null
								and wo.dtmDateCompleted between '2021-04-01 00:00:00' and '2021-04-30 23:59:59'
								)  PMs_total

		from tblWorkOrder wo

		where wo.intTenantID = 5889
		and wo.intMaintenanceTypeID = 15181
		and wo.intScheduledMaintenanceID is not null
		and wo.dtmDateCompleted between '2021-04-01 00:00:00' and '2021-04-30 23:59:59'

		group by date(wo.dtmDateCompleted)
		) q , (select @sum := 0) params, (select @sum1 := 0) params2
		group by 1
) v