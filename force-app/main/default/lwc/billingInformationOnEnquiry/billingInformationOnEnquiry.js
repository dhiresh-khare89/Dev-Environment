import { api, LightningElement,track,wire } from 'lwc';
import invoiceList from'@salesforce/apex/BillingInformationOnEnquiry.getInvoiceListforJob';
const COLS=[  
    {label:'Job',fieldName:'Id', type:'text'},
    {label:'Net Amount',fieldName:'NET_AMT__c', type:'currency'},
    {label:'Invoice Amount',fieldName:'INVOICE_DATE__c', type:'date'}
  ];

export default class BillingInformationOnEnquiry extends LightningElement {
    @api recordId;
    @track invoiceList=[];
    columns = COLS;

    @wire(invoiceList,{enquiryId:'$recordId'})
    invoiceList({data,error}){
        if(data){
            console.log('----------'+JSON.stringify(data));
            this.invoiceList=data;
        }else if(error){

        }

    }
}