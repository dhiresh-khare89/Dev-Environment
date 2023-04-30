import { LightningElement, api, track } from 'lwc';
import getNewClient from '@salesforce/apex/KeyDevAndAlertsController.getNewClient';

export default class KeyDevelopmentAndAlerts extends LightningElement {

      @api recordId;
      @track data;
      showDataTable = false;

      @api objectApiName;

      @track columns = [
            { label: 'Client News Name', fieldName: 'Name' },
            { label: 'IQ KEY DEV HEADLINE', fieldName: 'IQ_KEY_DEV_HEADLINE__c', wrapText: true, type: 'text' },

      ];

      connectedCallback() {
            try {
                  getNewClient({ recordId: this.recordId, objectName: this.objectApiName })
                        .then(result => {
                              if (result) {
                                    this.showDataTable = true;
                                    if (this.objectApiName == 'Account') {

                                          result.forEach(element => {
                                                element.IQ_KEY_DEV_HEADLINE__c = element.IQ_KEY_DEV_HEADLINE__c.slice(3, element.IQ_KEY_DEV_HEADLINE__c.length - 4);

                                          });
                                          this.data = result;

                                    }
                                    else {
                                          this.data = result;
                                    }
                              }
                              else {
                                    console.log('Result is empty and data : ', this.data);
                                    this.showDataTable = false;

                              }
                        })
                        .catch(error => {
                              console.log('Error : ', error);
                        })
            }
            catch (error) {
                  console.log('Error in getting new client data : ', error);
            }
      }


}