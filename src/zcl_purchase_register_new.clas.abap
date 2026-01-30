CLASS zcl_purchase_register_new DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_PURCHASE_REGISTER_NEW IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF zce_purchase_register_new,
          ls_response TYPE zce_purchase_register_new.

*-----------------------------------------------------------------------
* RAP contract
*-----------------------------------------------------------------------
    DATA lo_filter TYPE REF TO if_rap_query_filter.

    lo_filter = io_request->get_filter( ).
    io_request->get_sort_elements( ).
    io_request->get_requested_elements( ).
    io_request->get_paging( ).

*-----------------------------------------------------------------------
* Pagination
*-----------------------------------------------------------------------
    DATA lv_top  TYPE i.
    DATA lv_skip TYPE i.

    lv_top  = io_request->get_paging( )->get_page_size( ).
    lv_skip = io_request->get_paging( )->get_offset( ).

    IF lv_top < 0.
      lv_top = 1.
    ENDIF.

    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields) = io_request->get_requested_elements( ).
    DATA(lt_sort)   = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    " Extract filter ranges
    DATA(lr_supplierinvoice) = VALUE #( lt_filter_cond[ name = 'SUPPLIERINVOICE' ]-range OPTIONAL ).
    DATA(lr_purchaseorder) = VALUE #( lt_filter_cond[ name = 'PURCHASEORDER' ]-range OPTIONAL ).
    DATA(lr_accountingdocument) = VALUE #( lt_filter_cond[ name = 'ACCOUNTINGDOCUMENT' ]-range OPTIONAL ).

* ---------------------------------------------------------------------
    SELECT
      a~invoicingparty,
    a~companycode,
    a~fiscalyear,
    a~supplierinvoice,
      a~supplierinvoiceidbyinvcgparty,
    a~paymentterms,
    a~documentcurrency,
    a~documentdate,
    a~postingdate,
    a~supplierinvoicewthnfiscalyear,
     a~exchangerate,
      a~invoicegrossamount,
       a~businessplace,
*    a~yy1_note1_mih,
     b~supplierinvoiceitem,
    b~purchaseorder,
       b~plant,
      b~supplierinvoiceitemamount,
    b~suplrinvcdeliverycostcndntype,
    b~supplierinvoiceitemtext,
    b~suplrinvcitmunplnddelivcost,
    b~taxcode,
    b~purchaseorderitem,
    b~quantityinpurchaseorderunit,
    b~purchaseorderquantityunit,
    c~accountingdocument,
      c~amountintransactioncurrency,
      c~cgst,
      c~glaccount,
      c~igst,
*      c~originalreferencedocument,
      c~rmcgst,
      c~rmigst,
      c~rmsgst,
      c~rmugst,
      c~sgst,
      c~transactioncurrency,
      c~ugst,
       d~accountingdocumentitem,
      d~in_hsnorsaccode,
      d~transactiontypedetermination
    FROM i_supplierinvoiceapi01 AS a
    LEFT JOIN i_suplrinvcitempurordrefapi01 AS b
            ON b~supplierinvoice = a~supplierinvoice
     AND b~fiscalyear      = a~fiscalyear
     LEFT JOIN zzce_pur_tax_agg  AS c
      ON  c~originalreferencedocument = a~supplierinvoicewthnfiscalyear
      OR c~originalreferencedocument = b~purchaseorder
      AND c~taxitemgroup = substring( b~supplierinvoiceitem, 4, 3 )
    AND c~fiscalyear = a~fiscalyear
     LEFT JOIN zce_pur_reg3 AS d
            ON d~originalreferencedocument = a~supplierinvoicewthnfiscalyear
           AND d~fiscalyear = a~fiscalyear
     WHERE      c~accountingdocument    IN @lr_accountingdocument
    AND   a~supplierinvoice     IN @lr_supplierinvoice
      AND  purchaseorder IN @lr_purchaseorder
    INTO TABLE @DATA(it_base).

*    IF it_base IS NOT INITIAL.
      SELECT   purchaseordertype,
      supplier,
      purchaseorder
      FROM i_purchaseorderapi01
*      FOR ALL ENTRIES IN @it_base
      WHERE purchaseorder IN @lr_purchaseorder
      INTO TABLE @DATA(it_po_type).

*      * ---------------------------------------------------------------------
* STO-specific data (only for ZUB/ZST purchase order types)
* ---------------------------------------------------------------------
IF it_po_type IS NOT INITIAL.
  TYPES: BEGIN OF ty_doc_ref,
           DocumentReferenceID TYPE i_journalentry-DocumentReferenceID,
         END OF ty_doc_ref.
  " Filter only ZUB/ZST purchase orders
  DATA: lt_pur_hist_converted TYPE STANDARD TABLE OF ty_doc_ref.
  DATA(it_sto_po) = it_po_type.
  DELETE it_sto_po WHERE purchaseordertype <> 'ZUB'
                     AND purchaseordertype <> 'ZST'.

  IF it_sto_po IS NOT INITIAL.
    " Add STO-specific queries here



    select from C_PURCHASEORDERHISTORYDEX
    fields
    PurchasingHistoryDocument
    for all entries in @it_sto_po
    where PurchaseOrder = @it_sto_po-PurchaseOrder
    and PurchasingHistoryCategory = 'L'
    into table @data(it_pur_hist).

 select from i_billingdocumentitem
 fields BillingDocument
 for all entries in @it_pur_hist
 where ReferenceSDDocument = @it_pur_hist-PurchasingHistoryDocument
 into table @data(it_bill_doc_hist).

 if it_bill_doc_hist is not initial.
 select from i_journalentry
 fields DocumentReferenceID
 for all entries in @it_bill_doc_hist
 where AccountingDocument = @it_bill_doc_hist-BillingDocument
 into table @data(it_doc_ref).

* else.
 lt_pur_hist_converted = VALUE #( FOR wa IN it_pur_hist
                                    ( DocumentReferenceID = wa-PurchasingHistoryDocument ) ).


 select from i_journalentry
 fields AccountingDocument
  FOR ALL ENTRIES IN @lt_pur_hist_converted
 where DocumentReferenceID = @lt_pur_hist_converted-DocumentReferenceID
 into table @it_doc_ref.

 endif.




  ENDIF.
*ENDIF.

      SELECT bpaddrstreetname,
            bpsupplierfullname,
            cityname,
            supplier,
            businesspartnerpannumber
            FROM i_supplier
            FOR ALL ENTRIES IN @it_base
            WHERE supplier = @it_base-invoicingparty
            INTO TABLE @DATA(it_supplier).

      SELECT
       bpidentificationnumber,
  businesspartner
     FROM i_bupaidentification
      FOR ALL ENTRIES IN @it_supplier
                 WHERE businesspartner = @it_supplier-supplier
                AND bpidentificationtype = 'MSME V'
                INTO TABLE @DATA(it_bp_iden).

      SELECT incotermsclassification,
           netpriceamount,
           producttype,
           purchaseorderitem,
           purchaseorderitemtext,
           purchaseorder,
           material
           FROM i_purchaseorderitemapi01
           FOR ALL ENTRIES IN @it_base
           WHERE purchaseorder = @it_base-purchaseorder
           AND purchaseorderitem = @it_base-purchaseorderitem
           INTO TABLE @DATA(it_po_item).

      SELECT
       taxcodename,
       taxcode
       FROM i_taxcodetext
       FOR ALL ENTRIES IN @it_base
       WHERE taxcode = @it_base-taxcode
        AND taxcalculationprocedure = '0TXIN'
       INTO TABLE @DATA(it_taxcode).

      SELECT
 cgst_rate,
 igst_rate,
 rcm_cgst_rate,
 rcm_igst_rate,
 rcm_sgst_rate,
 rcm_ugst_rate,
 sgst_rate,
 ugst_rate,
 taxcode
 FROM   zfit_tax_perc
 FOR ALL ENTRIES IN @it_base
     WHERE taxcode = @it_base-taxcode
     INTO TABLE @DATA(it_gst).
    ENDIF.

    SELECT accountingdocumentheadertext,
        accountingdocumenttype,
        isreversed,
        accountingdocument
  FROM i_journalentry
  FOR ALL ENTRIES IN @it_base
          WHERE accountingdocument = @it_base-accountingdocument
          AND fiscalyear = @it_base-fiscalyear
          INTO TABLE @DATA(it_journal).

    SELECT debitcreditcode,
         postingkey,
         accountingdocument,
         companycode,
         fiscalyear
         FROM    i_accountingdocumentjournal
         FOR ALL ENTRIES IN @it_base
              WHERE accountingdocument = @it_base-accountingdocument
              AND companycode = @it_base-companycode
              AND fiscalyear = @it_base-fiscalyear
              INTO TABLE @DATA(it_acc_journal).

    SELECT commission,
conditioncurrency,
discount,
insurance,
packingforwarding,
freight,
purchaseorder,
purchaseorderitem
FROM zi_po_pricing_agg
FOR ALL ENTRIES IN @it_base
 WHERE purchaseorder = @it_base-purchaseorder
AND purchaseorderitem = @it_base-purchaseorderitem
INTO TABLE @DATA(it_prc_agg).

    IF it_po_item IS NOT INITIAL.
      SELECT name,
      producttypecode
      FROM   i_producttypecodetext
      FOR ALL ENTRIES IN @it_po_item
     WHERE producttypecode = @it_po_item-producttype
     INTO TABLE @DATA(it_name).

      IF it_po_type IS NOT INITIAL.
        SELECT bptaxnumber,
        businesspartner
        FROM i_businesspartnertaxnumber
        FOR ALL ENTRIES IN @it_po_type
        WHERE businesspartner = @it_po_type-supplier
        INTO TABLE @DATA(it_bp_tax).
      ENDIF.

    ENDIF.

*-------------------
* Loop through main data table
    LOOP AT it_base ASSIGNING FIELD-SYMBOL(<fs_base>).

      CLEAR ls_response.

      " ============ Map Key Fields ============
      ls_response-invoicingparty                = <fs_base>-invoicingparty.
      ls_response-companycode                   = <fs_base>-companycode.
      ls_response-fiscalyear                    = <fs_base>-fiscalyear.
      ls_response-supplierinvoice               = <fs_base>-supplierinvoice.
      ls_response-supplierinvoiceitem           = <fs_base>-supplierinvoiceitem.
      ls_response-purchaseorder                 = <fs_base>-purchaseorder.
      ls_response-purchaseorderitem             = <fs_base>-purchaseorderitem.
      ls_response-quantityinpurchaseorderunit   = <fs_base>-quantityinpurchaseorderunit.
      ls_response-purchaseorderquantityunit     = <fs_base>-purchaseorderquantityunit.
      ls_response-plant                         = <fs_base>-plant.
      ls_response-documentdate                  = <fs_base>-documentdate.
      ls_response-postingdate                   = <fs_base>-postingdate.
      ls_response-supplierinvoicewthnfiscalyear = <fs_base>-supplierinvoicewthnfiscalyear.

      " ============ Map Header Fields ============
      ls_response-paymentterms                  = <fs_base>-paymentterms.
      ls_response-documentcurrency              = <fs_base>-documentcurrency.
      ls_response-supplierinvoiceidbyinvcgparty = <fs_base>-supplierinvoiceidbyinvcgparty.
      ls_response-exchangerate                  = <fs_base>-exchangerate.
*      ls_response-notes                         = <fs_base>-yy1_note1_mih.

      " ============ Map Accounting Data ============
      ls_response-accountingdocument            = <fs_base>-accountingdocument.
      ls_response-amountintransactioncurrency   = <fs_base>-amountintransactioncurrency.
      ls_response-glaccount                     = <fs_base>-glaccount.
*      ls_response-originalreferencedocument     = <fs_base>-originalreferencedocument.
      ls_response-transactioncurrency           = <fs_base>-transactioncurrency.
      ls_response-accountingdocumentitem        = <fs_base>-accountingdocumentitem.
      ls_response-hsn                           = <fs_base>-in_hsnorsaccode.

      " ============ Set Display Currencies ============
      ls_response-displaycurrencyinr = 'INR'.
      ls_response-displaycurrencyusd = 'USD'.

      " ============ Read Purchase Order Type ============
      SORT it_po_type BY
       purchaseorder.
      READ TABLE it_po_type ASSIGNING FIELD-SYMBOL(<fs_po_type>)
        WITH KEY purchaseorder = <fs_base>-purchaseorder.
      IF sy-subrc = 0.
        ls_response-supplier          = <fs_po_type>-supplier.
        ls_response-purchaseordertype = <fs_po_type>-purchaseordertype.
      ENDIF.

      " ============ Read Supplier Data ============
      SORT it_supplier BY
       supplier.
      READ TABLE it_supplier ASSIGNING FIELD-SYMBOL(<fs_supplier>)
        WITH KEY supplier = <fs_base>-invoicingparty.
      IF sy-subrc = 0.
        ls_response-suppliername = <fs_supplier>-bpsupplierfullname.
        ls_response-cityname     = <fs_supplier>-cityname.
        ls_response-address      = <fs_supplier>-bpaddrstreetname.
        ls_response-supplierpan  = <fs_supplier>-businesspartnerpannumber.
      ENDIF.

      " ============ Read MSME Data ============
      IF <fs_po_type> IS ASSIGNED.
        SORT it_bp_iden BY
         businesspartner.
        READ TABLE it_bp_iden ASSIGNING FIELD-SYMBOL(<fs_bp_iden>)
          WITH KEY businesspartner = <fs_po_type>-supplier.
        IF sy-subrc = 0.
          ls_response-msme = <fs_bp_iden>-bpidentificationnumber.
        ENDIF.
      ENDIF.

      " ============ Read Purchase Order Item Data ============
      SORT it_po_item BY
       purchaseorder
       purchaseorderitem.
      READ TABLE it_po_item ASSIGNING FIELD-SYMBOL(<fs_po_item>)
        WITH KEY purchaseorder     = <fs_base>-purchaseorder
                 purchaseorderitem = <fs_base>-purchaseorderitem.
      IF sy-subrc = 0.
        ls_response-incotermsclassification = <fs_po_item>-incotermsclassification.
        ls_response-netpriceamount           = <fs_po_item>-netpriceamount.
        ls_response-producttype              = <fs_po_item>-producttype.
        ls_response-purchaseorderitemtext    = <fs_po_item>-purchaseorderitemtext.
        ls_response-material                 = <fs_po_item>-material.
      ENDIF.

      " ============ Read Tax Code Name ============
      SORT it_taxcode BY
       taxcode.
      READ TABLE it_taxcode ASSIGNING FIELD-SYMBOL(<fs_taxcode>)
        WITH KEY taxcode = <fs_base>-taxcode.
      IF sy-subrc = 0.
        ls_response-taxcodename = <fs_taxcode>-taxcodename.
      ENDIF.

      " ============ Read GST Rates ============
      SORT it_gst BY
       taxcode.
      READ TABLE it_gst ASSIGNING FIELD-SYMBOL(<fs_gst>)
        WITH KEY taxcode = <fs_base>-taxcode.
      IF sy-subrc = 0.
        ls_response-cgst_rate     = <fs_gst>-cgst_rate.
        ls_response-igst_rate     = <fs_gst>-igst_rate.
        ls_response-rcm_cgst_rate = <fs_gst>-rcm_cgst_rate.
        ls_response-rcm_igst_rate = <fs_gst>-rcm_igst_rate.
        ls_response-rcm_sgst_rate = <fs_gst>-rcm_sgst_rate.
        ls_response-rcm_ugst_rate = <fs_gst>-rcm_ugst_rate.
        ls_response-sgst_rate     = <fs_gst>-sgst_rate.
        ls_response-ugst_rate     = <fs_gst>-ugst_rate.
      ENDIF.

      " ============ Read Journal Entry Data ============
      DATA(lv_is_reversed) = abap_false.
      SORT it_journal BY
       accountingdocument.
      READ TABLE it_journal ASSIGNING FIELD-SYMBOL(<fs_journal>)
        WITH KEY accountingdocument = <fs_base>-accountingdocument.
      IF sy-subrc = 0.
        ls_response-accountingdocumentheadertext = <fs_journal>-accountingdocumentheadertext.
        ls_response-accountingdocumenttype       = <fs_journal>-accountingdocumenttype.
        IF <fs_journal>-isreversed = 'X'.
          lv_is_reversed = abap_true.
        ENDIF.
      ENDIF.

      " ============ Read Accounting Document Journal ============
      SORT it_acc_journal BY
          accountingdocument
          companycode
          fiscalyear.
      READ TABLE it_acc_journal ASSIGNING FIELD-SYMBOL(<fs_acc_jrnl>)
        WITH KEY accountingdocument = <fs_base>-accountingdocument
                 companycode        = <fs_base>-companycode
                 fiscalyear         = <fs_base>-fiscalyear.
      IF sy-subrc = 0.
        ls_response-debitcreditcode = <fs_acc_jrnl>-debitcreditcode.
        ls_response-postingkey      = <fs_acc_jrnl>-postingkey.
      ENDIF.

      " ============ Read Pricing Aggregation ============
      SORT it_prc_agg BY
       purchaseorder
       purchaseorderitem.
      READ TABLE it_prc_agg ASSIGNING FIELD-SYMBOL(<fs_prc_agg>)
        WITH KEY purchaseorder     = <fs_base>-purchaseorder
                 purchaseorderitem = <fs_base>-purchaseorderitem.
      IF sy-subrc = 0.
        ls_response-commission        = <fs_prc_agg>-commission.
        ls_response-conditioncurrency = <fs_prc_agg>-conditioncurrency.
        ls_response-discount          = <fs_prc_agg>-discount.
        ls_response-insurance         = <fs_prc_agg>-insurance.
        ls_response-packingforwarding = <fs_prc_agg>-packingforwarding.
        ls_response-freight           = <fs_prc_agg>-freight.
      ENDIF.

      " ============ Read Product Type Name ============
      IF <fs_po_item> IS ASSIGNED.
        SORT it_name BY
         producttypecode.
        READ TABLE it_name ASSIGNING FIELD-SYMBOL(<fs_name>)
          WITH KEY producttypecode = <fs_po_item>-producttype.
        IF sy-subrc = 0.
          ls_response-producttypename = <fs_name>-name.
        ENDIF.
      ENDIF.

      " ============ Read Business Partner Tax Number (GSTIN) ============
      IF <fs_po_type> IS ASSIGNED.
        SORT it_bp_tax BY
         businesspartner.
        READ TABLE it_bp_tax ASSIGNING FIELD-SYMBOL(<fs_bp_tax>)
          WITH KEY businesspartner = <fs_po_type>-supplier.
        IF sy-subrc = 0.
          ls_response-bptaxnumber = <fs_bp_tax>-bptaxnumber.
        ENDIF.
      ENDIF.

      " ============ Map Plant GSTIN Based on Company Code and Business Place ============
      IF <fs_base>-companycode = 'MPPL'.
        CASE <fs_base>-businessplace.
          WHEN 'MUD1' OR 'MUD2' OR 'MUD3' OR 'MUD4'.
            ls_response-plantgstin = '26AAOCM3634M1ZZ'.
          WHEN 'MUV1' OR 'MUV2'.
            ls_response-plantgstin = '24AAOCM3634M2Z2'.
          WHEN 'MDAM'.
            ls_response-plantgstin = '24AAOCM3634M1Z3'.
          WHEN 'MDHR'.
            ls_response-plantgstin = '05AAOCM3634M1Z3'.
          WHEN 'MDHY'.
            ls_response-plantgstin = '36AAOCM3634M1ZY'.
          WHEN 'MDKN'.
            ls_response-plantgstin = '09AAOCM3634M1ZV'.
          WHEN 'MDKL'.
            ls_response-plantgstin = '19AAOCM3634M1ZU'.
        ENDCASE.
      ENDIF.

      " ============ Calculate Invoice Gross Amount with Currency Conversion ============
      DATA(lv_reversal_factor) = COND #( WHEN lv_is_reversed = abap_true THEN -1 ELSE 1 ).

      " Invoice Gross Amount (INR)
      ls_response-invoicegrossamount = COND #(
         WHEN <fs_base>-documentcurrency = 'INR'
         THEN <fs_base>-invoicegrossamount
         WHEN <fs_base>-documentcurrency = 'USD'
         THEN <fs_base>-invoicegrossamount * <fs_base>-exchangerate
         ELSE 0
*       ) * lv_reversal_factor.
        ).

      " Invoice Amount (INR only)
*      ls_response-invoiceamount = COND #(
*         WHEN <fs_base>-documentcurrency = 'INR'
*         THEN <fs_base>-invoicegrossamount
*         ELSE 0
*       ) * lv_reversal_factor.

      " Invoice Gross Amount (USD)
      ls_response-invoicegrossamount1 = COND #(
         WHEN <fs_base>-documentcurrency = 'USD'
         THEN <fs_base>-invoicegrossamount
         ELSE 0
*       ) * lv_reversal_factor.
        ).

      " ============ Calculate Supplier Invoice Item Amount ============
      IF <fs_base>-suplrinvcdeliverycostcndntype IS INITIAL.
        ls_response-supplierinvoiceitemamount = COND #(
           WHEN <fs_base>-documentcurrency = 'INR'
           THEN <fs_base>-supplierinvoiceitemamount
           WHEN <fs_base>-documentcurrency <> 'INR'
           THEN <fs_base>-supplierinvoiceitemamount * <fs_base>-exchangerate
           ELSE 0
         ) * lv_reversal_factor.
      ENDIF.

      " ============ Calculate Various Charges ============
      ls_response-suplrinvcdeliverycostcndntype = <fs_base>-suplrinvcdeliverycostcndntype.
      ls_response-supplierinvoiceitemtext       = <fs_base>-supplierinvoiceitemtext.
      ls_response-suplrinvcitmunplnddelivcost   = <fs_base>-suplrinvcitmunplnddelivcost.
      ls_response-taxcode                       = <fs_base>-taxcode.

      " Import Freight Charge
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZFVI' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZIF1'.
        ls_response-impfcharge = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " Parking Charge (INR/USD)
      IF <fs_base>-glaccount = '0000410109'.
        IF <fs_base>-documentcurrency = 'INR'.
          ls_response-parkcharge_inr = <fs_base>-amountintransactioncurrency.
        ELSEIF <fs_base>-documentcurrency = 'USD'.
          ls_response-parkcharge_usd = <fs_base>-amountintransactioncurrency.
        ENDIF.
      ENDIF.

      " Round Off
      IF <fs_base>-glaccount = '0000450034'.
        ls_response-round = <fs_base>-amountintransactioncurrency.
      ENDIF.

      " Insurance Charge
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZIIV'.
        ls_response-inscharge = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " Other Expenses
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZOTC'.
        ls_response-otherexp = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " Customs Duty Charge
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZBCD' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZIOT'.
        ls_response-custdcharge = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " SWS Charge
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZSWC'.
        ls_response-swscharge = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " CHA Charges
      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZCHA' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZTCH' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZSTD' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZSLC' OR
         <fs_base>-suplrinvcdeliverycostcndntype = 'ZCFS'.
        ls_response-chacharge = <fs_base>-supplierinvoiceitemamount.
      ENDIF.

      " ============ Calculate GST Amounts (Excluding RCM Tax Codes) ============
      " CGST Amount
      IF <fs_base>-taxcode <> 'R1' OR <fs_base>-taxcode <> 'R2' OR
         <fs_base>-taxcode <> 'R3' OR <fs_base>-taxcode <> 'R4' OR
         <fs_base>-taxcode <> 'RA' OR <fs_base>-taxcode <> 'RB' OR
         <fs_base>-taxcode <> 'RC' OR <fs_base>-taxcode <> 'RD'.
        ls_response-cgstamt = <fs_base>-cgst * lv_reversal_factor.
      ENDIF.

      " SGST Amount
      IF <fs_base>-taxcode <> 'R1' OR <fs_base>-taxcode <> 'R2' OR
         <fs_base>-taxcode <> 'R3' OR <fs_base>-taxcode <> 'R4'.
        ls_response-sgstamt = <fs_base>-sgst * lv_reversal_factor.
      ENDIF.

      " IGST Amount
      IF <fs_base>-taxcode <> 'R5' OR <fs_base>-taxcode <> 'R6' OR
         <fs_base>-taxcode <> 'R7' OR <fs_base>-taxcode <> 'R8' OR
         <fs_base>-taxcode <> 'R9'.
        ls_response-igstamt = <fs_base>-igst * lv_reversal_factor.
      ENDIF.

      " UGST Amount
      IF <fs_base>-taxcode <> 'RA' OR <fs_base>-taxcode <> 'RB' OR
         <fs_base>-taxcode <> 'RC' OR <fs_base>-taxcode <> 'RD'.
        ls_response-ugstamt = <fs_base>-ugst * lv_reversal_factor.
      ENDIF.

      " ============ Calculate RCM GST Amounts ============
      ls_response-rmcgst = <fs_base>-rmcgst * lv_reversal_factor.
      ls_response-rmsgst = <fs_base>-rmsgst * lv_reversal_factor.
      ls_response-rmigst = <fs_base>-rmigst * lv_reversal_factor.
      ls_response-rmugst = <fs_base>-rmugst * lv_reversal_factor.

      " ============ Calculate TDS (Withholding Tax) ============
      IF <fs_base>-transactiontypedetermination = 'WIT'.
        ls_response-tds = abs( <fs_base>-amountintransactioncurrency ) * lv_reversal_factor.
      ENDIF.

      " ============ Calculate Total Tax Amount ============
      IF <fs_base>-taxcode <> 'R1' OR <fs_base>-taxcode <> 'R2' OR
         <fs_base>-taxcode <> 'R3' OR <fs_base>-taxcode <> 'R4' OR
         <fs_base>-taxcode <> 'RA' OR <fs_base>-taxcode <> 'RB' OR
         <fs_base>-taxcode <> 'RC' OR <fs_base>-taxcode <> 'RD'.
        ls_response-totaltaxamt = (
        <fs_base>-cgst +
        <fs_base>-ugst +
        <fs_base>-igst +
        <fs_base>-sgst
      ) * lv_reversal_factor.
      ENDIF.

      " ============ Calculate Total Tax (with Currency Conversion) ============
      DATA(lv_base_amount) = COND #(
        WHEN <fs_base>-suplrinvcdeliverycostcndntype IS INITIAL OR
             <fs_base>-suplrinvcdeliverycostcndntype = 'ZFVA'
        THEN <fs_base>-supplierinvoiceitemamount
        ELSE 0
      ).

      DATA(lv_parking_amount) = COND #(
        WHEN <fs_base>-glaccount = '0000410109'
        THEN <fs_base>-amountintransactioncurrency
        ELSE 0
      ).

      IF <fs_base>-documentcurrency = 'INR'.
        ls_response-totaltax = ( lv_base_amount + lv_parking_amount ) * lv_reversal_factor.
      ELSEIF <fs_base>-documentcurrency = 'USD'.
        ls_response-totaltax = ( lv_base_amount + lv_parking_amount ) *
                             <fs_base>-exchangerate * lv_reversal_factor.
        ls_response-totaltax1 = ( lv_base_amount + lv_parking_amount ) *
                              <fs_base>-exchangerate * lv_reversal_factor.
      ENDIF.

      " ============ Append to Final Table ============
      APPEND ls_response TO lt_response.

    ENDLOOP.
*-----------------------------------------------------------------------
* Pagination
*-----------------------------------------------------------------------

    " =====================================================
    " Remove duplicate RAP keys (MANDATORY for OData V4)
    " =====================================================
    SORT lt_response BY
      invoicingparty
      companycode
      fiscalyear
      supplierinvoice
      supplierinvoiceitem
      purchaseorder
      purchaseorderitem
      supplier
      plant
      documentdate
      postingdate
      supplierinvoicewthnfiscalyear.

    DELETE ADJACENT DUPLICATES FROM lt_response COMPARING
      invoicingparty
      companycode
      fiscalyear
      supplierinvoice
      supplierinvoiceitem
      purchaseorder
      purchaseorderitem
      supplier
      plant
      documentdate
      postingdate
      supplierinvoicewthnfiscalyear.


*      DATA: lv_po     TYPE ebeln,
*      lv_poitem TYPE ebelp.
*
*      DATA ls_data TYPE I_MATERIALDOCUMENTITEM_2.
*
*SELECT distinct
*    Batch,
*    MaterialDocument,
*    YY1_COLOUR_MMI,
*    YY1_ENGINE_NO_MMI,
*    YY1_VIN_NO_MMI,
*    YY1_FUEL_MMI,
*    YY1_TRANSMISSION_TYP_MMI
*  FROM I_MATERIALDOCUMENTITEM_2
*  WHERE PurchaseOrder     = @lv_po
*    AND PurchaseOrderItem = @lv_poitem
*INTO CORRESPONDING FIELDS OF @ls_data.
*enDSELECT.



    " =====================================================
    " Existing logic (keep as-is)
    " =====================================================
    SORT lt_response BY postingdate ASCENDING.
    DATA lv_total_count TYPE int8.
    lv_total_count = lines( lt_response ).

    DATA lt_paged TYPE STANDARD TABLE OF zce_purchase_register_new.
    DATA lv_idx TYPE i VALUE 0.

    LOOP AT lt_response INTO DATA(ls_row).
      lv_idx += 1.
      IF lv_idx > lv_skip AND lv_idx <= lv_skip + lv_top.
        APPEND ls_row TO lt_paged.
      ENDIF.
    ENDLOOP.

    io_response->set_total_number_of_records( lines( lt_response ) ).
    io_response->set_data( lt_paged ).

  ENDMETHOD.
ENDCLASS.
