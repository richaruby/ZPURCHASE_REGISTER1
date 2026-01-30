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

      /* ===== Keys ===== */
      @UI.lineItem                  : [{label: 'Invoicing Party', position: 10 ,importance: #HIGH }]
      @UI.identification            : [{ position: 10 }]
  key InvoicingParty                : abap.char(10);

      @UI.lineItem                  : [{label: 'Company Code', position: 20 ,importance: #HIGH }]
      @UI.identification            : [{ position: 20 }]
  key CompanyCode                   : bukrs;

      @UI.lineItem                  : [{label: 'Fiscal Year', position: 30 ,importance: #HIGH }]
      @UI.identification            : [{ position: 30 }]
  key FiscalYear                    : gjahr;

      @UI.lineItem                  : [{label: 'Supplier Invoice No', position: 40 ,importance: #HIGH }]
      @UI.identification            : [{ position: 40 }]
      @UI.selectionField            : [{ position: 10 }]
      @EndUserText.label            : 'Supplier Invoice No'
  key SupplierInvoice               : abap.char(10);

      @UI.lineItem                  : [{label: 'Supplier Invoice Item', position: 50 ,importance: #HIGH }]
      @UI.identification            : [{ position: 50 }]
  key SupplierInvoiceItem           : abap.char(6);

      @UI.lineItem                  : [{label: 'Purchase Order', position: 60 ,importance: #HIGH }]
      @UI.identification            : [{ position: 60 }]
      @UI.selectionField            : [{ position: 20 }]
      @EndUserText.label            : 'Purchase Order'
  key PurchaseOrder                 : ebeln;

      @UI.lineItem                  : [{label: 'Purchase Order Item', position: 70 ,importance: #HIGH }]
      @UI.identification            : [{ position: 70 }]
  key PurchaseOrderItem             : ebelp;

      @UI.lineItem                  : [{label: 'Supplier', position: 80 ,importance: #HIGH }]
      @UI.identification            : [{ position: 80 }]
  key Supplier                      : lifnr;

      @UI.lineItem                  : [{label: 'Plant', position: 90 ,importance: #HIGH }]
      @UI.identification            : [{ position: 90 }]
  key Plant                         : werks_d;

      @UI.lineItem                  : [{label: 'Document Date', position: 100 ,importance: #HIGH }]
      @UI.identification            : [{ position: 100 }]
  key DocumentDate                  : budat;

      @UI.lineItem                  : [{label: 'Posting Date', position: 110 ,importance: #HIGH }]
      @UI.identification            : [{ position: 110 }]
  key PostingDate                   : budat;

      @UI.lineItem                  : [{label: 'Supl Inv & Fisc Year', position: 120 ,importance: #HIGH }]
      @UI.identification            : [{ position: 120 }]
  key SupplierInvoiceWthnFiscalYear : abap.char(20);

//      /* ===== Header / Accounting ===== */
//      @UI.lineItem                  : [{ label: 'Original Reference Document', position: 130 }]
//      @UI.identification            : [{ position: 130 }]
//      OriginalReferenceDocument     : awkey;

      @UI.lineItem                  : [{ label: 'Journal Entry', position: 140, importance: #HIGH }]
      @UI.identification            : [{ position: 140 }]
      @UI.selectionField            : [{ position: 30 }]
      @EndUserText.label            : 'Journal Entry(Acc Doc)'
      AccountingDocument            : belnr_d;

      @UI.lineItem                  : [{ label: 'Journal Entry Item', position: 150 }]
      @UI.identification            : [{ position: 150 }]
      AccountingDocumentItem        : buzei;

      @UI.lineItem                  : [{ label: 'Debit Credit Code', position: 160 }]
      @UI.identification            : [{ position: 160 }]
      DebitCreditCode               : shkzg;

      @UI.lineItem                  : [{ label: 'Posting Key', position: 170 }]
      @UI.identification            : [{ position: 170 }]
      PostingKey                    : bschl;

      @UI.lineItem                  : [{ label: 'Supplier Invoice Ref', position: 180 }]
      @UI.identification            : [{ position: 180 }]
      SupplierInvoiceIDByInvcgParty : xblnr;

      @UI.lineItem                  : [{ label: 'Payment Terms', position: 190 }]
      @UI.identification            : [{ position: 190 }]
      PaymentTerms                  : abap.char(10);

      @UI.lineItem                  : [{ label: 'Journal Entry Type', position: 200 }]
      @UI.identification            : [{ position: 200 }]
      AccountingDocumentType        : blart;

      @UI.lineItem                  : [{ label: 'Document Header Text', position: 210 }]
      @UI.identification            : [{ position: 210 }]
      AccountingDocumentHeaderText  : bktxt;

      @UI.lineItem                  : [{ label: 'GL Account', position: 220 }]
      @UI.identification            : [{ position: 220 }]
      GLAccount                     : hkont;

      /* ===== Currency ===== */
      @UI.lineItem                  : [{ label: 'Document Currency', position: 230 }]
      @UI.identification            : [{ position: 230 }]
      DocumentCurrency              : waers;

      @UI.lineItem                  : [{ label: 'Transaction Currency', position: 240 }]
      @UI.identification            : [{ position: 240 }]
      TransactionCurrency           : waers;

      @UI.lineItem                  : [{ label: 'Amt in Trnscn Crcy', position: 250 }]
      @UI.identification            : [{ position: 250 }]
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency   : wrbtr;

      @UI.lineItem                  : [{ label: 'Condition Currency', position: 260 }]
      @UI.identification            : [{ position: 260 }]
      ConditionCurrency             : waers;

      @UI.lineItem                  : [{ label: 'Display Currency (₹) ', position: 270 }]
      @UI.identification            : [{ position: 270 }]
      DisplayCurrencyINR            : abap.cuky;

      @UI.lineItem                  : [{ label: 'Display Currency ($)', position: 280 }]
      @UI.identification            : [{ position: 280 }]
      DisplayCurrencyUSD            : abap.cuky;

      @UI.lineItem                  : [{ label: 'Rate', position: 290 }]
      @UI.identification            : [{ position: 290 }]
      NetPriceAmount                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Exchange Rate', position: 300 }]
      @UI.identification            : [{ position: 300 }]
      ExchangeRate                  : abap.dec(9,5);

      /* ===== Amounts ===== */
      @UI.lineItem                  : [{ label: 'Converted Inv Amt', position: 310 }]
      @UI.identification            : [{ position: 310 }]
      InvoiceGrossAmount            : abap.dec(15,2);

//      @UI.lineItem                  : [{ label: 'Total Invoice Amount(₹)', position: 320 }]
//      @UI.identification            : [{ position: 320 }]
//      InvoiceAmount                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Invoice Amount($)', position: 330 }]
      @UI.identification            : [{ position: 330 }]
      InvoiceGrossAmount1           : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Net Amt (₹)', position: 340 }]
      @UI.identification            : [{ position: 340 }]
      SupplierInvoiceItemAmount     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Import Freight', position: 350 }]
      @UI.identification            : [{ position: 350 }]
      ImpFCharge                    : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing Charges (₹)', position: 360 }]
      @UI.identification            : [{ position: 360 }]
      ParkCharge_INR                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing Charges ($)', position: 370 }]
      @UI.identification            : [{ position: 370 }]
      ParkCharge_USD                : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Rounding-off', position: 380 }]
      @UI.identification            : [{ position: 380 }]
      Round                         : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Ins Charge', position: 390 }]
      @UI.identification            : [{ position: 390 }]
      InsCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Other Exp', position: 400 }]
      @UI.identification            : [{ position: 400 }]
      OtherExp                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CustD Charge', position: 410 }]
      @UI.identification            : [{ position: 410 }]
      CustDCharge                   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Sws Charge', position: 420 }]
      @UI.identification            : [{ position: 420 }]
      SwsCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CHA Charges', position: 430 }]
      @UI.identification            : [{ position: 430 }]
      ChaCharge                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'CGST Amt', position: 440 }]
      @UI.identification            : [{ position: 440 }]
      CGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'SGST Amt', position: 450 }]
      @UI.identification            : [{ position: 450 }]
      SGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'IGST Amt', position: 460 }]
      @UI.identification            : [{ position: 460 }]
      IGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'UGST Amt', position: 470 }]
      @UI.identification            : [{ position: 470 }]
      UGSTAmt                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'TDS Amount', position: 480 }]
      @UI.identification            : [{ position: 480 }]
      TDS                           : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMCGST', position: 490 }]
      @UI.identification            : [{ position: 490 }]
      RMCGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMSGST', position: 500 }]
      @UI.identification            : [{ position: 500 }]
      RMSGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMIGST', position: 510 }]
      @UI.identification            : [{ position: 510 }]
      RMIGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'RMUGST', position: 520 }]
      @UI.identification            : [{ position: 520 }]
      RMUGST                        : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Taxable Amount (₹)', position: 530 }]
      @UI.identification            : [{ position: 530 }]
      TotalTax                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Taxable Amount ($)', position: 540 }]
      @UI.identification            : [{ position: 540 }]
      TotalTax1                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Total Tax Amount', position: 550 }]
      @UI.identification            : [{ position: 550 }]
      TotalTaxAmt                   : abap.dec(15,2);

      /* ===== GST / Tax ===== */
      @UI.lineItem                  : [{ label: 'Tax Code', position: 560 }]
      @UI.identification            : [{ position: 560 }]
      TaxCode                       : mwskz;

      @UI.lineItem                  : [{ label: 'Tax Code Name', position: 570}]
      @UI.identification            : [{ position: 570 }]
      TaxCodeName                   : abap.char(60);

      @UI.lineItem                  : [{ label: 'IGST Rate', position: 580 }]
      @UI.identification            : [{ position: 580 }]
      IGST_Rate                     : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'CGST Rate', position: 590 }]
      @UI.identification            : [{ position: 590 }]
      CGST_Rate                     : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'SGST Rate', position: 600 }]
      @UI.identification            : [{ position: 600 }]
      SGST_Rate                     : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'UGST Rate', position: 610 }]
      @UI.identification            : [{ position: 610 }]
      UGST_Rate                     : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'RM IGST Rate', position: 620 }]
      @UI.identification            : [{ position: 620 }]
      RCM_IGST_Rate                 : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'RM CGST Rate', position: 630 }]
      @UI.identification            : [{ position: 630 }]
      RCM_CGST_Rate                 : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'RM SGST Rate', position: 640 }]
      @UI.identification            : [{ position: 640 }]
      RCM_SGST_Rate                 : abap.dec(5,2);

      @UI.lineItem                  : [{ label: 'RM UGST Rate', position: 650 }]
      @UI.identification            : [{ position: 650 }]
      RCM_UGST_Rate                 : abap.dec(5,2);

      /* ===== Business ===== */
      @UI.lineItem                  : [{ label: 'Supplier Name', position: 660 }]
      @UI.identification            : [{ position:660 }]
      SupplierName                  : abap.char(80);

      @UI.lineItem                  : [{ label: 'Dlvry Cost Cndn Type', position: 670 }]
      @UI.identification            : [{ position: 670 }]
      SuplrInvcDeliveryCostCndnType : kschl;

      @UI.lineItem                  : [{ label: 'Supl Inv Item Text', position: 680 }]
      @UI.identification            : [{ position: 680 }]
      SupplierInvoiceItemText       : sgtxt;

      @UI.lineItem                  : [{ label: 'Unplnd Dlvry Cost', position: 690 }]
      @UI.identification            : [{ position: 690 }]
      SuplrInvcItmUnplndDelivCost   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Supplier GSTIN', position: 700 }]
      @UI.identification            : [{ position: 700 }]
      BPTaxNumber                   : bptaxnum;

      @UI.lineItem                  : [{ label: 'Supplier City', position: 710 }]
      @UI.identification            : [{ position: 710 }]
      CityName                      : abap.char(40);

      @UI.lineItem                  : [{ label: 'Address', position: 720 }]
      @UI.identification            : [{ position: 720 }]
      Address                       : abap.char(255);

      @UI.lineItem                  : [{ label: 'Supplier PAN', position: 730 }]
      @UI.identification            : [{ position: 730 }]
      SupplierPAN                   : abap.char(20);

      @UI.lineItem                  : [{ label: 'Plant GSTIN', position: 740 }]
      @UI.identification            : [{ position: 740 }]
      PlantGSTIN                    : abap.char(20);

      @UI.lineItem                  : [{ label: 'MSME Number', position: 750 }]
      @UI.identification            : [{ position: 750 }]
      MSME                          : abap.char(20);

      /* ===== PO / Item ===== */
      @UI.lineItem                  : [{ label: 'PO Type', position: 760 }]
      @UI.identification            : [{ position: 760 }]
      PurchaseOrderType             : abap.char(4);

      @UI.lineItem                  : [{ label: 'PO Item Text', position: 770 }]
      @UI.identification            : [{ position: 770 }]
      PurchaseOrderItemText         : abap.char(40);

      @UI.lineItem                  : [{ label: 'Product Type', position: 780 }]
      @UI.identification            : [{ position: 780 }]
      ProductType                   : abap.char(4);

      @UI.lineItem                  : [{ label: 'Product Type Name', position: 790 }]
      @UI.identification            : [{ position: 790 }]
      ProductTypeName               : abap.char(40);

      @UI.lineItem                  : [{ label: 'HSN Code', position: 800 }]
      @UI.identification            : [{ position: 800 }]
      HSN                           : abap.char(10);

      @UI.lineItem                  : [{ label: 'Incoterms', position: 810 }]
      @UI.identification            : [{ position: 810 }]
      IncotermsClassification       : abap.char(10);

      /* ===== Pricing ===== */
      @UI.lineItem                  : [{ label: 'Insurance (₹)', position: 820 }]
      @UI.identification            : [{ position: 820 }]
      Insurance                     : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Discount (₹)', position: 830 }]
      @UI.identification            : [{ position: 830 }]
      Discount                      : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Commission (₹)', position: 840 }]
      @UI.identification            : [{ position: 840 }]
      Commission                    : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing & Forwarding (₹)', position: 850 }]
      @UI.identification            : [{ position: 850 }]
      PackingForwarding             : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Freight (₹)', position: 860 }]
      @UI.identification            : [{ position: 860 }]
      Freight                       : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Insurance ($)', position: 870 }]
      @UI.identification            : [{ position: 870 }]
      InsuranceUSD                  : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Discount ($)', position: 870 }]
      @UI.identification            : [{ position: 870 }]
      DiscountUSD                   : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Commission ($)', position: 890 }]
      @UI.identification            : [{ position: 890 }]
      CommissionUSD                 : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Packing & Forwarding ($)', position: 900 }]
      @UI.identification            : [{ position: 900 }]
      PackingForwardingUSD          : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Freight ($)', position: 910 }]
      @UI.identification            : [{ position: 910 }]
      FreightUSD                    : abap.dec(15,2);

      @UI.lineItem                  : [{ label: 'Material Code', position: 920 }]
      @UI.identification            : [{ position: 920 }]
      Material                      : matnr;

      @UI.lineItem                  : [{ label: 'Receiving Quantity', position: 930 }]
      @UI.identification            : [{ position: 930 }]
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      QuantityInPurchaseOrderUnit   : erfmg;

      @UI.lineItem                  : [{ label: 'Rcvng Qty Unit', position: 940 }]
      @UI.identification            : [{ position: 940 }]
      PurchaseOrderQuantityUnit     : erfme;
      /* ===== Others ===== */
      @UI.lineItem                  : [{ label: 'Notes', position: 950 }]
      @UI.identification            : [{ position: 950 }]
      Notes                         : abap.char(255);
}
