select q.strCode as "asset code"
, q.strName as "asset name"
, q.woCode as "wo code"
, q.woDesc as "wo description"
, q.woMaintenance as "wo maintenance"
, CAST(SUM(case when q.intCostTypeID = 1 then q.dblInventoryCost else 0 end) AS DECIMAL (10,2)) as "labor cost"
, CAST(SUM(case when q.intCostTypeID = 2 then q.dblInventoryCost else 0 end) AS DECIMAL(10,2)) as "part cost"
, CAST(SUM(case when q.intCostTypeID = 3 then q.dblInventoryCost else 0 end) AS DECIMAL(10,2)) as "misc cost"
, (
CAST(SUM(case when q.intCostTypeID = 1 then q.dblInventoryCost else 0 end) AS DECIMAL (10,2))
+ CAST(SUM(case when q.intCostTypeID = 2 then q.dblInventoryCost else 0 end) AS DECIMAL(10,2))
+ CAST(SUM(case when q.intCostTypeID = 3 then q.dblInventoryCost else 0 end) AS DECIMAL(10,2))
  + CAST(q.totalPOCost AS DECIMAL (10,2))
) as "total cost"
, CAST(q.totalPOCost AS DECIMAL (10,2)) as "total po cost"
from

(
    select
     a.id assetid
     , a.strCode
     , a.strName
     , wol.id wolid
     , wol.dblInventoryCost
     , wol.intCostTypeID
     , w.woid
     , w.woCode
     , w.woDesc
     , w.woCompleted
     , w.woMaintenance
     , w.totalPOCost
    from
    (   select
         wo.id woid
         ,wo.strCode woCode
         , wo.strDescription woDesc
         , wo.dtmDateCompleted woCompleted
     , mt.strName woMaintenance
         ,p.*
         , FORMAT(SUM(p.qtyOnOrder * p.dblUnitPrice), 2) totalPOCost
         , count(*)
        from  tblWorkOrder wo
        join tblMaintenanceType mt on wo.intMaintenanceTypeID = mt.id
        join(
            select pol.id,
            po.intCode
            , pol.intSourceWorkOrderID
            , pol.strDescription
            , pol.dblUnitPrice
            , pol.qtyOnOrder
            , rli.qtyQuantityReceived
            from tblPurchaseOrderLineItem pol
            join tblPurchaseOrder po on pol.intPurchaseOrderID = po.id
            left  join tblReceiptLineItem rli on rli.intPurchaseOrderLineItemID = pol.id
            where pol.intTenantID = 38101
            group by pol.id
        ) p on  p.intSourceWorkOrderID = wo.id
        where wo.intTenantID = 38101
        and wo.dtmDateCompleted between '2022-02-01' and '2022-02-28'
         #AND $X{IN,wo.intMaintenanceTypeID,MAINTENANCETYPEID}
        group by wo.id
    ) w
    join tblWorkOrderAsset woa on woa.intWorkOrderID = w.woid
    left join tblAsset a on woa.intAssetID = a.id
    join tblAssetResolved ar on ar.intDescendantID = a.id
    left join tblWorkOrderLog wol on wol.intWorkOrderID = w.woid
    where 1 = 1
    and a.intTenantID = 38101
    #and $X{IN,ar.intAncestorID ,ASSETID}
    #and $X{IN,a.intCategoryID ,ASSETCATEGORYID}

    group by a.id, w.woid , wol.id

)q

group by q.assetid, q.woid