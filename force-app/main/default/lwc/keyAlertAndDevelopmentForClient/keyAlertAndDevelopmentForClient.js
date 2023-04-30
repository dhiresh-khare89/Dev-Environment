import { LightningElement,wire, api, track } from 'lwc';
import getClientNews from '@salesforce/apex/FetchDataFromCapIQMCAController.getClientNews';

export default class KeyAlertAndDevelopmentForClient extends LightningElement {
    @api recordId;
    @track ClientNewsData;

    @wire(getClientNews, { clientId: '$recordId' })
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