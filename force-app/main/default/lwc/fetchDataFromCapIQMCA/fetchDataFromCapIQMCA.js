import { LightningElement ,track, wire, api} from 'lwc';

import getEnquiryRelatedClientNews from '@salesforce/apex/FetchDataFromCapIQMCAController.getEnquiryRelatedClientNews';

export default class FetchDataFromCapIQMCA extends LightningElement {
    @api recordId;
    @track ClientNewsData;

    @wire(getEnquiryRelatedClientNews, { OpportunityId: '$recordId' })
    wiredClientNews({ data, error }) {
        if (data) {
            console.log('recordId : ' + this.recordId);
            this.ClientNewsData = data;
            console.log('ClientNewsData : ' + this.ClientNewsData);
            console.log('ClientNewsData Json : ' + JSON.stringify(this.ClientNewsData));
        }
        else if (error) {
            console.error('error : ' + error);
        }
    }

}