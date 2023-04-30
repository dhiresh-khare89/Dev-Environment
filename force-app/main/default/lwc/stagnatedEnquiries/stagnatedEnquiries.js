import { api, LightningElement, track, wire } from 'lwc';
import getEnquiries from '@salesforce/apex/StagnatedEnquiriesController.getEnquiries';

export default class StagnatedEnquiries extends LightningElement {
      
      @api recordId;
      @track columns = [
            { label: 'Name', fieldName: 'Name' },
            { label: 'Expertise', fieldName: 'Expertise' },
            { label: 'Stage', fieldName: 'StageName' },
            { label: 'Closed Won Date', fieldName: 'CloseDate' },
            { label: 'Enquiry Owner', fieldName: 'Owner' },
            { label: 'Amount', fieldName: 'Amount' },
            { label: 'Recovery %', fieldName: 'Recovery' }
      ];

      enquiryData;

      @wire(getEnquiries, { Id: '$recordId' })
      oppData({ data, error }) {
            if (data) {
                  console.log('Data : ', data);
                  this.enquiryData = data;
                  console.log('Data Stringified : ', data);
                  
            }
            else if (error) {
                  console.log('Error : ', error);
            }
      }


}