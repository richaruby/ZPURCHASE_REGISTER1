//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Pricing Elements for Purchase Register'
//@Metadata.allowExtensions: true
//define view entity ZI_PO_PRICING_AGG
//  as select from I_PurOrdItmPricingElementAPI01
//{
//  key PurchaseOrder,
//  key PurchaseOrderItem,
//      ConditionCurrency,
//
//      /* ================= INR VALUES (Existing Fields) ================= */
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZINS'
//           and ConditionCurrency = 'INR'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as Insurance,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZDIS'
//           and ConditionCurrency = 'INR'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as Discount,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZCOM'
//           and ConditionCurrency = 'INR'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as Commission,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZP&F'
//           and ConditionCurrency = 'INR'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as PackingForwarding,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZFVA'
//           and ConditionCurrency = 'INR'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as Freight,
//
//      /* ================= USD VALUES (New Fields) ================= */
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZINS'
//           and ConditionCurrency = 'USD'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as InsuranceUSD,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZDIS'
//           and ConditionCurrency = 'USD'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as DiscountUSD,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZCOM'
//           and ConditionCurrency = 'USD'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as CommissionUSD,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZP&F'
//           and ConditionCurrency = 'USD'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as PackingForwardingUSD,
//
//      @Semantics.amount.currencyCode: 'ConditionCurrency'
//      sum(
//        case
//          when ConditionType = 'ZFVA'
//           and ConditionCurrency = 'USD'
//            then cast( ConditionAmount as abap.dec(15,2) )
//          else cast( 0 as abap.dec(15,2) )
//        end
//      ) as FreightUSD
//}
//group by
//  PurchaseOrder,
//  PurchaseOrderItem,
//  ConditionCurrency

@AbapCatalog.viewEnhancementCategory: [#NONE]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Pricing Elements for Purchase Register'

@Metadata.allowExtensions: true

define view entity ZI_PO_PRICING_AGG

  as select from I_PurOrdItmPricingElementAPI01

{

  key PurchaseOrder,

  key PurchaseOrderItem,
 
      /* --- FIX: Create Static Currency Keys --- */

      /* Do not select ConditionCurrency from the table. Create your own. */

      cast( 'INR' as abap.cuky ) as CurrencyINR,

      cast( 'USD' as abap.cuky ) as CurrencyUSD,
 
      /* ================= INR VALUES (Link to CurrencyINR) ================= */
 
      @Semantics.amount.currencyCode: 'CurrencyINR'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZINS'

           and ConditionCurrency = 'INR'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as Insurance,
 
      @Semantics.amount.currencyCode: 'CurrencyINR'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZDIS'

           and ConditionCurrency = 'INR'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as Discount,
 
      @Semantics.amount.currencyCode: 'CurrencyINR'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZCOM'

           and ConditionCurrency = 'INR'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as Commission,
 
      @Semantics.amount.currencyCode: 'CurrencyINR'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZP&F'

           and ConditionCurrency = 'INR'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as PackingForwarding,
 
      @Semantics.amount.currencyCode: 'CurrencyINR'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZFVA'

           and ConditionCurrency = 'INR'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as Freight,
 
      /* ================= USD VALUES (Link to CurrencyUSD) ================= */
 
      @Semantics.amount.currencyCode: 'CurrencyUSD'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZINS'

           and ConditionCurrency = 'USD'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as InsuranceUSD,
 
      @Semantics.amount.currencyCode: 'CurrencyUSD'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZDIS'

           and ConditionCurrency = 'USD'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as DiscountUSD,
 
      @Semantics.amount.currencyCode: 'CurrencyUSD'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZCOM'

           and ConditionCurrency = 'USD'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as CommissionUSD,
 
      @Semantics.amount.currencyCode: 'CurrencyUSD'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZP&F'

           and ConditionCurrency = 'USD'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as PackingForwardingUSD,
 
      @Semantics.amount.currencyCode: 'CurrencyUSD'   /* <--- CHANGED */

      sum(

        case

          when ConditionType = 'ZFVA'

           and ConditionCurrency = 'USD'

            then cast( ConditionAmount as abap.dec(15,2) )

          else cast( 0 as abap.dec(15,2) )

        end

      ) as FreightUSD

}

group by

  PurchaseOrder,

  PurchaseOrderItem

  /* No ConditionCurrency here! */
 
