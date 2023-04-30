import { LightningElement, track, wire, api } from 'lwc';

import getProduct from '@salesforce/apex/OpportunityListViewController.getProduct';

export default class OpportunityListView extends LightningElement {
    @api recordId;
    @track oppData;
    @track createdDate;


    @wire(getProduct, { leadId: '$recordId' })
    wiredOpp({ data, error }) {
        if (data) {
            console.log('recordId : ' + this.recordId);
            this.oppData = data;
            console.log('oppData : ' + this.oppData);
            console.log('oppData Json : ' + JSON.stringify(this.oppData));

            this.oppData.forEach(element => {
                this.createdDate = (element.Opportunity.CreatedBy.CreatedDate).split('T')[0];
                console.log('createdDate : ' + this.createdDate);
            })
        }
        else if (error) {
            console.error('error : ' + error);
        }
    }
}