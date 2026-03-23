CLASS zcl_purchase_register_new DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS zcl_purchase_register_new IMPLEMENTATION.


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
    DATA(lr_supplierinvoice)    = VALUE #( lt_filter_cond[ name = 'SUPPLIERINVOICE' ]-range OPTIONAL ).
    DATA(lr_purchaseorder)      = VALUE #( lt_filter_cond[ name = 'PURCHASEORDER' ]-range OPTIONAL ).
    DATA(lr_accountingdocument) = VALUE #( lt_filter_cond[ name = 'ACCOUNTINGDOCUMENT' ]-range OPTIONAL ).
    DATA(lr_cc)                 = VALUE #( lt_filter_cond[ name = 'COMPANYCODE' ]-range OPTIONAL ).
    DATA(lr_postingdt)          = VALUE #( lt_filter_cond[ name = 'POSTINGDATE' ]-range OPTIONAL ).
    DATA(lr_fyear)              = VALUE #( lt_filter_cond[ name = 'FISCALYEAR' ]-range OPTIONAL ).
* ---------------------------------------------------------------------

    TYPES: BEGIN OF ty_base,

             materialdocumentyear          TYPE i_materialdocumentitem_2-materialdocumentyear,
             materialdocument              TYPE i_materialdocumentitem_2-materialdocument,
             materialdocumentitem          TYPE i_materialdocumentitem_2-materialdocumentitem,

             goodsmovementtype             TYPE i_materialdocumentitem_2-goodsmovementtype,
             quantityinbaseunit            TYPE i_materialdocumentitem_2-quantityinbaseunit,
             entryunit                     TYPE i_materialdocumentitem_2-entryunit,
             postingdate_grn               TYPE i_materialdocumentitem_2-postingdate,
             totalgoodsmvtamtincccrcy      TYPE i_materialdocumentitem_2-totalgoodsmvtamtincccrcy,
             companycodecurrency           TYPE i_materialdocumentitem_2-companycodecurrency,

             invoicingparty                TYPE i_supplierinvoiceapi01-invoicingparty,
             companycode                   TYPE i_supplierinvoiceapi01-companycode,
             fiscalyear                    TYPE i_supplierinvoiceapi01-fiscalyear,
             supplierinvoice               TYPE i_supplierinvoiceapi01-supplierinvoice,
             supplierinvoiceidbyinvcgparty TYPE i_supplierinvoiceapi01-supplierinvoiceidbyinvcgparty,
             paymentterms                  TYPE i_supplierinvoiceapi01-paymentterms,
             documentcurrency              TYPE i_supplierinvoiceapi01-documentcurrency,
             documentdate                  TYPE i_supplierinvoiceapi01-documentdate,
             postingdate                   TYPE i_supplierinvoiceapi01-postingdate,
             supplierinvoicewthnfiscalyear TYPE i_supplierinvoiceapi01-supplierinvoicewthnfiscalyear,
             exchangerate                  TYPE i_supplierinvoiceapi01-exchangerate,
             invoicegrossamount            TYPE i_supplierinvoiceapi01-invoicegrossamount,
             businessplace                 TYPE i_supplierinvoiceapi01-businessplace,
             yy1_note1_mih                 TYPE i_supplierinvoiceapi01-yy1_note1_mih,
             supplierinvoiceitem           TYPE i_suplrinvcitempurordrefapi01-supplierinvoiceitem,
             purchaseorder                 TYPE i_suplrinvcitempurordrefapi01-purchaseorder,
             plant                         TYPE i_suplrinvcitempurordrefapi01-plant,
             supplierinvoiceitemamount     TYPE i_suplrinvcitempurordrefapi01-supplierinvoiceitemamount,
             suplrinvcdeliverycostcndntype TYPE i_suplrinvcitempurordrefapi01-suplrinvcdeliverycostcndntype,
             supplierinvoiceitemtext       TYPE i_suplrinvcitempurordrefapi01-supplierinvoiceitemtext,
             suplrinvcitmunplnddelivcost   TYPE i_suplrinvcitempurordrefapi01-suplrinvcitmunplnddelivcost,
             taxcode                       TYPE i_suplrinvcitempurordrefapi01-taxcode,
             purchaseorderitem             TYPE i_suplrinvcitempurordrefapi01-purchaseorderitem,
             quantityinpurchaseorderunit   TYPE i_suplrinvcitempurordrefapi01-quantityinpurchaseorderunit,
             purchaseorderquantityunit     TYPE i_suplrinvcitempurordrefapi01-purchaseorderquantityunit,
             accountingdocument            TYPE zzce_pur_tax_agg-accountingdocument,
             amountintransactioncurrency   TYPE zzce_pur_tax_agg-amountintransactioncurrency,
             cgst                          TYPE zzce_pur_tax_agg-cgst,
             glaccount                     TYPE zzce_pur_tax_agg-glaccount,
             igst                          TYPE zzce_pur_tax_agg-igst,
             rmcgst                        TYPE zzce_pur_tax_agg-rmcgst,
             rmigst                        TYPE zzce_pur_tax_agg-rmigst,
             rmsgst                        TYPE zzce_pur_tax_agg-rmsgst,
             rmugst                        TYPE zzce_pur_tax_agg-rmugst,
             sgst                          TYPE zzce_pur_tax_agg-sgst,
             transactioncurrency           TYPE zzce_pur_tax_agg-transactioncurrency,
             ugst                          TYPE zzce_pur_tax_agg-ugst,
             accountingdocumentitem        TYPE zce_pur_reg3-accountingdocumentitem,
             in_hsnorsaccode               TYPE zce_pur_reg3-in_hsnorsaccode,
             transactiontypedetermination  TYPE zce_pur_reg3-transactiontypedetermination,
             referencedocument             TYPE i_accountingdocumentjournal-referencedocument,
             cgstgl                        TYPE i_accountingdocumentjournal-glaccount,
             sgstgl                        TYPE i_accountingdocumentjournal-glaccount,
             ugstgl                        TYPE i_accountingdocumentjournal-glaccount,
             igstgl                        TYPE i_accountingdocumentjournal-glaccount,
             reversedocument               TYPE i_supplierinvoiceapi01-reversedocument,
             reversalindicator             TYPE char1,
             roundoff                      TYPE i_accountingdocumentjournal-creditamountinbalancetranscrcy,
             referencedocumentitem         TYPE i_accountingdocumentjournal-referencedocumentitem,
             invoiceamtincocodecrcy        TYPE i_purchaseorderhistoryapi01-invoiceamtincocodecrcy,
           END OF ty_base.

    DATA : it_base      TYPE TABLE OF ty_base,
           it_base_temp TYPE TABLE OF ty_base,
           ls_base      TYPE ty_base,
           lv_creditind TYPE c,
           lv_totamount TYPE i_accountingdocumentjournal-debitamountinbalancetranscrcy.

    SELECT
      a1~materialdocumentyear,
      a1~materialdocument,
      a1~materialdocumentitem,
      a1~goodsmovementtype,
      a1~quantityinbaseunit,
      a1~entryunit,
      a1~postingdate AS postingdate_grn ,
      a1~totalgoodsmvtamtincccrcy,
      a1~companycodecurrency,
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
      a~yy1_note1_mih,
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
      a~supplierinvoice AS referencedocument,
      b~supplierinvoiceitem AS referencedocumentitem,
      a~reversedocument
    FROM
    i_materialdocumentitem_2 AS a1
    LEFT JOIN i_suplrinvcitempurordrefapi01 AS b ON a1~purchaseorder = b~purchaseorder AND a1~purchaseorderitem = b~purchaseorderitem
    LEFT JOIN i_supplierinvoiceapi01 AS a ON b~supplierinvoice = a~supplierinvoice AND b~fiscalyear      = a~fiscalyear
         WHERE a~supplierinvoice       IN @lr_supplierinvoice
           AND a~companycode           IN @lr_cc
           AND a~postingdate           IN @lr_postingdt
           AND a~fiscalyear            IN @lr_fyear
           AND b~purchaseorder         IN @lr_purchaseorder
           AND a1~goodsmovementtype IN ( '101', '105' ) AND a1~purchaseorder NE '' AND a1~goodsmovementiscancelled = ''
      INTO CORRESPONDING FIELDS OF TABLE @it_base.

    SORT it_base ASCENDING BY purchaseorder purchaseorderitem supplierinvoice supplierinvoiceitem.
    DELETE ADJACENT DUPLICATES FROM it_base COMPARING purchaseorder purchaseorderitem supplierinvoice supplierinvoiceitem.

    IF  it_base IS NOT INITIAL.

      SELECT FROM i_accountingdocumentjournal
      FIELDS purchasingdocument,
             purchasingdocumentitem,
             accountingdocument,
             accountingdocumentitem,
             companycode,
             fiscalyear,
             glaccount,
             taxcode,
             ledger,
             documentreferenceid,
             transactiontypedetermination,
             supplier,
             financialaccounttype,
             postingdate,
             documentdate,
             referencedocument,
             referencedocumentitem,
             debitamountinbalancetranscrcy,
             creditamountinbalancetranscrcy,
             isreversal,
             isreversed
      FOR ALL ENTRIES IN @it_base
      WHERE purchasingdocument     = @it_base-purchaseorder
      AND   purchasingdocumentitem = @it_base-purchaseorderitem
      AND   ledger                 = '0L'
      AND   postingdate            IN @lr_postingdt
      AND   referencedocument      = @it_base-referencedocument
      AND transactiontypedetermination IS NOT INITIAL
      AND taxcode IS NOT INITIAL
      INTO TABLE @DATA(it_acc_re).

      IF it_acc_re IS NOT INITIAL.

        SELECT FROM i_operationalacctgdocitem
        FIELDS purchasingdocument,
               purchasingdocumentitem,
               accountingdocument,
               accountingdocumentitem,
               companycode,
               fiscalyear,
               glaccount,
               taxcode,
               postingdate,
               documentdate,
               transactiontypedetermination,
               accountingdocumenttype,
               financialaccounttype,
               supplier,
               taxabsltbaseamountincocodecrcy,
               absltamtinadditionalcurrency1,
               debitcreditcode
        FOR ALL ENTRIES IN @it_acc_re
        WHERE accountingdocument  = @it_acc_re-accountingdocument
          AND fiscalyear          = @it_acc_re-fiscalyear
          AND companycode         = @it_acc_re-companycode
          AND postingdate         IN @lr_postingdt
        INTO TABLE @DATA(it_acco_re).

        DATA : lv_debitamount TYPE i_accountingdocumentjournal-debitamountinbalancetranscrcy.

        SORT : it_acc_re  ASCENDING BY purchasingdocument purchasingdocumentitem referencedocument referencedocumentitem,
               it_base    ASCENDING BY purchaseorder purchaseorderitem,
               it_acco_re ASCENDING BY accountingdocument accountingdocumentitem fiscalyear companycode.

        LOOP AT it_base ASSIGNING FIELD-SYMBOL(<lfs_base>).
          CLEAR : lv_debitamount.
          IF <lfs_base>-reversedocument IS NOT INITIAL.
            <lfs_base>-reversalindicator = 'X'.
          ENDIF.
          READ TABLE it_acc_re ASSIGNING FIELD-SYMBOL(<lfs_acc_re>) WITH KEY purchasingdocument     = <lfs_base>-purchaseorder
                                                                             purchasingdocumentitem = <lfs_base>-purchaseorderitem
                                                                             referencedocument      = <lfs_base>-referencedocument
                                                                             referencedocumentitem  = <lfs_base>-referencedocumentitem.
          IF sy-subrc = 0.
            DATA(lv_acc_index) = sy-tabix.
            LOOP AT it_acc_re INTO DATA(ls_acc_re) FROM lv_acc_index
            WHERE purchasingdocument = <lfs_base>-purchaseorder     AND
            purchasingdocumentitem   = <lfs_base>-purchaseorderitem AND
            referencedocument        = <lfs_base>-referencedocument AND
            referencedocumentitem    = <lfs_base>-referencedocumentitem.
              lv_debitamount = lv_debitamount + ls_acc_re-debitamountinbalancetranscrcy + ls_acc_re-creditamountinbalancetranscrcy.
            ENDLOOP.
            lv_totamount = lv_debitamount.

            IF <lfs_acc_re>-isreversal = 'X'." AND lv_totamount GT 0.
              lv_totamount = lv_totamount * ( -1 ).
            ENDIF.

            IF lv_debitamount LT 0.
              lv_debitamount = lv_debitamount * ( -1 ).
            ENDIF.

            CLEAR : ls_acc_re.
            IF <lfs_acc_re>-isreversal IS NOT INITIAL OR <lfs_acc_re>-isreversed IS NOT INITIAL.  "Commented by rutikk 20.03.2026
              <lfs_base>-reversalindicator = 'X'.
            ENDIF.

            READ TABLE it_acco_re ASSIGNING FIELD-SYMBOL(<lfs_acco_re>) WITH KEY accountingdocument     = <lfs_acc_re>-accountingdocument
                                                                                 accountingdocumentitem = <lfs_acc_re>-accountingdocumentitem
                                                                                 fiscalyear             = <lfs_acc_re>-fiscalyear
                                                                                 companycode            = <lfs_acc_re>-companycode.
            IF sy-subrc = 0.
              MOVE-CORRESPONDING <lfs_acco_re> TO <lfs_base>.
**              <lfs_base>-supplierinvoiceitemamount   = <lfs_acc_re>-debitamountinbalancetranscrcy.
              READ TABLE it_acco_re INTO DATA(ls_acco_re) WITH KEY accountingdocument             = <lfs_acc_re>-accountingdocument
                                                                   fiscalyear                     = <lfs_acc_re>-fiscalyear
                                                                   companycode                    = <lfs_acc_re>-companycode
                                                                   taxabsltbaseamountincocodecrcy = lv_debitamount "<lfs_acc_re>-debitamountinbalancetranscrcy
                                                                   transactiontypedetermination   = 'JIC'.
              IF sy-subrc = 0.
                <lfs_base>-cgst    = ls_acco_re-absltamtinadditionalcurrency1.
                <lfs_base>-cgstgl  = ls_acco_re-glaccount.
                <lfs_base>-taxcode = ls_acco_re-taxcode.
                IF ls_acco_re-debitcreditcode = 'H'.
                  <lfs_base>-cgst  = <lfs_base>-cgst * ( -1 ).
                ENDIF.
              ENDIF.
              CLEAR : ls_acco_re.
              " SGST
              READ TABLE it_acco_re INTO DATA(ls_acco_re1) WITH KEY accountingdocument = <lfs_acc_re>-accountingdocument
                                                                     fiscalyear        = <lfs_acc_re>-fiscalyear
                                                                     companycode       = <lfs_acc_re>-companycode
                                                                     taxabsltbaseamountincocodecrcy = lv_debitamount "<lfs_acc_re>-debitamountinbalancetranscrcy
                                                                     transactiontypedetermination = 'JIS'.
              IF sy-subrc = 0.
                <lfs_base>-sgst    = ls_acco_re1-absltamtinadditionalcurrency1 .
                <lfs_base>-sgstgl  = ls_acco_re1-glaccount.
                <lfs_base>-taxcode = ls_acco_re1-taxcode.
                IF ls_acco_re1-debitcreditcode = 'H'.
                  <lfs_base>-sgst  = <lfs_base>-sgst * ( -1 ).
                ENDIF.
              ENDIF.

              " UGST
              READ TABLE it_acco_re INTO DATA(ls_acco_re2)  WITH KEY accountingdocument = <lfs_acc_re>-accountingdocument
                                                                     fiscalyear         = <lfs_acc_re>-fiscalyear
                                                                     companycode        = <lfs_acc_re>-companycode
                                                                     taxabsltbaseamountincocodecrcy = lv_debitamount "<lfs_acc_re>-debitamountinbalancetranscrcy
                                                                     transactiontypedetermination = 'JIU'.
              IF sy-subrc = 0.
                <lfs_base>-ugst    = ls_acco_re2-absltamtinadditionalcurrency1.
                <lfs_base>-ugstgl  = ls_acco_re2-glaccount.
                <lfs_base>-taxcode = ls_acco_re2-taxcode.
                IF ls_acco_re2-debitcreditcode = 'H'.
                  <lfs_base>-ugst = <lfs_base>-ugst * ( -1 ).
                ENDIF.
              ENDIF.
              " IGST
              READ TABLE it_acco_re INTO DATA(ls_acco_re3) WITH KEY accountingdocument     = <lfs_acc_re>-accountingdocument
                                                                    fiscalyear             = <lfs_acc_re>-fiscalyear
                                                                    companycode            = <lfs_acc_re>-companycode
                                                                    taxabsltbaseamountincocodecrcy = lv_debitamount "<lfs_acc_re>-debitamountinbalancetranscrcy
                                                                    transactiontypedetermination = 'JII'.
              IF sy-subrc = 0.
                <lfs_base>-igst    = ls_acco_re3-absltamtinadditionalcurrency1.
                <lfs_base>-igstgl  = ls_acco_re3-glaccount.
                <lfs_base>-taxcode = ls_acco_re3-taxcode.
                IF ls_acco_re3-debitcreditcode = 'H'.
                  <lfs_base>-igst  = <lfs_base>-igst * ( -1 ).
                ENDIF.
              ENDIF.
              CLEAR : ls_acco_re.
              READ TABLE it_acco_re INTO ls_acco_re WITH KEY accountingdocument = <lfs_acc_re>-accountingdocument
                                                             accountingdocumentitem  = <lfs_acc_re>-accountingdocumentitem
                                                             fiscalyear         = <lfs_acc_re>-fiscalyear
                                                             companycode        = <lfs_acc_re>-companycode
                                                             financialaccounttype  = 'K '.
              IF sy-subrc = 0.
                <lfs_base>-glaccount = ls_acco_re-glaccount.
              ENDIF.

              <lfs_base>-amountintransactioncurrency = lv_totamount +    "<lfs_acc_re>-debitamountinbalancetranscrcy +
                                                       <lfs_base>-cgst +
                                                       <lfs_base>-sgst +
                                                       <lfs_base>-igst +
                                                       <lfs_base>-ugst.

              IF <lfs_acc_re>-isreversal = 'X'." AND lv_totamount GT 0.
                <lfs_base>-amountintransactioncurrency = <lfs_base>-amountintransactioncurrency * ( -1 ).
              ENDIF.

              <lfs_base>-supplierinvoiceitemamount =  lv_totamount.

            ENDIF.
*-----------------------------------------------------------------------
* For Freight & Insurance
*-----------------------------------------------------------------------
            CLEAR : ls_acco_re, ls_acco_re1, ls_acco_re2, ls_acco_re3, lv_debitamount, lv_totamount.
            READ TABLE it_acco_re INTO ls_acco_re WITH KEY accountingdocument           = <lfs_acc_re>-accountingdocument
                                                           fiscalyear                   = <lfs_acc_re>-fiscalyear
                                                           companycode                  = <lfs_acc_re>-companycode
                                                           supplier                     = ' '
                                                           transactiontypedetermination = 'KBS'.
            IF  ls_acco_re IS NOT INITIAL.
              APPEND INITIAL LINE TO it_base_temp ASSIGNING FIELD-SYMBOL(<lfs_base_temp>).
              MOVE-CORRESPONDING <lfs_base> TO <lfs_base_temp>.
              MOVE-CORRESPONDING <lfs_acco_re> TO <lfs_base_temp>.
              <lfs_base_temp>-supplierinvoiceitem = <lfs_base_temp>-supplierinvoiceitem + 1.

              CLEAR : <lfs_base_temp>-cgst, <lfs_base_temp>-cgstgl, <lfs_base_temp>-taxcode,
                      <lfs_base_temp>-sgst, <lfs_base_temp>-sgstgl, <lfs_base_temp>-taxcode,
                      <lfs_base_temp>-igst, <lfs_base_temp>-igstgl, <lfs_base_temp>-taxcode,
                      <lfs_base_temp>-ugst, <lfs_base_temp>-ugstgl, <lfs_base_temp>-taxcode,
                      <lfs_base_temp>-supplierinvoiceitemamount, <lfs_base_temp>-glaccount,
                      <lfs_base_temp>-amountintransactioncurrency, lv_debitamount, lv_totamount,
                      <lfs_base_temp>-totalgoodsmvtamtincccrcy, <lfs_base_temp>-quantityinbaseunit.

              lv_totamount   = ls_acco_re-absltamtinadditionalcurrency1.
              lv_debitamount = lv_totamount.
              IF ls_acco_re-debitcreditcode = 'H'.
                lv_debitamount = lv_debitamount * ( -1 ).
              ENDIF.
              READ TABLE it_acco_re INTO ls_acco_re WITH KEY accountingdocument             = <lfs_acc_re>-accountingdocument
                                                             fiscalyear                     = <lfs_acc_re>-fiscalyear
                                                             companycode                    = <lfs_acc_re>-companycode
                                                             taxabsltbaseamountincocodecrcy = lv_totamount
                                                             transactiontypedetermination   = 'JIC'.
              IF sy-subrc = 0.
                <lfs_base_temp>-cgst    = ls_acco_re-absltamtinadditionalcurrency1.
                <lfs_base_temp>-cgstgl  = ls_acco_re-glaccount.
                <lfs_base_temp>-taxcode = ls_acco_re-taxcode.
                IF ls_acco_re-debitcreditcode = 'H'.
                  <lfs_base_temp>-cgst  = <lfs_base_temp>-cgst * ( -1 ).
                ENDIF.
              ENDIF.

              " SGST
              READ TABLE it_acco_re INTO ls_acco_re1 WITH KEY accountingdocument             = <lfs_acc_re>-accountingdocument
                                                              fiscalyear                     = <lfs_acc_re>-fiscalyear
                                                              companycode                    = <lfs_acc_re>-companycode
                                                              taxabsltbaseamountincocodecrcy = lv_totamount
                                                              transactiontypedetermination   = 'JIS'.
              IF sy-subrc = 0.
                <lfs_base_temp>-sgst    = ls_acco_re1-absltamtinadditionalcurrency1 .
                <lfs_base_temp>-sgstgl  = ls_acco_re1-glaccount.
                <lfs_base_temp>-taxcode = ls_acco_re1-taxcode.
                IF ls_acco_re1-debitcreditcode = 'H'.
                  <lfs_base_temp>-sgst  = <lfs_base_temp>-sgst * ( -1 ).
                ENDIF.
              ENDIF.

              " UGST
              READ TABLE it_acco_re INTO ls_acco_re2  WITH KEY accountingdocument             = <lfs_acc_re>-accountingdocument
                                                               fiscalyear                     = <lfs_acc_re>-fiscalyear
                                                               companycode                    = <lfs_acc_re>-companycode
                                                               taxabsltbaseamountincocodecrcy = lv_totamount
                                                               transactiontypedetermination   = 'JIU'.
              IF sy-subrc = 0.
                <lfs_base_temp>-ugst    = ls_acco_re2-absltamtinadditionalcurrency1.
                <lfs_base_temp>-ugstgl  = ls_acco_re2-glaccount.
                <lfs_base_temp>-taxcode = ls_acco_re2-taxcode.
                IF ls_acco_re2-debitcreditcode = 'H'.
                  <lfs_base_temp>-ugst = <lfs_base_temp>-ugst * ( -1 ).
                ENDIF.
              ENDIF.
              " IGST
              READ TABLE it_acco_re INTO ls_acco_re3 WITH KEY accountingdocument             = <lfs_acc_re>-accountingdocument
                                                              fiscalyear                     = <lfs_acc_re>-fiscalyear
                                                              companycode                    = <lfs_acc_re>-companycode
                                                              taxabsltbaseamountincocodecrcy = lv_totamount
                                                              transactiontypedetermination   = 'JII'.
              IF sy-subrc = 0.
                <lfs_base_temp>-igst    = ls_acco_re3-absltamtinadditionalcurrency1.
                <lfs_base_temp>-igstgl  = ls_acco_re3-glaccount.
                <lfs_base_temp>-taxcode = ls_acco_re3-taxcode.
                IF ls_acco_re3-debitcreditcode = 'H'.
                  <lfs_base_temp>-igst  = <lfs_base_temp>-igst * ( -1 ).
                ENDIF.
              ENDIF.
              CLEAR : ls_acco_re.
              READ TABLE it_acco_re INTO ls_acco_re WITH KEY accountingdocument      = <lfs_acc_re>-accountingdocument
                                                             fiscalyear              = <lfs_acc_re>-fiscalyear
                                                             companycode             = <lfs_acc_re>-companycode
                                                             financialaccounttype    = 'K '.
              IF sy-subrc = 0.
                <lfs_base_temp>-glaccount = ls_acco_re-glaccount.
              ENDIF.

**              IF <lfs_acc_re>-isreversal = 'X'.
**                lv_debitamount = lv_debitamount * ( -1 ).
**              ENDIF.

              <lfs_base_temp>-amountintransactioncurrency = lv_debitamount + <lfs_base_temp>-cgst + <lfs_base_temp>-sgst + <lfs_base_temp>-igst + <lfs_base_temp>-ugst.
              <lfs_base_temp>-supplierinvoiceitemamount   = lv_debitamount. "lv_totamount.

            ENDIF.
          ELSE.
            CONTINUE.
          ENDIF.
          CLEAR : ls_acco_re, ls_acco_re1, ls_acco_re2, ls_acco_re3, lv_debitamount, lv_totamount.
        ENDLOOP.

*-----------------------------------------------------------------------
* For Freight & Insurance
*-----------------------------------------------------------------------
        APPEND LINES OF it_base_temp TO it_base.

      ENDIF.

      SELECT FROM i_suplrinvcitempurordrefapi01 AS b
      FIELDS
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
            b~purchaseorderquantityunit
       FOR ALL ENTRIES IN @it_base
       WHERE supplierinvoice = @it_base-supplierinvoice
       AND   fiscalyear      = @it_base-fiscalyear
       INTO TABLE @DATA(it_supplierinvitem).

    ENDIF.

*-----------------------------------------------------------------------
* STO Process
*-----------------------------------------------------------------------

    SELECT FROM i_purchaseorderapi01 AS a
    LEFT OUTER JOIN i_supplier AS b ON b~supplier = a~supplier
       FIELDS a~purchaseordertype,
              a~supplier,
              b~suppliername,
              a~purchaseorder,
              a~purchaseorderdate
              WHERE purchaseorder IN @lr_purchaseorder
              AND   ( purchaseordertype = 'ZSUB' OR purchaseordertype = 'ZST' )
              AND a~companycode IN @lr_cc
              INTO TABLE @DATA(it_po_type).


    IF it_po_type IS NOT INITIAL.
      DATA(it_sto_po) = it_po_type.
      DELETE it_sto_po WHERE purchaseordertype <> 'ZUB'
                         AND purchaseordertype <> 'ZST'.

      IF it_sto_po IS NOT INITIAL.

        SELECT FROM i_materialdocumentitem_2 AS a1
        LEFT OUTER JOIN c_purchaseorderhistorydex AS b ON  b~purchaseorder = a1~purchaseorder
                                                       AND b~purchaseorderitem = a1~purchaseorderitem
        FIELDS
              a1~materialdocumentyear,
              a1~materialdocument,
              a1~materialdocumentitem,
              a1~goodsmovementtype,
              a1~quantityinbaseunit,
              a1~entryunit,
              a1~postingdate AS postingdate_grn ,
              a1~totalgoodsmvtamtincccrcy,
              a1~companycodecurrency,
              a1~deliverydocument,
              a1~deliverydocumentitem,
              b~purchasinghistorydocument,
              b~purchaseorder,
              b~purchaseorderitem
           FOR ALL ENTRIES IN @it_sto_po
           WHERE a1~purchaseorder = @it_sto_po-purchaseorder
           AND purchasinghistorycategory = 'L'
           AND a1~goodsmovementtype IN ( '101', '105' ) AND a1~purchaseorder NE '' AND a1~goodsmovementiscancelled = ''
           INTO TABLE @DATA(it_pur_hist).

        IF it_pur_hist IS NOT INITIAL.

          SELECT FROM i_billingdocumentitem
          FIELDS billingdocument,
                 billingdocumentdate,
                 referencesddocument,
                 referencesddocumentitem,
                 companycode,
                 payerparty,
                 plant,
                 billingquantity,
                 billingquantityunit,
                 billingdocumentitem,
                 salesdocument,
                 salesdocumentitem,
                 netamount,
                 taxamount

          FOR ALL ENTRIES IN @it_pur_hist
          WHERE referencesddocument = @it_pur_hist-purchasinghistorydocument
          INTO TABLE @DATA(it_bill_doc_hist).

          IF it_bill_doc_hist IS NOT INITIAL.

            IF lr_supplierinvoice IS NOT INITIAL.
              DELETE it_bill_doc_hist WHERE billingdocument NOT IN lr_supplierinvoice.
            ENDIF.

            SELECT FROM i_accountingdocumentjournal
            FIELDS
             purchasingdocument,
             purchasingdocumentitem,
             accountingdocument,
             accountingdocumentitem,
             companycode,
             fiscalyear,
             glaccount,
             taxcode,
             ledger,
             documentreferenceid,
             transactiontypedetermination,
             supplier,
             financialaccounttype,
             postingdate,
             documentdate,
             referencedocument,
             debitamountinbalancetranscrcy,
             isreversal,
             isreversed,
             debitcreditcode
            FOR ALL ENTRIES IN @it_bill_doc_hist
            WHERE purchasingdocument  = @it_bill_doc_hist-salesdocument
            AND transactiontypedetermination IS NOT INITIAL
            AND taxcode IS NOT INITIAL
            AND ledger = '0L'
            INTO TABLE @DATA(it_acc).

            SORT it_acc BY documentreferenceid.

            IF it_acc IS NOT INITIAL.

              SELECT FROM i_accountingdocumentjournal
              FIELDS purchasingdocument,
                     purchasingdocumentitem,
                     accountingdocument,
                     accountingdocumentitem,
                     companycode,
                     fiscalyear,
                     glaccount,
                     taxcode,
                     ledger,
                     postingdate,
                     documentdate,
                     documentreferenceid,
                     transactiontypedetermination,
                     accountingdocumenttype,
                     creditamountincocodecrcy,
                     debitamountinbalancetranscrcy,
                     financialaccounttype,
                     supplier,
                     accountassignmenttype,
                     debitcreditcode
              FOR ALL ENTRIES IN @it_acc
              WHERE documentreferenceid = @it_acc-documentreferenceid
                AND fiscalyear          = @it_acc-fiscalyear
                AND companycode         = @it_acc-companycode
                AND ledger = '0L'
                AND accountingdocumenttype = 'RV'
              INTO TABLE @DATA(it_acco).

              IF it_acco IS NOT INITIAL.

                SELECT FROM i_accountingdocumentjournal
                FIELDS purchasingdocument,
                       purchasingdocumentitem,
                       accountingdocument,
                       accountingdocumentitem,
                       companycode,
                       fiscalyear,
                       glaccount,
                       taxcode,
                       ledger,
                       postingdate,
                       documentdate,
                       documentreferenceid,
                       transactiontypedetermination,
                       accountingdocumenttype,
                       creditamountincocodecrcy,
                       debitamountinbalancetranscrcy,
                       financialaccounttype,
                       supplier,
                       accountassignmenttype,
                       debitcreditcode
                   FOR ALL ENTRIES IN @it_acc
                   WHERE documentreferenceid = @it_acc-documentreferenceid
                   AND fiscalyear            = @it_acc-fiscalyear
                   AND companycode           = @it_acc-companycode
                   AND ledger = '0L'
                   AND accountingdocumenttype = 'RE'
                   AND postingdate            IN @lr_postingdt
                   INTO TABLE @DATA(it_inbound).

                IF  it_inbound IS NOT INITIAL.

                  SELECT FROM i_operationalacctgdocitem
                     FIELDS purchasingdocument,
                            purchasingdocumentitem,
                            accountingdocument,
                            accountingdocumentitem,
                            companycode,
                            fiscalyear,
                            glaccount,
                            taxcode,
                            postingdate,
                            documentdate,
                            transactiontypedetermination,
                            accountingdocumenttype,
                            financialaccounttype,
                            supplier,
                            taxabsltbaseamountincocodecrcy,
                            absltamtinadditionalcurrency1
                     FOR ALL ENTRIES IN @it_inbound
                     WHERE accountingdocument  = @it_inbound-accountingdocument
                       AND fiscalyear          = @it_inbound-fiscalyear
                       AND companycode         = @it_inbound-companycode
                       AND postingdate         IN @lr_postingdt
                     INTO TABLE @DATA(it_acco_rv).

                ENDIF.

                SELECT FROM i_operationalacctgdocitem
                FIELDS accountingdocument,
                       companycode,
                       fiscalyear,
                       businessplace
                FOR ALL ENTRIES IN @it_acco
                WHERE fiscalyear  = @it_acco-fiscalyear
                AND   companycode = @it_acco-companycode
                AND   accountingdocument = @it_acco-accountingdocument
                INTO TABLE @DATA(lt_operationalacctgdocitem).

                SELECT FROM zzce_pur_tax_agg
                FIELDS accountingdocument,
                       amountintransactioncurrency,
                       cgst,
                       glaccount,
                       igst,
                       rmcgst,
                       rmigst,
                       rmsgst,
                       rmugst,
                       sgst,
                       transactioncurrency,
                       ugst,
                       fiscalyear
                FOR ALL ENTRIES IN @it_acco
                WHERE accountingdocument = @it_acco-accountingdocument
                AND fiscalyear           = @it_acco-fiscalyear
                INTO TABLE @DATA(it_sto_tax).

                SORT it_sto_tax BY accountingdocument.

                SELECT FROM zce_pur_reg3
                FIELDS accountingdocument,
                       accountingdocumentitem,
                       in_hsnorsaccode,
                       transactiontypedetermination,
                       fiscalyear
                FOR ALL ENTRIES IN @it_acco
                WHERE accountingdocument = @it_acco-accountingdocument
                AND   companycode        = @it_acco-companycode
                INTO TABLE @DATA(it_sto_hsn).

                SORT it_sto_hsn BY accountingdocument.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.

        DATA : lv_cgsttax            TYPE i_accountingdocumentjournal-creditamountincocodecrcy,
               lv_sgsttax            TYPE i_accountingdocumentjournal-creditamountincocodecrcy,
               lv_igsttax            TYPE i_accountingdocumentjournal-creditamountincocodecrcy,
               lv_ugsttax            TYPE i_accountingdocumentjournal-creditamountincocodecrcy,
               lv_net                TYPE i_accountingdocumentjournal-creditamountincocodecrcy,
               lv_cgstgl             TYPE i_accountingdocumentjournal-glaccount,
               lv_sgstgl             TYPE i_accountingdocumentjournal-glaccount,
               lv_igstgl             TYPE i_accountingdocumentjournal-glaccount,
               lv_ugstgl             TYPE i_accountingdocumentjournal-glaccount,
               lv_taxcode            TYPE i_accountingdocumentjournal-taxcode,
               lv_accountingdocument TYPE i_accountingdocumentjournal-accountingdocument,
               lv_roundoff           TYPE i_accountingdocumentjournal-creditamountinbalancetranscrcy,
               lv_txcd               TYPE i_accountingdocumentjournal-taxcode.

        SORT : it_pur_hist      ASCENDING BY purchaseorder purchaseorderitem,
               it_bill_doc_hist ASCENDING BY referencesddocument referencesddocumentitem,
               it_acc           ASCENDING BY documentreferenceid,
               it_acco          ASCENDING BY documentreferenceid purchasingdocument purchasingdocumentitem,
               it_inbound       ASCENDING BY documentreferenceid,
               it_sto_po        ASCENDING BY purchaseorder.

        LOOP AT it_pur_hist ASSIGNING FIELD-SYMBOL(<lfs_pur_hist>).
          IF <lfs_pur_hist>-purchaseorder             = '4800000499' AND
             <lfs_pur_hist>-materialdocument          = '6225000418' AND
             <lfs_pur_hist>-purchasinghistorydocument = '0080001444'.
            CONTINUE.
          ENDIF.
          READ TABLE it_sto_po ASSIGNING FIELD-SYMBOL(<lfs_sto_po>) WITH KEY
          purchaseorder = <lfs_pur_hist>-purchaseorder.
          IF sy-subrc = 0.
            LOOP AT it_bill_doc_hist ASSIGNING FIELD-SYMBOL(<lfs_bill_doc_hist>)
             WHERE referencesddocument = <lfs_pur_hist>-purchasinghistorydocument AND
             referencesddocumentitem = <lfs_pur_hist>-deliverydocumentitem.
              READ TABLE it_acc ASSIGNING FIELD-SYMBOL(<lfs_acc>) WITH KEY documentreferenceid    = <lfs_bill_doc_hist>-billingdocument
                                                                           purchasingdocument     = <lfs_pur_hist>-purchaseorder
                                                                           purchasingdocumentitem = <lfs_pur_hist>-purchaseorderitem.
              IF sy-subrc = 0.
                READ TABLE it_acco INTO DATA(ls_acco) WITH KEY
                                documentreferenceid    = <lfs_acc>-documentreferenceid
                                purchasingdocument     = <lfs_acc>-purchasingdocument
                                purchasingdocumentitem = <lfs_acc>-purchasingdocumentitem.
                IF sy-subrc = 0.
                  READ TABLE it_inbound INTO DATA(ls_inbound) WITH KEY documentreferenceid = <lfs_acc>-documentreferenceid.
                  IF sy-subrc = 0.
                    DATA(lv_ib_index) = sy-tabix.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                  LOOP AT it_inbound ASSIGNING FIELD-SYMBOL(<lfs_acco>) FROM lv_ib_index  WHERE documentreferenceid = <lfs_acc>-documentreferenceid.
                    DATA(lv_postingdt)  = <lfs_acco>-postingdate.
                    DATA(lv_documentdt) = <lfs_acco>-documentdate.
                    IF  <lfs_acco>-accountassignmenttype = 'EO'.
**                      lv_net = lv_net + <lfs_acco>-creditamountincocodecrcy.
                      IF  <lfs_acco>-debitcreditcode = 'H'.
                        DATA(lv_salesgl)   = <lfs_acco>-glaccount.
                      ENDIF.
                    ELSEIF <lfs_acco>-accountassignmenttype = ' '.
                      IF <lfs_acco>-taxcode IS NOT INITIAL.
                        lv_accountingdocument = <lfs_acco>-accountingdocument.
                        IF  <lfs_acco>-taxcode = 'C0' OR
                        <lfs_acco>-taxcode = 'CB' OR
                        <lfs_acco>-taxcode = 'C7' OR
                        <lfs_acco>-taxcode = 'RC' OR
                        <lfs_acco>-taxcode = 'CC' OR
                        <lfs_acco>-taxcode = 'C4' OR
                        <lfs_acco>-taxcode = 'RD' OR
                        <lfs_acco>-taxcode = 'C8' OR
                        <lfs_acco>-taxcode = 'CD' OR
                        <lfs_acco>-taxcode = 'C1' OR
                        <lfs_acco>-taxcode = 'RA' OR
                        <lfs_acco>-taxcode = 'C5' OR
                        <lfs_acco>-taxcode = 'A2' OR
                        <lfs_acco>-taxcode = 'CA'.
                          IF <lfs_acco>-glaccount     = '0000148000'.
                            lv_igstgl                 = <lfs_acco>-glaccount.
                            lv_taxcode                = <lfs_acco>-taxcode.
                          ELSEIF <lfs_acco>-glaccount = '0000148001'.
                            lv_ugstgl                 = <lfs_acco>-glaccount.
                            lv_taxcode                = <lfs_acco>-taxcode.
                          ELSEIF <lfs_acco>-glaccount = '0000148002'.
                            lv_sgstgl                 = <lfs_acco>-glaccount.
                            lv_taxcode                = <lfs_acco>-taxcode.
                          ELSEIF <lfs_acco>-glaccount = '0000148003'.
                            lv_cgstgl                 = <lfs_acco>-glaccount.
                            lv_taxcode                = <lfs_acco>-taxcode.
                          ENDIF.
                        ENDIF.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.
                ENDIF.

                LOOP AT it_acco ASSIGNING <lfs_acco>                 WHERE
                documentreferenceid    = <lfs_acc>-documentreferenceid AND
                purchasingdocument     = <lfs_acc>-purchasingdocument  AND
                purchasingdocumentitem = <lfs_acc>-purchasingdocumentitem.


                  READ TABLE it_bill_doc_hist ASSIGNING FIELD-SYMBOL(<lfs_bill_amt>) WITH KEY
                                                referencesddocument     = <lfs_pur_hist>-purchasinghistorydocument
                                                referencesddocumentitem = <lfs_pur_hist>-deliverydocumentitem.
                  IF sy-subrc IS INITIAL.
                  ENDIF.

                  IF  <lfs_acco>-accountassignmenttype = 'EO'.
                    IF  <lfs_acco>-transactiontypedetermination IS INITIAL AND <lfs_acco>-taxcode IS INITIAL.
                      lv_roundoff = lv_roundoff + <lfs_acco>-creditamountincocodecrcy.
                    ELSE.
                      lv_net = lv_net + <lfs_acco>-creditamountincocodecrcy.
                      IF  <lfs_acco>-debitcreditcode = 'H'.
                        lv_salesgl  = <lfs_acco>-glaccount.
                      ENDIF.
                    ENDIF.
                  ELSEIF <lfs_acco>-accountassignmenttype = 'KS'.
                    lv_roundoff = lv_roundoff + <lfs_acco>-creditamountincocodecrcy." + <lfs_acco>-debitamountinbalancetranscrcy.
                  ELSEIF <lfs_acco>-accountassignmenttype = ' '.
                    IF <lfs_acco>-transactiontypedetermination = 'JOC'.
                      lv_cgsttax = lv_cgsttax + <lfs_acco>-creditamountincocodecrcy." + <lfs_acco>-debitamountinbalancetranscrcy.
**                      lv_cgstgl  = <lfs_acco>-glaccount.
**                      lv_taxcode = <lfs_acco>-taxcode.
                    ELSEIF <lfs_acco>-transactiontypedetermination = 'JOS'.
                      lv_sgsttax = lv_sgsttax + <lfs_acco>-creditamountincocodecrcy." + <lfs_acco>-debitamountinbalancetranscrcy.
**                      lv_sgstgl  = <lfs_acco>-glaccount.
**                      lv_taxcode = <lfs_acco>-taxcode.
                    ELSEIF <lfs_acco>-transactiontypedetermination = 'JOI'.
                      lv_igsttax = lv_igsttax + <lfs_acco>-creditamountincocodecrcy." + <lfs_acco>-debitamountinbalancetranscrcy.
**                      lv_igstgl  = <lfs_acco>-glaccount.
**                      lv_taxcode = <lfs_acco>-taxcode.

                      lv_igsttax = <lfs_bill_amt>-taxamount.

                    ELSEIF <lfs_acco>-transactiontypedetermination = 'JOU'.
                      lv_ugsttax = lv_ugsttax + <lfs_acco>-creditamountincocodecrcy." + <lfs_acco>-debitamountinbalancetranscrcy.
**                      lv_ugstgl  = <lfs_acco>-glaccount.
**                      lv_taxcode = <lfs_acco>-taxcode.
                    ENDIF.
                  ENDIF.
                ENDLOOP.

                IF  lv_cgsttax LT 0.
                  lv_cgsttax = lv_cgsttax * (  -1 ).
                ENDIF.
                IF  lv_sgsttax LT 0.
                  lv_sgsttax = lv_sgsttax * (  -1 ).
                ENDIF.
                IF  lv_igsttax LT 0.
                  lv_igsttax = lv_igsttax * (  -1 ).
                ENDIF.
                IF  lv_ugsttax LT 0.
                  lv_ugsttax = lv_ugsttax * (  -1 ).
                ENDIF.
                IF  lv_net LT 0.
                  lv_net = lv_net * (  -1 ).
                ENDIF.
                IF  lv_roundoff LT 0.
                  lv_roundoff = lv_roundoff * (  -1 ).
                ENDIF.

                IF <lfs_acco> IS ASSIGNED.
                  APPEND INITIAL LINE TO it_base ASSIGNING FIELD-SYMBOL(<lfs_it_base>).
                  MOVE-CORRESPONDING <lfs_acco>     TO <lfs_it_base>.
                  MOVE-CORRESPONDING <lfs_pur_hist> TO <lfs_it_base>.
                  IF <lfs_acc>-isreversal IS NOT INITIAL OR <lfs_acc>-isreversed IS NOT INITIAL.
                    <lfs_it_base>-reversalindicator = 'X'.
                  ENDIF.
                  <lfs_it_base>-accountingdocument          = lv_accountingdocument.
                  <lfs_it_base>-documentdate                = lv_documentdt.
                  <lfs_it_base>-postingdate                 = lv_postingdt.
                  <lfs_it_base>-cgstgl                      = lv_cgstgl.
                  <lfs_it_base>-sgstgl                      = lv_sgstgl.
                  <lfs_it_base>-igstgl                      = lv_igstgl.
                  <lfs_it_base>-ugstgl                      = lv_ugstgl.
                  <lfs_it_base>-taxcode                     = lv_taxcode.
                  <lfs_it_base>-purchaseorder               = <lfs_sto_po>-purchaseorder.
                  <lfs_it_base>-purchaseorderitem           = <lfs_pur_hist>-purchaseorderitem.
                  <lfs_it_base>-supplierinvoice             = <lfs_bill_doc_hist>-billingdocument.
                  <lfs_it_base>-supplierinvoiceitem         = <lfs_bill_doc_hist>-billingdocumentitem.
                  <lfs_it_base>-companycode                 = <lfs_acc>-companycode.
                  <lfs_it_base>-invoicingparty              = <lfs_bill_doc_hist>-payerparty.
                  <lfs_it_base>-plant                       = <lfs_bill_doc_hist>-plant.
                  <lfs_it_base>-roundoff                    = lv_roundoff.
                  <lfs_it_base>-fiscalyear                  = <lfs_acco>-fiscalyear.
                  <lfs_it_base>-glaccount                   = lv_salesgl.
                  <lfs_it_base>-accountingdocumentitem      = <lfs_acco>-accountingdocumentitem.
                  <lfs_it_base>-invoicegrossamount          = <lfs_acco>-creditamountincocodecrcy.
                  <lfs_it_base>-igst                        = lv_igsttax.
                  <lfs_it_base>-cgst                        = lv_cgsttax.
                  <lfs_it_base>-sgst                        = lv_sgsttax.
                  <lfs_it_base>-ugst                        = lv_ugsttax.
**                  <lfs_it_base>-supplierinvoiceitemamount   = lv_net.
**                  <lfs_it_base>-invoicegrossamount          = ( lv_cgsttax + lv_sgsttax + lv_igsttax +  lv_net ) - lv_roundoff.
                  <lfs_it_base>-supplierinvoiceitemamount   = <lfs_bill_amt>-netamount.
                  <lfs_it_base>-invoicegrossamount          = ( <lfs_bill_amt>-netamount + <lfs_bill_amt>-taxamount ).

                  <lfs_it_base>-documentcurrency            = 'INR'.
                  <lfs_it_base>-exchangerate                = '1.00000'.
                  <lfs_it_base>-quantityinpurchaseorderunit = <lfs_bill_doc_hist>-billingquantity.
                  <lfs_it_base>-purchaseorderquantityunit   = <lfs_bill_doc_hist>-billingquantityunit.
                  READ TABLE it_sto_tax ASSIGNING FIELD-SYMBOL(<lfs_sto_tax>) WITH KEY accountingdocument = <lfs_acc>-accountingdocument.
                  IF sy-subrc = 0.
                    <lfs_it_base>-rmcgst                      = <lfs_sto_tax>-rmcgst.
                    <lfs_it_base>-rmigst                      = <lfs_sto_tax>-rmigst.
                    <lfs_it_base>-rmsgst                      = <lfs_sto_tax>-rmsgst.
                    <lfs_it_base>-rmugst                      = <lfs_sto_tax>-rmugst.
**                    <lfs_it_base>-amountintransactioncurrency = <lfs_sto_tax>-amountintransactioncurrency.
****                    <lfs_it_base>-supplierinvoiceitemamount   = <lfs_sto_tax>-amountintransactioncurrency.
                    <lfs_it_base>-transactioncurrency         = <lfs_sto_tax>-transactioncurrency.
                  ENDIF.
                  READ TABLE it_sto_hsn ASSIGNING FIELD-SYMBOL(<lfs_sto_hsn>) WITH KEY accountingdocument = <lfs_acc>-accountingdocument BINARY SEARCH.
                  IF sy-subrc = 0.
                    <lfs_it_base>-in_hsnorsaccode              = <lfs_sto_hsn>-in_hsnorsaccode.
                    <lfs_it_base>-transactiontypedetermination = <lfs_sto_hsn>-transactiontypedetermination.
                  ENDIF.
                  READ TABLE lt_operationalacctgdocitem ASSIGNING FIELD-SYMBOL(<lfs_operationalacctgdocitem>) WITH KEY companycode         = <lfs_acc>-companycode
                                                                                                                        accountingdocument = <lfs_acc>-accountingdocument
                                                                                                                         fiscalyear        = <lfs_acc>-fiscalyear.
                  IF sy-subrc = 0.
                    <lfs_it_base>-businessplace = <lfs_operationalacctgdocitem>-businessplace.
                  ENDIF.
                  READ TABLE it_acco ASSIGNING FIELD-SYMBOL(<lfs_acco_k>) WITH KEY documentreferenceid  = <lfs_acc>-documentreferenceid
                                                                                   financialaccounttype = 'K'.
                  IF sy-subrc = 0.
                    <lfs_it_base>-invoicingparty = <lfs_acco_k>-supplier.
                  ENDIF.
                  <lfs_it_base>-amountintransactioncurrency = lv_net + lv_cgsttax + lv_sgsttax + lv_igsttax + lv_ugsttax.
                ENDIF.
              ENDIF.
**            ENDIF.
            ENDLOOP.
          ENDIF.
          CLEAR : lv_net, lv_cgsttax, lv_sgsttax, lv_sgsttax, lv_igsttax, lv_ugsttax, lv_roundoff, lv_documentdt,
                  lv_cgstgl, lv_sgstgl, lv_igstgl, lv_ugstgl, lv_taxcode, lv_accountingdocument, lv_postingdt,
                  lv_ib_index, lv_txcd.
        ENDLOOP.

      ENDIF.
    ENDIF.

    DELETE it_base WHERE purchaseorder IS INITIAL.
*-----------------------------------------------------------------------
* End of STO Process
*-----------------------------------------------------------------------

    IF lr_accountingdocument IS NOT INITIAL.
      DELETE it_base WHERE accountingdocument NOT IN lr_accountingdocument[].
    ENDIF.

    IF  lr_postingdt IS NOT INITIAL.
      DELETE it_base WHERE postingdate NOT IN lr_postingdt[].
    ENDIF.

    IF  lr_fyear IS NOT INITIAL.
      DELETE it_base WHERE fiscalyear NOT IN lr_fyear[].
    ENDIF.

    IF it_base IS NOT INITIAL.

      SELECT FROM i_purchaseorderhistoryapi01
      FIELDS purchaseorder,
      purchaseorderitem,
      referencedocument,
      referencedocumentitem,
      purchasinghistorydocument,
      purchasinghistorydocumentitem,
      griracctclrgamtincocodecrcy AS invoiceamtincocodecrcy
      FOR ALL ENTRIES IN @it_base
      WHERE purchaseorder       = @it_base-purchaseorder AND
      purchaseorderitem         = @it_base-purchaseorderitem AND
      purchasinghistorydocument = @it_base-supplierinvoice
      INTO TABLE @DATA(it_purchasehistory).


      SELECT bpaddrstreetname,
      bpsupplierfullname,
      cityname,
      supplier,
      businesspartnerpannumber
      FROM i_supplier
      FOR ALL ENTRIES IN @it_base
      WHERE supplier = @it_base-invoicingparty
      INTO TABLE @DATA(it_supplier).

      IF it_supplier IS NOT INITIAL.

        SELECT
         bpidentificationnumber,
         businesspartner
        FROM i_bupaidentification
        FOR ALL ENTRIES IN @it_supplier
                   WHERE businesspartner = @it_supplier-supplier
                  AND bpidentificationtype = 'MSME V'
                  INTO TABLE @DATA(it_bp_iden).
      ENDIF.

      SELECT
           a~incotermsclassification,
           a~netpriceamount,
           a~producttype,
           a~purchaseorderitem,
           a~purchaseorderitemtext,
           a~purchaseorder,
           a~material,
           b~productname
           FROM i_purchaseorderitemapi01 AS a
           INNER JOIN i_producttext AS b ON a~material = b~product AND b~language = 'E'
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

      SELECT FROM i_cnsldtnglaccountvh
      FIELDS glaccount,
      glaccountname
      FOR ALL ENTRIES IN @it_base
      WHERE glaccount = @it_base-glaccount
      INTO TABLE @DATA(it_gl).

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

      SELECT accountingdocumentheadertext,
          accountingdocumenttype,
          isreversed,
          accountingdocument,
          fiscalyear,
          isreversal
    FROM i_journalentry
    FOR ALL ENTRIES IN @it_base
            WHERE accountingdocument = @it_base-accountingdocument
            AND fiscalyear = @it_base-fiscalyear
            INTO TABLE @DATA(it_journal).

      SELECT debitcreditcode,
           postingkey,
           accountingdocument,
           companycode,
           fiscalyear,
           postingdate,
           documentdate,
           accountingdocumentitem
           FROM  i_accountingdocumentjournal
           FOR ALL ENTRIES IN @it_base
           WHERE accountingdocument = @it_base-accountingdocument
           AND companycode = @it_base-companycode
           AND fiscalyear  = @it_base-fiscalyear
           AND postingdate = @it_base-postingdate
           AND accountingdocumentitem = @it_base-accountingdocumentitem
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
             WHERE purchaseorder   = @it_base-purchaseorder
             AND purchaseorderitem = @it_base-purchaseorderitem
             INTO TABLE @DATA(it_prc_agg).

    ENDIF.

    IF it_po_item IS NOT INITIAL.

      SELECT name,
      producttypecode
      FROM   i_producttypecodetext
      FOR ALL ENTRIES IN @it_po_item
      WHERE producttypecode = @it_po_item-producttype
      INTO TABLE @DATA(it_producttype).
    ENDIF.

    IF it_po_type IS NOT INITIAL.

      SELECT bptaxnumber,
      businesspartner
      FROM i_businesspartnertaxnumber
      FOR ALL ENTRIES IN @it_po_type
      WHERE businesspartner = @it_po_type-supplier
      INTO TABLE @DATA(it_bp_tax).
    ENDIF.

*-------------------
* Loop through main data table
    CLEAR : lt_response.
    LOOP AT it_base ASSIGNING FIELD-SYMBOL(<fs_base>).

      CLEAR ls_response.
      MOVE-CORRESPONDING <fs_base> TO ls_response.
      READ TABLE it_purchasehistory INTO DATA(ls_purchaseorderhistory) WITH KEY purchaseorder                 = ls_response-purchaseorder
                                                                                purchaseorderitem             = ls_response-purchaseorderitem
                                                                                purchasinghistorydocument     = ls_response-supplierinvoice
                                                                                purchasinghistorydocumentitem = ls_response-supplierinvoiceitem.
      IF  sy-subrc = 0.
        ls_response-totalgoodsmvtamtincccrcy = ls_purchaseorderhistory-invoiceamtincocodecrcy.
      ENDIF.
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
*      ls_response-documentdate                  = <fs_base>-documentdate.
      ls_response-postingdate                   = <fs_base>-postingdate.
      ls_response-supplierinvoicewthnfiscalyear = <fs_base>-supplierinvoicewthnfiscalyear.
      ls_response-cgstglaccount                 = <fs_base>-cgstgl.
      ls_response-sgstglaccount                 = <fs_base>-sgstgl.
      ls_response-igstglaccount                 = <fs_base>-igstgl.
      ls_response-ugstglaccount                 = <fs_base>-ugstgl.
      " ============ Map Header Fields ============
      ls_response-paymentterms                  = <fs_base>-paymentterms.
      ls_response-documentcurrency              = <fs_base>-documentcurrency.
      ls_response-supplierinvoiceidbyinvcgparty = <fs_base>-supplierinvoiceidbyinvcgparty.
      ls_response-exchangerate                  = <fs_base>-exchangerate.
      ls_response-notes                         = <fs_base>-yy1_note1_mih.

      " ============ Map Accounting Data ============
      ls_response-accountingdocument            = <fs_base>-accountingdocument.
      ls_response-amountintransactioncurrency   = <fs_base>-amountintransactioncurrency.
      ls_response-glaccount                     = <fs_base>-glaccount.
*      ls_response-originalreferencedocument     = <fs_base>-originalreferencedocument.
      ls_response-transactioncurrency           = <fs_base>-transactioncurrency.
      ls_response-accountingdocumentitem        = <fs_base>-accountingdocumentitem.
      ls_response-hsn                           = <fs_base>-in_hsnorsaccode.
      ls_response-supplier                      = <fs_base>-invoicingparty.
      " ============ Set Display Currencies ============
      ls_response-displaycurrencyinr = 'INR'.
      ls_response-displaycurrencyusd = 'USD'.

      " ============ Read Purchase Order Type ============
      SORT it_po_type BY
       purchaseorder.
      READ TABLE it_po_type ASSIGNING FIELD-SYMBOL(<fs_po_type>)
        WITH KEY purchaseorder = <fs_base>-purchaseorder.
      IF sy-subrc = 0 AND ( <fs_po_type>-purchaseordertype = 'ZUB' OR <fs_po_type>-purchaseordertype = 'ZST' ).
        ls_response-notes = |STO - { <fs_po_type>-purchaseordertype }|.
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
        ls_response-materialdescription      = <fs_po_item>-productname.
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

      ls_response-accountingdocument = <fs_base>-accountingdocument.

      " ============ Read Journal Entry Data ============
      DATA(lv_is_reversed) = abap_false.
      SORT it_journal BY
       accountingdocument
       fiscalyear.
      READ TABLE it_journal ASSIGNING FIELD-SYMBOL(<fs_journal>)
        WITH KEY accountingdocument = <fs_base>-accountingdocument
                 fiscalyear = <fs_base>-fiscalyear
        BINARY SEARCH.
      IF sy-subrc = 0.
        ls_response-accountingdocumentheadertext = <fs_journal>-accountingdocumentheadertext.
        ls_response-accountingdocumenttype       = <fs_journal>-accountingdocumenttype.
        IF <fs_journal>-isreversal = 'X'.  "isreversed = 'X'. "Changes by rutikk 20.03.2026
          lv_is_reversed = abap_true.
          ls_response-totalgoodsmvtamtincccrcy = ls_response-totalgoodsmvtamtincccrcy * ( -1 ).
          ls_response-quantityinbaseunit       = ls_response-quantityinbaseunit * ( -1 ).
        ENDIF.
      ENDIF.

      " ============ Read Accounting Document Journal ============

      DATA : lv_postingkey TYPE i_accountingdocumentjournal-postingkey. " added by Omkar

      SORT it_acc_journal BY
          accountingdocument
          companycode
          fiscalyear.
      READ TABLE it_acc_journal ASSIGNING FIELD-SYMBOL(<fs_acc_jrnl>)
        WITH KEY accountingdocument     = <fs_base>-accountingdocument
                 accountingdocumentitem = <fs_base>-accountingdocumentitem
                 companycode            = <fs_base>-companycode
                 fiscalyear             = <fs_base>-fiscalyear
                 postingkey             = '21'
                 debitcreditcode        = 'S'.
      IF sy-subrc = 0.
        ls_response-debitcreditcode = <fs_acc_jrnl>-debitcreditcode.
        ls_response-postingkey      = <fs_acc_jrnl>-postingkey.
        lv_postingkey               = <fs_acc_jrnl>-postingkey.     "  added by Omkar
      ELSE.
        CLEAR lv_postingkey.            " added by Omkar
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
        SORT it_producttype BY
         producttypecode.
        READ TABLE it_producttype ASSIGNING FIELD-SYMBOL(<fs_producttype>)
        WITH KEY producttypecode = <fs_po_item>-producttype.
        IF sy-subrc = 0.
          ls_response-producttypename = <fs_producttype>-name.
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
      IF <fs_po_type> IS ASSIGNED.

        IF <fs_po_type>-purchaseordertype = 'ZUB' OR <fs_po_type>-purchaseordertype = 'ZST'.
          ls_response-invoicegrossamount = COND #(
             WHEN <fs_base>-documentcurrency = 'INR'
             THEN <fs_base>-invoicegrossamount
             WHEN <fs_base>-documentcurrency = 'USD'
             THEN <fs_base>-invoicegrossamount * <fs_base>-exchangerate
             ELSE 0
*       ) * lv_reversal_factor.
            ).
        ELSE.
          ls_response-invoicegrossamount = COND #(
             WHEN <fs_base>-documentcurrency = 'INR'
             THEN <fs_base>-amountintransactioncurrency
             WHEN <fs_base>-documentcurrency = 'USD'
             THEN <fs_base>-amountintransactioncurrency * <fs_base>-exchangerate
             ELSE 0
*       ) * lv_reversal_factor.
            ).
        ENDIF.
      ELSE.
        ls_response-invoicegrossamount = COND #(
           WHEN <fs_base>-documentcurrency = 'INR'
           THEN <fs_base>-amountintransactioncurrency
           WHEN <fs_base>-documentcurrency = 'USD'
           THEN <fs_base>-amountintransactioncurrency * <fs_base>-exchangerate
           ELSE 0
*       ) * lv_reversal_factor.
          ).
      ENDIF.
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
        ). "Rutikk 05.03.2026

**      ls_response-invoicegrossamount1 = COND #(
**         WHEN <fs_base>-documentcurrency = 'USD'
**         THEN ls_response-invoicegrossamount
**         ELSE 0
***       ) * lv_reversal_factor.
**        ).

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
**      IF <fs_base>-suplrinvcdeliverycostcndntype = 'ZFVI' OR
**         <fs_base>-suplrinvcdeliverycostcndntype = 'ZIF1'.
**        ls_response-impfcharge = <fs_base>-supplierinvoiceitemamount.
**      ENDIF.

      " Parking Charge (INR/USD)
      IF <fs_base>-glaccount = '0000410109'.
        IF <fs_base>-documentcurrency = 'INR'.
          ls_response-parkcharge_inr = <fs_base>-amountintransactioncurrency.
        ELSEIF <fs_base>-documentcurrency = 'USD'.
          ls_response-parkcharge_usd = <fs_base>-amountintransactioncurrency.
        ENDIF.
      ENDIF.

      " Round Off
**      IF <fs_base>-glaccount = '0000450034'.
**        ls_response-round = <fs_base>-amountintransactioncurrency.
**      ENDIF.

      ls_response-round = <fs_base>-roundoff.

      " Insurance Charge
      READ TABLE it_supplierinvitem INTO DATA(ls_supplierinvitem) WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                           purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                           suplrinvcdeliverycostcndntype = 'ZIIV'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-inscharge = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      " Import Freight Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZFVI'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-impfcharge = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      " Import Freight Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZIF1'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-impfcharge = ls_response-impfcharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "Insurance USD
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZOFI'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-insuranceusd = ls_response-impfcharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      " Other Expenses
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZOTC'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-otherexp = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      " Other Expenses
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZEXP'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-otherexp = ls_response-otherexp + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  Customs Duty Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZBCD'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-custdcharge = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  Customs Duty Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZIOT'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-custdcharge = ls_response-custdcharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  Customs Duty Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZCDC'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-custdcharge = ls_response-custdcharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.


      "  SWS Charge
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZSWS'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-swscharge = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  " CHA Charges
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZCHA'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-chacharge = ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  " CHA Charges
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZTCH'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-chacharge = ls_response-chacharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  " CHA Charges
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZSTD'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-chacharge = ls_response-chacharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  " CHA Charges
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZSLC'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-chacharge = ls_response-chacharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.

      "  " CHA Charges
      CLEAR : ls_supplierinvitem.
      READ TABLE it_supplierinvitem INTO ls_supplierinvitem WITH KEY purchaseorder                 = <fs_base>-purchaseorder
                                                                     purchaseorderitem             = <fs_base>-purchaseorderitem
                                                                     suplrinvcdeliverycostcndntype = 'ZCFS'.
      IF ls_supplierinvitem IS NOT INITIAL.
        ls_response-chacharge = ls_response-chacharge + ls_supplierinvitem-supplierinvoiceitemamount.
      ENDIF.


      " ============ Calculate GST Amounts (Excluding RCM Tax Codes) ============
      " CGST Amount
      IF <fs_base>-taxcode <> 'R1' AND <fs_base>-taxcode <> 'R2' AND
         <fs_base>-taxcode <> 'R3' AND <fs_base>-taxcode <> 'R4' AND
         <fs_base>-taxcode <> 'RA' AND <fs_base>-taxcode <> 'RB' AND
         <fs_base>-taxcode <> 'RC' AND <fs_base>-taxcode <> 'RD'.
        ls_response-cgstamt = <fs_base>-cgst * lv_reversal_factor.
      ENDIF.

      " SGST Amount
      IF <fs_base>-taxcode <> 'R1' AND <fs_base>-taxcode <> 'R2' AND
         <fs_base>-taxcode <> 'R3' AND <fs_base>-taxcode <> 'R4'.
        ls_response-sgstamt = <fs_base>-sgst * lv_reversal_factor.
      ENDIF.

      " IGST Amount
      IF <fs_base>-taxcode <> 'R5' AND <fs_base>-taxcode <> 'R6' AND
         <fs_base>-taxcode <> 'R7' AND <fs_base>-taxcode <> 'R8' AND
         <fs_base>-taxcode <> 'R9'.
        ls_response-igstamt = <fs_base>-igst * lv_reversal_factor.
      ENDIF.

      " UGST Amount
      IF <fs_base>-taxcode <> 'RA' AND <fs_base>-taxcode <> 'RB' AND
         <fs_base>-taxcode <> 'RC' AND <fs_base>-taxcode <> 'RD'.
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
      IF <fs_base>-taxcode <> 'R1' AND <fs_base>-taxcode <> 'R2' AND
         <fs_base>-taxcode <> 'R3' AND <fs_base>-taxcode <> 'R4' AND
         <fs_base>-taxcode <> 'RA' AND <fs_base>-taxcode <> 'RB' AND
         <fs_base>-taxcode <> 'RC' AND <fs_base>-taxcode <> 'RD'.
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

        ls_response-totaltax1 = ( lv_base_amount + lv_parking_amount ) * lv_reversal_factor.

      ENDIF.

      "  Added by omkar-------------------------------------

      CASE lv_postingkey.
        WHEN '21'.
          IF ls_response-invoicegrossamount GT 0.
            ls_response-invoicegrossamount   =  ls_response-invoicegrossamount * ( - 1 ).
          ENDIF.
          IF ls_response-supplierinvoiceitemamount GT 0.
            ls_response-supplierinvoiceitemamount = ls_response-supplierinvoiceitemamount * ( -1 ).
          ENDIF.
          IF ls_response-totaltax GT 0.
            ls_response-totaltax = ls_response-totaltax * ( -1 ).
          ENDIF.
      ENDCASE."
      "------------------------------------------------------
      READ TABLE it_gl ASSIGNING FIELD-SYMBOL(<lfs_gl>) WITH KEY glaccount = <fs_base>-glaccount.
      IF sy-subrc = 0.
        ls_response-glaccountname = <lfs_gl>-glaccountname.
      ENDIF.

      SELECT SINGLE FROM i_cnsldtnglaccountvh
      FIELDS glaccountname
      WHERE glaccount = @ls_response-cgstglaccount
      INTO @ls_response-cgstglaccountname.

      SELECT SINGLE FROM i_cnsldtnglaccountvh
      FIELDS glaccountname
      WHERE glaccount = @ls_response-sgstglaccount
      INTO @ls_response-sgstglaccountname.

      SELECT SINGLE FROM i_cnsldtnglaccountvh
      FIELDS glaccountname
      WHERE glaccount = @ls_response-igstglaccount
      INTO @ls_response-igstglaccountname.

      SELECT SINGLE FROM i_cnsldtnglaccountvh
      FIELDS glaccountname
      WHERE glaccount = @ls_response-ugstglaccount
      INTO @ls_response-ugstglaccountname.

      " ============ Append to Final Table ============
      APPEND ls_response TO lt_response.

    ENDLOOP.
    CLEAR : it_base, it_acc, it_acco, it_acc_journal, it_bill_doc_hist,
            it_pur_hist, it_bp_tax, it_gl, ls_purchaseorderhistory.
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

    " =====================================================
    " Existing logic (keep as-is)
    " =====================================================
*    SORT lt_response BY postingdate ASCENDING.
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

