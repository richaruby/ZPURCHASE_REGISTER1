@ObjectModel: {
query: {
   implementedBy: 'ABAP:ZCL_PURCHASE_REGISTER_NEW'
}
}

@UI.headerInfo: { typeName: 'Purchase Register Report' ,
                  typeNamePlural: 'Purchase Register Report' }

@EndUserText.label: 'Purchase Register Report – Custom Entity'
@Metadata.allowExtensions: true
define custom entity ZCE_PURCHASE_REGISTER_NEW
{

      @UI.facet                     : [{ id : 'bukrs',
                purpose             : #STANDARD,
                type                : #IDENTIFICATION_REFERENCE,
                label               : 'Purchase Register Details',
                position            : 10 }]
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Material Document Year', position: 10, importance: #HIGH }]
      //      @UI.identification            : [{ position: 01 }]
      //  key materialdocumentyear          : abap.char(10);
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Material Document', position: 02, importance: #HIGH }]
      //      @UI.identification            : [{ position: 02 }]
      //  key materialdocument              : abap.char(10);
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Material Document Item', position: 03, importance: #HIGH }]
      //      @UI.identification            : [{ position: 03 }]
      //  key materialdocumentitem          : abap.char(10);
      //
      //      /* ===== Keys ===== */
      //      @UI.lineItem                  : [{label: 'Invoicing Party', position: 10 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 10 }]
      //  key InvoicingParty                : abap.char(10);
      //
      //      @UI.lineItem                  : [{label: 'Company Code', position: 20 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 20 }]
      //  key CompanyCode                   : bukrs;
      //
      //      @UI.lineItem                  : [{label: 'Fiscal Year', position: 30 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 30 }]
      //  key FiscalYear                    : gjahr;
      //
      //      @UI.lineItem                  : [{label: 'Supplier Invoice No', position: 40 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 40 }]
      //      @UI.selectionField            : [{ position: 10 }]
      //      @EndUserText.label            : 'Supplier Invoice No'
      //  key SupplierInvoice               : abap.char(10);
      //
      //      @UI.lineItem                  : [{label: 'Supplier Invoice Item', position: 50 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 50 }]
      //  key SupplierInvoiceItem           : abap.char(6);
      //
      //      @UI.lineItem                  : [{label: 'Purchase Order', position: 60 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 60 }]
      //      @UI.selectionField            : [{ position: 20 }]
      //      @EndUserText.label            : 'Purchase Order'
      //  key PurchaseOrder                 : ebeln;
      //
      //      @UI.lineItem                  : [{label: 'Purchase Order Item', position: 70 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 70 }]
      //  key PurchaseOrderItem             : ebelp;
      //
      //      @UI.lineItem                  : [{label: 'Supplier', position: 80 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 80 }]
      //  key Supplier                      : lifnr;
      //
      //      @UI.lineItem                  : [{label: 'Plant', position: 90 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 90 }]
      //  key Plant                         : werks_d;
      //
      //      @UI.lineItem                  : [{label: 'Supl Inv & Fisc Year', position: 120 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 120 }]
      //  key SupplierInvoiceWthnFiscalYear : abap.char(20);
      //
      //      @UI.lineItem                  : [{ label: 'Reversal Indicator', position: 121, importance: #HIGH }]
      //      @UI.identification            : [{ position: 121 }]
      //      ReversalIndicator             : abap.char(1);
      //
      //      @UI.lineItem                  : [{label: 'Posting Date', position: 110 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 110 }]
      //      PostingDate                   : budat;
      //
      //      @UI.lineItem                  : [{label: 'Document Date', position: 100 ,importance: #HIGH }]
      //      @UI.identification            : [{ position: 100 }]
      //      DocumentDate                  : bldat;
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Goods Movement Type', position: 04, importance: #HIGH }]
      //      @UI.identification            : [{ position: 04 }]
      //      goodsmovementtype             : abap.char(3);
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Quantity in Base Unit', position: 05, importance: #HIGH }]
      //      @UI.identification            : [{ position: 05 }]
      //      @Semantics.quantity.unitOfMeasure: 'entryunit'
      //      quantityinbaseunit            : abap.quan(13,3);
      //
      //      @UI.hidden                    : true
      //      @UI.lineItem                  : [{ label: 'GRN - Entry Unit', position: 06, importance: #HIGH }]
      //      @UI.identification            : [{ position: 06 }]
      //      entryunit                     : abap.unit(3);
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Posting Date', position: 07, importance: #HIGH }]
      //      @UI.identification            : [{ position: 07 }]
      //      postingdate_grn               : abap.dats;
      //
      //      @UI.lineItem                  : [{ label: 'GRN - Total Goods Movement Amount', position: 08, importance: #HIGH }]
      //      @UI.identification            : [{ position: 08 }]
      //      @Semantics.amount.currencyCode: 'companycodecurrency'
      //      totalgoodsmvtamtincccrcy      : wrbtr;
      //
      //      @UI.hidden                    : true
      //      @UI.lineItem                  : [{ label: 'GRN - Company Code Currency', position: 09, importance: #HIGH }]
      //      @UI.identification            : [{ position: 09 }]
      //      companycodecurrency           : waers;
      //
      //      @UI.lineItem                  : [{ label: 'IRN - Material Document', position: 02, importance: #HIGH }]
      //      @UI.identification            : [{ position: 11 }]
      //      we_materialdocument           : abap.char(10);
      //
      //      @UI.lineItem                  : [{ label: 'IRN - Total Goods Movement Amount', position: 08, importance: #HIGH }]
      //      @UI.identification            : [{ position: 12 }]
      //      @Semantics.amount.currencyCode: 'companycodecurrency'
      //      we_totalgoodsmvtamtincccrcy   : wrbtr;
      //
      //
      //      @UI.lineItem                  : [{ label: 'Journal Entry', position: 140, importance: #HIGH }]
      //      @UI.identification            : [{ position: 140 }]
      //      @UI.selectionField            : [{ position: 30 }]
      //      @EndUserText.label            : 'Journal Entry(Acc Doc)'
      //      AccountingDocument            : belnr_d;
      //
      //      @UI.hidden                    : true
      //      @UI.lineItem                  : [{ label: 'Journal Entry Item', position: 150 }]
      //      @UI.identification            : [{ position: 150 }]
      //      AccountingDocumentItem        : buzei;
      //
      //      @UI.lineItem                  : [{ label: 'Debit Credit Code', position: 160 }]
      //      @UI.identification            : [{ position: 160 }]
      //      //      @UI.hidden                    : true
      //      DebitCreditCode               : shkzg;
      //
      //      @UI.lineItem                  : [{ label: 'Posting Key', position: 170 }]
      //      @UI.identification            : [{ position: 170 }]
      //      //      @UI.hidden                    : true
      //      PostingKey                    : bschl;
      //
      //      @UI.lineItem                  : [{ label: 'Supplier Invoice Ref', position: 180 }]
      //      @UI.identification            : [{ position: 180 }]
      //      SupplierInvoiceIDByInvcgParty : xblnr;
      //
      //      @UI.lineItem                  : [{ label: 'Payment Terms', position: 190 }]
      //      @UI.identification            : [{ position: 190 }]
      //      PaymentTerms                  : abap.char(10);
      //
      //      @UI.lineItem                  : [{ label: 'Journal Entry Type', position: 200 }]
      //      @UI.identification            : [{ position: 200 }]
      //      AccountingDocumentType        : blart;
      //
      //      @UI.lineItem                  : [{ label: 'Document Header Text', position: 210 }]
      //      @UI.identification            : [{ position: 210 }]
      //      AccountingDocumentHeaderText  : bktxt;
      //
      //      @UI.lineItem                  : [{ label: 'GL Account', position: 220 }]
      //      @UI.identification            : [{ position: 220 }]
      //      GLAccount                     : hkont;
      //
      //      @UI.lineItem                  : [{ label: 'GL Account Name', position: 225 }]
      //      @UI.identification            : [{ position: 225 }]
      //      GLAccountName                 : abap.char( 60 );
      //
      //      /* ===== Currency ===== */
      //      @UI.lineItem                  : [{ label: 'Document Currency', position: 230 }]
      //      @UI.identification            : [{ position: 230 }]
      //      DocumentCurrency              : waers;
      //
      //      @UI.lineItem                  : [{ label: 'Transaction Currency', position: 240 }]
      //      @UI.identification            : [{ position: 240 }]
      //      TransactionCurrency           : waers;
      //
      //      @UI.lineItem                  : [{ label: 'Amt in Trnscn Crcy', position: 250 }]
      //      @UI.identification            : [{ position: 250 }]
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      AmountInTransactionCurrency   : wrbtr;
      //
      //      @UI.lineItem                  : [{ label: 'Condition Currency', position: 260 }]
      //      @UI.identification            : [{ position: 260 }]
      //      ConditionCurrency             : waers;
      //
      //      @UI.lineItem                  : [{ label: 'Display Currency (₹) ', position: 270 }]
      //      @UI.identification            : [{ position: 270 }]
      //      DisplayCurrencyINR            : abap.cuky;
      //
      //      @UI.lineItem                  : [{ label: 'Display Currency ($)', position: 280 }]
      //      @UI.identification            : [{ position: 280 }]
      //      DisplayCurrencyUSD            : abap.cuky;
      //
      //      @UI.lineItem                  : [{ label: 'Rate', position: 290 }]
      //      @UI.identification            : [{ position: 290 }]
      //      NetPriceAmount                : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Exchange Rate', position: 300 }]
      //      @UI.identification            : [{ position: 300 }]
      //      ExchangeRate                  : abap.dec(9,5);
      //
      //      /* ===== Amounts ===== */
      //
      //      //   Commented by Omkar
      //      //      @UI.lineItem                  : [{ label: 'Converted Inv Amt', position: 310 }]
      //      //      @UI.identification            : [{ position: 310 }]
      //      //      InvoiceGrossAmount            : abap.dec(15,2);
      //
      //      //   Added by Omkar
      //      @UI.lineItem                  : [{ label: 'Total Invoice Amount(₹)', position: 320 }]
      //      @UI.identification            : [{ position: 320 }]
      //      InvoiceGrossAmount            : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Total Invoice Amount($)', position: 330 }]
      //      @UI.identification            : [{ position: 330 }]
      //      InvoiceGrossAmount1           : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Net Amt (₹)', position: 340 }]
      //      @UI.identification            : [{ position: 340 }]
      //      SupplierInvoiceItemAmount     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Import Freight', position: 350 }]
      //      @UI.identification            : [{ position: 350 }]
      //      ImpFCharge                    : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Packing Charges (₹)', position: 360 }]
      //      @UI.identification            : [{ position: 360 }]
      //      ParkCharge_INR                : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Packing Charges ($)', position: 370 }]
      //      @UI.identification            : [{ position: 370 }]
      //      ParkCharge_USD                : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Rounding-off', position: 380 }]
      //      @UI.identification            : [{ position: 380 }]
      //      Round                         : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Ins Charge', position: 390 }]
      //      @UI.identification            : [{ position: 390 }]
      //      InsCharge                     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Other Exp', position: 400 }]
      //      @UI.identification            : [{ position: 400 }]
      //      OtherExp                      : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'CustD Charge', position: 410 }]
      //      @UI.identification            : [{ position: 410 }]
      //      CustDCharge                   : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Sws Charge', position: 420 }]
      //      @UI.identification            : [{ position: 420 }]
      //      SwsCharge                     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'CHA Charges', position: 430 }]
      //      @UI.identification            : [{ position: 430 }]
      //      ChaCharge                     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'CGST G/L', position: 431 }]
      //      @UI.identification            : [{ position: 431 }]
      //      CGSTGlAccount                 : hkont;
      //
      //      @UI.lineItem                  : [{ label: 'CGST G/L Name', position: 432 }]
      //      @UI.identification            : [{ position: 441 }]
      //      CGSTGlAccountName             : abap.char( 60 );
      //
      //      @UI.lineItem                  : [{ label: 'CGST Amt', position: 440 }]
      //      @UI.identification            : [{ position: 440 }]
      //      CGSTAmt                       : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'SGST G/L', position: 441 }]
      //      @UI.identification            : [{ position: 441 }]
      //      SGSTGlAccount                 : hkont;
      //
      //      @UI.lineItem                  : [{ label: 'SGST G/L Name', position: 442 }]
      //      @UI.identification            : [{ position: 441 }]
      //      SGSTGlAccountName             : abap.char( 60 );
      //
      //      @UI.lineItem                  : [{ label: 'SGST Amt', position: 450 }]
      //      @UI.identification            : [{ position: 450 }]
      //      SGSTAmt                       : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'IGST G/L', position: 451 }]
      //      @UI.identification            : [{ position: 451 }]
      //      IGSTGlAccount                 : hkont;
      //
      //      @UI.lineItem                  : [{ label: 'IGST G/L Name', position: 452 }]
      //      @UI.identification            : [{ position: 452 }]
      //      IGSTGlAccountName             : abap.char( 60 );
      //
      //      @UI.lineItem                  : [{ label: 'IGST Amt', position: 460 }]
      //      @UI.identification            : [{ position: 460 }]
      //      IGSTAmt                       : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'UGST G/L', position: 461 }]
      //      @UI.identification            : [{ position: 461 }]
      //      UGSTGlAccount                 : hkont;
      //
      //      @UI.lineItem                  : [{ label: 'UGST G/L Name', position: 462 }]
      //      @UI.identification            : [{ position: 462 }]
      //      UGSTGlAccountName             : abap.char( 60 );
      //
      //      @UI.lineItem                  : [{ label: 'UGST Amt', position: 470 }]
      //      @UI.identification            : [{ position: 470 }]
      //      UGSTAmt                       : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'TDS Amount', position: 480 }]
      //      @UI.identification            : [{ position: 480 }]
      //      TDS                           : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'RMCGST', position: 490 }]
      //      @UI.identification            : [{ position: 490 }]
      //      RMCGST                        : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'RMSGST', position: 500 }]
      //      @UI.identification            : [{ position: 500 }]
      //      RMSGST                        : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'RMIGST', position: 510 }]
      //      @UI.identification            : [{ position: 510 }]
      //      RMIGST                        : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'RMUGST', position: 520 }]
      //      @UI.identification            : [{ position: 520 }]
      //      RMUGST                        : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Total Taxable Amount (₹)', position: 530 }]
      //      @UI.identification            : [{ position: 530 }]
      //      TotalTax                      : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Total Taxable Amount ($)', position: 540 }]
      //      @UI.identification            : [{ position: 540 }]
      //      TotalTax1                     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Total Tax Amount', position: 550 }]
      //      @UI.identification            : [{ position: 550 }]
      //      TotalTaxAmt                   : abap.dec(15,2);
      //
      //      /* ===== GST / Tax ===== */
      //      @UI.lineItem                  : [{ label: 'Tax Code', position: 560 }]
      //      @UI.identification            : [{ position: 560 }]
      //      TaxCode                       : mwskz;
      //
      //      @UI.lineItem                  : [{ label: 'Tax Code Name', position: 570}]
      //      @UI.identification            : [{ position: 570 }]
      //      TaxCodeName                   : abap.char(60);
      //
      //      @UI.lineItem                  : [{ label: 'IGST Rate', position: 580 }]
      //      @UI.identification            : [{ position: 580 }]
      //      IGST_Rate                     : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'CGST Rate', position: 590 }]
      //      @UI.identification            : [{ position: 590 }]
      //      CGST_Rate                     : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'SGST Rate', position: 600 }]
      //      @UI.identification            : [{ position: 600 }]
      //      SGST_Rate                     : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'UGST Rate', position: 610 }]
      //      @UI.identification            : [{ position: 610 }]
      //      UGST_Rate                     : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'RM IGST Rate', position: 620 }]
      //      @UI.identification            : [{ position: 620 }]
      //      RCM_IGST_Rate                 : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'RM CGST Rate', position: 630 }]
      //      @UI.identification            : [{ position: 630 }]
      //      RCM_CGST_Rate                 : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'RM SGST Rate', position: 640 }]
      //      @UI.identification            : [{ position: 640 }]
      //      RCM_SGST_Rate                 : abap.dec(5,2);
      //
      //      @UI.lineItem                  : [{ label: 'RM UGST Rate', position: 650 }]
      //      @UI.identification            : [{ position: 650 }]
      //      RCM_UGST_Rate                 : abap.dec(5,2);
      //
      //      /* ===== Business ===== */
      //      @UI.lineItem                  : [{ label: 'Supplier Name', position: 660 }]
      //      @UI.identification            : [{ position:660 }]
      //      SupplierName                  : abap.char(80);
      //
      //      @UI.lineItem                  : [{ label: 'Dlvry Cost Cndn Type', position: 670 }]
      //      @UI.identification            : [{ position: 670 }]
      //      @UI.hidden                    : true
      //      SuplrInvcDeliveryCostCndnType : kschl;
      //
      //      @UI.lineItem                  : [{ label: 'Supl Inv Item Text', position: 680 }]
      //      @UI.identification            : [{ position: 680 }]
      //      SupplierInvoiceItemText       : sgtxt;
      //
      //      @UI.lineItem                  : [{ label: 'Unplnd Dlvry Cost', position: 690 }]
      //      @UI.identification            : [{ position: 690 }]
      //      SuplrInvcItmUnplndDelivCost   : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Supplier GSTIN', position: 700 }]
      //      @UI.identification            : [{ position: 700 }]
      //      BPTaxNumber                   : bptaxnum;
      //
      //      @UI.lineItem                  : [{ label: 'Supplier City', position: 710 }]
      //      @UI.identification            : [{ position: 710 }]
      //      CityName                      : abap.char(40);
      //
      //      @UI.lineItem                  : [{ label: 'Address', position: 720 }]
      //      @UI.identification            : [{ position: 720 }]
      //      Address                       : abap.char(255);
      //
      //      @UI.lineItem                  : [{ label: 'Supplier PAN', position: 730 }]
      //      @UI.identification            : [{ position: 730 }]
      //      SupplierPAN                   : abap.char(20);
      //
      //      @UI.lineItem                  : [{ label: 'Plant GSTIN', position: 740 }]
      //      @UI.identification            : [{ position: 740 }]
      //      PlantGSTIN                    : abap.char(20);
      //
      //      @UI.lineItem                  : [{ label: 'MSME Number', position: 750 }]
      //      @UI.identification            : [{ position: 750 }]
      //      MSME                          : abap.char(20);
      //
      //      /* ===== PO / Item ===== */
      //      @UI.lineItem                  : [{ label: 'PO Type', position: 760 }]
      //      @UI.identification            : [{ position: 760 }]
      //      PurchaseOrderType             : abap.char(4);
      //
      //      @UI.lineItem                  : [{ label: 'PO Item Text', position: 770 }]
      //      @UI.identification            : [{ position: 770 }]
      //      PurchaseOrderItemText         : abap.char(40);
      //
      //      @UI.lineItem                  : [{ label: 'Product Type', position: 780 }]
      //      @UI.identification            : [{ position: 780 }]
      //      ProductType                   : abap.char(4);
      //
      //      @UI.lineItem                  : [{ label: 'Product Type Name', position: 790 }]
      //      @UI.identification            : [{ position: 790 }]
      //      ProductTypeName               : abap.char(40);
      //
      //      @UI.lineItem                  : [{ label: 'HSN Code', position: 800 }]
      //      @UI.identification            : [{ position: 800 }]
      //      HSN                           : abap.char(10);
      //
      //      @UI.lineItem                  : [{ label: 'Incoterms', position: 810 }]
      //      @UI.identification            : [{ position: 810 }]
      //      IncotermsClassification       : abap.char(10);
      //
      //      /* ===== Pricing ===== */
      //      @UI.lineItem                  : [{ label: 'Insurance (₹)', position: 820 }]
      //      @UI.identification            : [{ position: 820 }]
      //      Insurance                     : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Discount (₹)', position: 830 }]
      //      @UI.identification            : [{ position: 830 }]
      //      Discount                      : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Commission (₹)', position: 840 }]
      //      @UI.identification            : [{ position: 840 }]
      //      Commission                    : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Packing & Forwarding (₹)', position: 850 }]
      //      @UI.identification            : [{ position: 850 }]
      //      PackingForwarding             : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Freight (₹)', position: 860 }]
      //      @UI.identification            : [{ position: 860 }]
      //      Freight                       : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Insurance ($)', position: 870 }]
      //      @UI.identification            : [{ position: 870 }]
      //      InsuranceUSD                  : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Discount ($)', position: 870 }]
      //      @UI.identification            : [{ position: 870 }]
      //      DiscountUSD                   : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Commission ($)', position: 890 }]
      //      @UI.identification            : [{ position: 890 }]
      //      CommissionUSD                 : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Packing & Forwarding ($)', position: 900 }]
      //      @UI.identification            : [{ position: 900 }]
      //      PackingForwardingUSD          : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Freight ($)', position: 910 }]
      //      @UI.identification            : [{ position: 910 }]
      //      FreightUSD                    : abap.dec(15,2);
      //
      //      @UI.lineItem                  : [{ label: 'Material Code', position: 920 }]
      //      @UI.identification            : [{ position: 920 }]
      //      Material                      : matnr;
      //
      //      @UI.lineItem                  : [{ label: 'Material Description', position: 925 }]
      //      @UI.identification            : [{ position: 925 }]
      //      MaterialDescription           : abap.char( 60 );
      //
      //      @UI.lineItem                  : [{ label: 'Receiving Quantity', position: 930 }]
      //      @UI.identification            : [{ position: 930 }]
      //      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      //      QuantityInPurchaseOrderUnit   : erfmg;
      //
      //      //  Commented by Omkar
      //      //      @UI.lineItem                  : [{ label: 'Rcvng Qty Unit', position: 940 }]
      //      //      @UI.identification            : [{ position: 940 }]
      //      //      PurchaseOrderQuantityUnit     : erfme;
      //
      //      //  Added by Omkar
      //      @UI.lineItem                  : [{ label: 'UoM (Unit of Measure)', position: 940 }]
      //      @UI.identification            : [{ position: 940 }]
      //      PurchaseOrderQuantityUnit     : erfme;
      //
      //      /* ===== Others ===== */
      //      @UI.lineItem                  : [{ label: 'Notes', position: 950 }]
      //      @UI.identification            : [{ position: 950 }]
      //      Notes                         : abap.char(255);

      @UI.lineItem                  : [{ label: 'GRN - Material Document Item', position: 01 }]
      @UI.identification            : [{ position: 01 }]
  key materialdocumentitem          : abap.char(10);

      @UI.lineItem                  : [{ label: 'Invoicing Party', position: 08 }]
      @UI.identification            : [{ position: 08 }]
  key InvoicingParty                : abap.char(10);

      @UI.lineItem                  : [{ label: 'GRN - Material Document Year', position: 09 }]
      @UI.identification            : [{ position: 09 }]
  key materialdocumentyear          : abap.char(10);

      @UI.lineItem                  : [{ label: 'Company Code', position: 10 }]
      @UI.identification            : [{ position: 10 }]
  key CompanyCode                   : bukrs;

      @UI.lineItem                  : [{ label: 'Fiscal Year', position: 11 }]
      @UI.identification            : [{ position: 11 }]
  key FiscalYear                    : gjahr;

      @UI.lineItem                  : [{ label: 'Supplier Invoice No', position: 12 }]
      @UI.identification            : [{ position: 12 }]
      @UI.selectionField            : [{ position: 10 }]
  key SupplierInvoice               : abap.char(10);

      @UI.lineItem                  : [{ label: 'GRN - Material Document', position: 13 }]
      @UI.identification            : [{ position: 13 }]
  key materialdocument              : abap.char(10);

      @UI.lineItem                  : [{ label: 'Supplier Invoice Item', position: 14 }]
      @UI.identification            : [{ position: 14 }]
  key SupplierInvoiceItem           : abap.char(6);

      @UI.lineItem                  : [{ label: 'Purchase Order', position: 15 }]
      @UI.identification            : [{ position: 15 }]
      @UI.selectionField            : [{ position: 20 }]
  key PurchaseOrder                 : ebeln;

      @UI.lineItem                  : [{ label: 'Purchase Order Item', position: 16 }]
      @UI.identification            : [{ position: 16 }]
  key PurchaseOrderItem             : ebelp;

      @UI.lineItem                  : [{ label: 'Supplier', position: 17 }]
      @UI.identification            : [{ position: 17 }]
  key Supplier                      : lifnr;

      @UI.lineItem                  : [{ label: 'Plant', position: 18 }]
      @UI.identification            : [{ position: 18 }]
  key Plant                         : werks_d;

      @UI.lineItem                  : [{ label: 'GRN - Goods Movement Type', position: 02 }]
      @UI.identification            : [{ position: 02 }]
      goodsmovementtype             : abap.char(3);

      @UI.lineItem                  : [{ label: 'GRN - Quantity in Base Unit', position: 03 }]
      @UI.identification            : [{ position: 03 }]
      @Semantics.quantity.unitOfMeasure: 'entryunit'
      quantityinbaseunit            : abap.quan(13,3);

      @UI.lineItem                  : [{ label: 'GRN - Posting Date', position: 04 }]
      @UI.identification            : [{ position: 04 }]
      postingdate_grn               : abap.dats;

      @UI.lineItem                  : [{ label: 'IRN - Material Document', position: 05 }]
      @UI.identification            : [{ position: 05 }]
      we_materialdocument           : abap.char(10);

      @UI.lineItem                  : [{ label: 'IRN - Total Goods Movement Amount', position: 06 }]
      @UI.identification            : [{ position: 06 }]
      @Semantics.amount.currencyCode: 'companycodecurrency'
      we_totalgoodsmvtamtincccrcy   : wrbtr;

      @UI.lineItem                  : [{ label: 'GRN - Total Goods Movement Amount', position: 07 }]
      @UI.identification            : [{ position: 07 }]
      @Semantics.amount.currencyCode: 'companycodecurrency'
      totalgoodsmvtamtincccrcy      : wrbtr;

      @UI.lineItem                  : [{ label: 'Document Date', position: 19 }]
      @UI.identification            : [{ position: 19 }]
      DocumentDate                  : bldat;

      @UI.lineItem                  : [{ label: 'Posting Date', position: 20 }]
      @UI.identification            : [{ position: 20 }]
      PostingDate                   : budat;

      @UI.lineItem                  : [{ label: 'Supl Inv & Fisc Year', position: 21 }]
      @UI.identification            : [{ position: 21 }]
      SupplierInvoiceWthnFiscalYear : abap.char(20);

      @UI.lineItem                  : [{ label: 'Reversal Indicator', position: 22 }]
      @UI.identification            : [{ position: 22 }]
      ReversalIndicator             : abap.char(1);

      /* continue same pattern... */

      @UI.lineItem                  : [{ label: 'Journal Entry', position: 23 }]
      AccountingDocument            : belnr_d;

      @UI.lineItem                  : [{ label: 'Debit Credit Code', position: 24 }]
      DebitCreditCode               : shkzg;

      @UI.lineItem                  : [{ label: 'Posting Key', position: 25 }]
      PostingKey                    : bschl;

      @UI.lineItem                  : [{ label: 'Supplier Invoice Ref', position: 26 }]
      SupplierInvoiceIDByInvcgParty : xblnr;

      @UI.lineItem                  : [{ label: 'Payment Terms', position: 27 }]
      PaymentTerms                  : abap.char(10);

      @UI.lineItem                  : [{ label: 'Journal Entry Type', position: 28 }]
      AccountingDocumentType        : blart;

      @UI.lineItem                  : [{ label: 'Document Header Text', position: 29 }]
      AccountingDocumentHeaderText  : bktxt;

      @UI.lineItem                  : [{ label: 'GL Account', position: 30 }]
      GLAccount                     : hkont;

      @UI.lineItem                  : [{ label: 'GL Account Name', position: 31 }]
      GLAccountName                 : abap.char(60);

      @UI.lineItem                  : [{ label: 'Document Currency', position: 32 }]
      @UI.identification            : [{ position: 32 }]
      DocumentCurrency              : waers;

      @UI.lineItem                  : [{ label: 'Transaction Currency', position: 33 }]
      @UI.identification            : [{ position: 33 }]
      TransactionCurrency           : waers;

      @UI.lineItem                  : [{ label: 'Amt in Trnscn Crcy', position: 34 }]
      @UI.identification            : [{ position: 34 }]
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency   : wrbtr;

      @UI.lineItem                  : [{ label: 'Condition Currency', position: 35 }]
      @UI.identification            : [{ position: 35 }]
      ConditionCurrency             : waers;

      @UI.lineItem                  : [{ label: 'Display Currency (₹)', position: 36 }]
      @UI.identification            : [{ position: 36 }]
      DisplayCurrencyINR            : abap.cuky;

      @UI.lineItem                  : [{ label: 'Display Currency ($)', position: 37 }]
      @UI.identification            : [{ position: 37 }]
      DisplayCurrencyUSD            : abap.cuky;

      @UI.lineItem                  : [{ label: 'Rate', position: 38 }]
      @UI.identification            : [{ position: 38 }]
      NetPriceAmount                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Exchange Rate', position: 39 }]
      @UI.identification            : [{ position: 39 }]
      ExchangeRate                  : abap.dec(9,5);

      @UI.lineItem                  : [{ label: 'Total Invoice Amount(₹)', position: 40 }]
      @UI.identification            : [{ position: 40 }]
      InvoiceGrossAmount            : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Invoice Amount($)', position: 41 }]
      @UI.identification            : [{ position: 41 }]
      InvoiceGrossAmount1           : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Net Amt (₹)', position: 42 }]
      @UI.identification            : [{ position: 42 }]
      SupplierInvoiceItemAmount     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Import Freight', position: 43 }]
      @UI.identification            : [{ position: 43 }]
      ImpFCharge                    : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing Charges (₹)', position: 44 }]
      @UI.identification            : [{ position: 44 }]
      ParkCharge_INR                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing Charges ($)', position: 45 }]
      @UI.identification            : [{ position: 45 }]
      ParkCharge_USD                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Rounding-off', position: 46 }]
      @UI.identification            : [{ position: 46 }]
      Round                         : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Ins Charge', position: 47 }]
      @UI.identification            : [{ position: 47 }]
      InsCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Other Exp', position: 48 }]
      @UI.identification            : [{ position: 48 }]
      OtherExp                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CustD Charge', position: 49 }]
      @UI.identification            : [{ position: 49 }]
      CustDCharge                   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Sws Charge', position: 50 }]
      @UI.identification            : [{ position: 50 }]
      SwsCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CHA Charges', position: 51 }]
      @UI.identification            : [{ position: 51 }]
      ChaCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CGST G/L', position: 52 }]
      @UI.identification            : [{ position: 52 }]
      CGSTGlAccount                 : hkont;

      @UI.lineItem                  : [{ label: 'CGST G/L Name', position: 53 }]
      @UI.identification            : [{ position: 53 }]
      CGSTGlAccountName             : abap.char(60);

      @UI.lineItem                  : [{ label: 'CGST Amt', position: 54 }]
      @UI.identification            : [{ position: 54 }]
      CGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'SGST G/L', position: 55 }]
      @UI.identification            : [{ position: 55 }]
      SGSTGlAccount                 : hkont;

      @UI.lineItem                  : [{ label: 'SGST G/L Name', position: 56 }]
      @UI.identification            : [{ position: 56 }]
      SGSTGlAccountName             : abap.char(60);

      @UI.lineItem                  : [{ label: 'SGST Amt', position: 57 }]
      @UI.identification            : [{ position: 57 }]
      SGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'IGST G/L', position: 58 }]
      @UI.identification            : [{ position: 58 }]
      IGSTGlAccount                 : hkont;

      @UI.lineItem                  : [{ label: 'IGST G/L Name', position: 59 }]
      @UI.identification            : [{ position: 59 }]
      IGSTGlAccountName             : abap.char(60);

      @UI.lineItem                  : [{ label: 'IGST Amt', position: 60 }]
      @UI.identification            : [{ position: 60 }]
      IGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'UGST G/L', position: 61 }]
      @UI.identification            : [{ position: 61 }]
      UGSTGlAccount                 : hkont;

      @UI.lineItem                  : [{ label: 'UGST G/L Name', position: 62 }]
      @UI.identification            : [{ position: 62 }]
      UGSTGlAccountName             : abap.char(60);

      @UI.lineItem                  : [{ label: 'UGST Amt', position: 63 }]
      @UI.identification            : [{ position: 63 }]
      UGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'TDS Amount', position: 64 }]
      @UI.identification            : [{ position: 64 }]
      TDS                           : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMCGST', position: 65 }]
      @UI.identification            : [{ position: 65 }]
      RMCGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMSGST', position: 66 }]
      @UI.identification            : [{ position: 66 }]
      RMSGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMIGST', position: 67 }]
      @UI.identification            : [{ position: 67 }]
      RMIGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMUGST', position: 68 }]
      @UI.identification            : [{ position: 68 }]
      RMUGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Taxable Amount (₹)', position: 69 }]
      @UI.identification            : [{ position: 69 }]
      TotalTax                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Taxable Amount ($)', position: 70 }]
      @UI.identification            : [{ position: 70 }]
      TotalTax1                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Tax Amount', position: 71 }]
      @UI.identification            : [{ position: 71 }]
      TotalTaxAmt                   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Tax Code', position: 72 }]
      TaxCode                       : mwskz;

      @UI.lineItem                  : [{ label: 'Tax Code Name', position: 73 }]
      TaxCodeName                   : abap.char(50);

      @UI.lineItem                  : [{ label: 'IGST Rate', position: 74 }]
      IGST_Rate                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CGST Rate', position: 75 }]
      CGST_Rate                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'SGST Rate', position: 76 }]
      SGST_Rate                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'UGST Rate', position: 77 }]
      UGST_Rate                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RCM IGST Rate', position: 78 }]
      RCM_IGST_Rate                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RCM CGST Rate', position: 79 }]
      RCM_CGST_Rate                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RCM SGST Rate', position: 80 }]
      RCM_SGST_Rate                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RCM UGST Rate', position: 81 }]
      RCM_UGST_Rate                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Supplier Name', position: 82 }]
      SupplierName                  : abap.char(60);

      @UI.lineItem                  : [{ label: 'Supl Inv Item Text', position: 83 }]
      SupplierInvoiceItemText       : abap.char(100);

      @UI.lineItem                  : [{ label: 'Unplnd Dlvry Cost', position: 84 }]
      UnplannedDeliveryCost         : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Supplier GSTIN', position: 85 }]
      BPTaxNumber                   : abap.char(20);

      @UI.lineItem                  : [{ label: 'Supplier City', position: 86 }]
      CityName                      : abap.char(40);

      @UI.lineItem                  : [{ label: 'Address', position: 87 }]
      Address                       : abap.char(100);

      @UI.lineItem                  : [{ label: 'Supplier PAN', position: 88 }]
      SupplierPAN                   : abap.char(20);

      @UI.lineItem                  : [{ label: 'Plant GSTIN', position: 89 }]
      PlantGSTIN                    : abap.char(20);

      @UI.lineItem                  : [{ label: 'MSME Number', position: 90 }]
      MSME                          : abap.char(20);

      @UI.lineItem                  : [{ label: 'PO Type', position: 91 }]
      PurchaseOrderType             : abap.char(15);

      @UI.lineItem                  : [{ label: 'PO Item Text', position: 92 }]
      PurchaseOrderItemText         : abap.char(100);

      @UI.lineItem                  : [{ label: 'Product Type', position: 93 }]
      ProductType                   : abap.char(20);

      @UI.lineItem                  : [{ label: 'Product Type Name', position: 94 }]
      ProductTypeName               : abap.char(50);

      @UI.lineItem                  : [{ label: 'HSN Code', position: 95 }]
      HSN                           : abap.char(20);

      @UI.lineItem                  : [{ label: 'Incoterms', position: 96 }]
      IncotermsClassification       : abap.char(30);

      @UI.lineItem                  : [{ label: 'Insurance (₹)', position: 97 }]
      Insurance                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Discount (₹)', position: 98 }]
      Discount                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Commission (₹)', position: 99 }]
      Commission                    : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing & Forwarding (₹)', position: 100 }]
      PackingForwarding             : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Freight (₹)', position: 101 }]
      Freight                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Discount ($)', position: 102 }]
      DiscountUSD                   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Insurance ($)', position: 103 }]
      InsuranceUSD                  : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Commission ($)', position: 104 }]
      CommissionUSD                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing & Forwarding ($)', position: 105 }]
      PackingForwardingUSD          : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Freight ($)', position: 106 }]
      FreightUSD                    : abap.dec(15,2);

      /* MATERIAL */

      @UI.lineItem                  : [{ label: 'Material Code', position: 107 }]
      Material                      : matnr;

      @UI.lineItem                  : [{ label: 'Material Description', position: 108 }]
      MaterialDescription           : abap.char(100);

      @UI.lineItem                  : [{ label: 'Receiving Quantity', position: 109 }]
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      QuantityInPurchaseOrderUnit   : abap.quan(13,3);

      @UI.lineItem                  : [{ label: 'UoM (Unit of Measure)', position: 110 }]
      PurchaseOrderQuantityUnit     : meins;

      @UI.lineItem                  : [{ label: 'Notes', position: 111 }]
      Notes                         : abap.char(255);

      /////////////---------------------------------------/////////////////
      @UI.hidden                    : true
      @UI.lineItem                  : [{ label: 'GRN - Entry Unit', position: 06, importance: #HIGH }]
      @UI.identification            : [{ position: 112 }]
      entryunit                     : abap.unit(3);

      @UI.hidden                    : true
      @UI.lineItem                  : [{ label: 'GRN - Company Code Currency', position: 09, importance: #HIGH }]
      @UI.identification            : [{ position: 113 }]
      companycodecurrency           : waers;

      @UI.hidden                    : true
      @UI.lineItem                  : [{ label: 'Journal Entry Item', position: 114 }]
      @UI.identification            : [{ position: 114 }]
      AccountingDocumentItem        : buzei;

      @UI.lineItem                  : [{ label: 'Dlvry Cost Cndn Type', position: 115 }]
      @UI.identification            : [{ position: 115 }]
      @UI.hidden                    : true
      SuplrInvcDeliveryCostCndnType : kschl;

      @UI.lineItem                  : [{ label: 'Unplnd Dlvry Cost', position: 116 }]
      @UI.identification            : [{ position: 116 }]
      SuplrInvcItmUnplndDelivCost   : abap.dec(15,2);

//      @UI.lineItem                  : [{ label: 'Total Taxable Amount (₹)', position: 117 }]
//      @UI.identification            : [{ position: 117 }]
//      TotalTax                      : abap.dec(15,2);
//
//      @UI.lineItem                  : [{ label: 'Total Taxable Amount ($)', position: 118 }]
//      @UI.identification            : [{ position: 118 }]
//      TotalTax1                     : abap.dec(15,2);
}
