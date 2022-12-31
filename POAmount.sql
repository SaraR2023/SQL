select 
t."id", t."site", t."poCode" as "code", 
t."bid" as "bid", t."Supplier" as "supplier",
t."expectedDelivery" as "ETA", 
group_concat(t."line" separator ';\n') as "lines",
(case
when t."bol" is not null then round(sum(t."Cost of Items") + t."Add.Costs"/count(distinct t."poCode") ,2)
when t."bol" is null then round(sum(t."Cost of Items") + sum(t."tax") + t."Add.Costs"/count(distinct t."poCode") ,2)
end ) as "poTotal"
from
(select 
site.id as "id",
site.strName as "site",
po.intCode as "poCode",
b.id as "bid",
b.strName as "Supplier",
po.dtmDateExpectedDelivery as "expectedDelivery", 
lt.strDescription as "line",
if(lt.dblTaxRate is null, 0,lt.dblTaxRate* lt.dblUnitPrice* lt.qtyOnOrder/100)  as "tax",
lt.qtyOnOrder*lt.dblUnitPrice as "Cost of Items", 
sum(ac.dblPrice) as "Add.Costs",
ac.bolOverridePoLineItemTax as "bol"

from tblPurchaseOrder po
join tblAsset site on site.id = po.intSiteID
join tblPurchaseOrderLineItem lt on po.id = lt.intPurchaseOrderID
join tblPurchaseOrderAdditionalCost ac on po.id = ac.intPurchaseOrderID
join tblBusiness b on b.id = po.intSupplierID
where po.intTenantID = 26223
group by lt.id) t 
where t."expectedDelivery" between '2021-10-01' and '2021-10-21'
and t."bid" in (384522)
group by t."poCode"