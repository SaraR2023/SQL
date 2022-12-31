select

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID = 107312
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30') as "Box_1",

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID = 107312
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and ws.intSysCode = 7
and wo.dblTimeSpentHours > 0
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
and wo.dtmDateCompleted between '2021-01-01' and '2021-06-30') as "Box_2",

(select IFNULL(SUM(wo1.dblTimeEstimatedHours),0)
from
(select wo.strCode, wo.dblTimeEstimatedHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID = 107312
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1) as "Box_3",

(select round(IFNULL(SUM(wo1.dblTimeSpentHours),0),2)
from
(select wo.strCode, wo.dblTimeSpentHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and ws.intSysCode = 7
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID = 107312
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1) as "Box_4",

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID = 107311
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30') as "Box_6",

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID = 107311
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and ws.intSysCode = 7
and wo.dblTimeSpentHours > 0
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between (select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID = 107312
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and ws.intSysCode = 7
and wo.dblTimeSpentHours > 0
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
and wo.dtmDateCompleted between '2021-01-01' and '2021-06-30')
and wo.dtmDateCompleted between '2021-01-01' and '2021-06-30') as "Box_7",

(select round(IFNULL(SUM(wo1.dblTimeEstimatedHours),0),2)
from
(select wo.strCode, wo.dblTimeEstimatedHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID = 107311
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1) as "Box_8",

(select round(IFNULL(SUM(wo1.dblTimeSpentHours),0),2)
from
(select wo.strCode, wo.dblTimeSpentHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and ws.intSysCode = 7
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID = 107311
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1)as "Box_9",

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID in (107308,107309,107310)
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30') as "Box_11",

(select COUNT(DISTINCT wo.id)
from tblWorkOrder wo
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intPriorityID in (107308,107309,107310)
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and ws.intSysCode = 7
and wo.dblTimeSpentHours > 0
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
and wo.dtmDateCompleted between '2021-01-01' and '2021-06-30') as "Box_12",

(select IFNULL(SUM(wo1.dblTimeEstimatedHours),0)
from
(select wo.strCode, wo.dblTimeEstimatedHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID in (107308,107309,107310)
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1) as "Box_13",

(select IFNULL(SUM(wo1.dblTimeSpentHours),0)
from
(select wo.strCode, wo.dblTimeSpentHours
from tblWorkOrder wo
inner join tblWorkOrderAsset woa on woa.intWorkOrderID = wo.id
inner join tblWorkOrderStatus ws on wo.intWorkOrderStatusID = ws.id
inner join tblAsset a on woa.intAssetID = a.id
left outer join tblAssetResolved ar on ar.intDescendantID = a.id
where wo.intTenantID = 33157
#and $X{IN, ar.intAncestorID, assetid}
and wo.dtmSuggestedCompletionDate is not null
and ws.intSysCode = 7
and wo.intMaintenanceTypeID in (220276,220277,220279,220281,285573,403740)
and wo.intPriorityID in (107308,107309,107310)
and DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 1 AND DAYOFWEEK(wo.dtmSuggestedCompletionDate) <> 7
and wo.dtmSuggestedCompletionDate between '2021-01-01' and '2021-06-30'
group by 1) wo1)as "Box_14"