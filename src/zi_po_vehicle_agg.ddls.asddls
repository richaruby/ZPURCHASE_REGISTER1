@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aggregation for Vehicle Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_VEHICLE_AGG
  as select distinct from I_MaterialDocumentItem_2
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  
  /* Select the latest or distinct value using MAX */
  YY1_fuel_MMI            as FuelType,
  YY1_Transmission_typ_MMI as TransmissionType,
  YY1_Engine_no_MMI        as EngineNo,
  YY1_vin_no_MMI           as VinNo,
  YY1_colour_MMI          as Colour
}
group by
  PurchaseOrder,
  PurchaseOrderItem,
  YY1_fuel_MMI,
  YY1_Transmission_typ_MMI,
  YY1_Engine_no_MMI,
  YY1_vin_no_MMI,
  YY1_colour_MMI
