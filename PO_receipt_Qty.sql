select 
po.intCode, po.dtmDateCreated, lt.strDescription, lt.qtyOnOrder, rlt.qtyQuantityReceived,
r.dtmDateReceived, dblPurchasePricePerUnit, 
dblPurchasePricePerUnit*rlt.qtyQuantityReceived as "Total"
																														  
from tblPurchaseOrder po
left join tblPurchaseOrderLineItem lt on po.id = lt.intPurchaseOrderID
left join tblAsset a on a.id = po.intAssetID
left join tblReceiptLineItem rlt on lt.id = rlt.intPurchaseOrderLineItemID
inner join tblReceipt r on r.id = rlt.intReceiptID
where po.intTenantID = 26223 and lt.dtmDateCreated between '2020-01-01' and '2021-06-26'
order by lt.dtmDateCreated desc