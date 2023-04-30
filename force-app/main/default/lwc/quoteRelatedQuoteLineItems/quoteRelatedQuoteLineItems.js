import { LightningElement ,track, wire, api} from 'lwc';

import EnquiryRelatedCommercialAndCommercialLineItem from '@salesforce/apex/quoteRelatedQuoteLineItemsController.EnquiryRelatedCommercialAndCommercialLineItem';

export default class QuoteRelatedQuoteLineItems extends LightningElement {
    @api recordId;
    @track QuoteWithQuoteLineItems;

    @wire(EnquiryRelatedCommercialAndCommercialLineItem, { IntegratedEnquiryId: '$recordId' })
    wiredQuoteQuoteLineItems({ data, error }) {
        if (data) {
            console.log('recordId : ' + this.recordId);
            this.QuoteWithQuoteLineItems = data;
            console.log('QuoteWithQuoteLineItems : ' + this.QuoteWithQuoteLineItems);
            console.log('QuoteWithQuoteLineItems Json : ' + JSON.stringify(this.QuoteWithQuoteLineItems));
        }
        else if (error) {
            console.error('error : ' + error);
        }
    }

    exportToPdf(Event) {
     console.log('Inside exportToPdf'); 
     window.print();  
    }
}