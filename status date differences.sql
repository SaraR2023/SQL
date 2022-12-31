select z.wo_id, z.created, z.rstatus, z.changedFrom, z.differenceHrs, z.completed, z.scooter, z.market, z.prev_status from
(
select
wo.strCode wo_id
,  wo.dtmDateCreated created
, ifnull(s.strName, 'WO Created') as rstatus
, wo.dtmDateCreated changedFrom
, case when @row_number = 0 then round(timestampdiff(second,wo.dtmDateCreated,t.dtmDate)/3600 , 2) end as differenceHrs
, wo.dtmDateCompleted completed
, concat(a.strName, ' (', a.strCode, ')') scooter
,  site.strName market
, @row_number:=CASE WHEN @ID=wo.strCode THEN @row_number = 0 END AS row_number
, @ID:=wo.strCode AS ID
, null as prev_status

from
      tblWorkOrderStatusTransition t
      join tblWorkOrder wo on t.intWorkOrderID = wo.id
      left join tblWorkOrderStatus s on t.intFromWorkOrderStatusID = s.id
      left join tblWorkOrderStatus ss on t.intToWorkOrderStatusID = ss.id
      left join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
      left join tblAsset a on woa.intAssetID = a.id
      left join tblAsset site on site.id = a.intSiteID
		, (select @row_num := 0) as d

where wo.intTenantID = 71028
and wo.dtmDateCreated between '2022-05-01' and '2022-05-03'
#and wo.strCode = 66302
and s.id is null

UNION

select  wo.strCode wo_id
, wo.dtmDateCreated created
, ss.strName as rstatus
, t.dtmDate as changedFrom
, case when @row_number +1 > @row_number and @prev_status < t.dtmDate then round(timestampdiff(second,@prev_status, t.dtmDate)/3600 , 2) end as differenceHrs
, wo.dtmDateCompleted completed
, concat(a.strName, ' (', a.strCode, ')') scooter
, site.strName market
, @row_number:=CASE WHEN @ID=wo.strCode THEN @row_number+1 ELSE 1 END AS row_number
, @ID:=wo.strCode AS ID
, @prev_status := t.dtmDate prev_status


from
      tblWorkOrderStatusTransition t
      join tblWorkOrder wo on t.intWorkOrderID = wo.id
      left join tblWorkOrderStatus s on t.intFromWorkOrderStatusID = s.id
      left join tblWorkOrderStatus ss on t.intToWorkOrderStatusID = ss.id
	  left join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
      left join tblAsset a on woa.intAssetID = a.id
      left join tblAsset site on site.id = a.intSiteID
		, (SELECT @row_num := 1) as d
        , (SELECT @row_number:=0, @ID1:='', @prev_status := 0) AS e

where wo.intTenantID = 71028
and wo.dtmDateCreated between '2022-05-01' and '2022-05-03'
#and wo.strCode = 66302
)z

order by z.wo_id, z.row_number

