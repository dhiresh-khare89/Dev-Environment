import { LightningElement, api, wire } from 'lwc';
import GetClientDetails from '@salesforce/apex/VisualMessageController.getClientDetails';
import Message from '@salesforce/label/c.VisualMessageLWC_Msg';
import Alert from '@salesforce/label/c.VisualMessageLWC_Alert';
import ClientName from '@salesforce/label/c.VisualMessageLWC_ClientName';

import { getRecord } from 'lightning/uiRecordApi';

export default class VisualMessage extends LightningElement {
    @api recordId;
    isAccountFound= false;
    accountName;
    accountRecordPageUrl;
    accountObj;
    company;
    label = {
        Message,
        Alert,
        ClientName
    };
    

    @wire(getRecord, { recordId: '$recordId', fields: 'Lead.Company' })
    wiredRecord({ error, data }) {
        if(data){
            console.log('Wired data : ' , data);
            console.log('company : ' , data.fields.Company.value);
            this.company = data.fields.Company.value;
            this.getCLientRecod();

        }
        else if(error){
            console.log('Error : ' ,error);
        }
    }

    getCLientRecod(){
        console.log('OUTPUT : ', this.company);

        GetClientDetails({company : this.company })
        .then(result => {
            console.log('result : ' , result);
            if(result!=null){
                this.isAccountFound=true
                this.accountName=result.accountName;
                this.accountRecordPageUrl = result.accRecordPageUrl;
                console.log(' result.accRecorPageUrl : ', result.accRecordPageUrl);
                console.log('Account name'+this.accountName);
                console.log('Account URL'+this.accountRecordPageUrl);
            }
            else{
                this.isAccountFound=false;
            }
      })
      .catch(error => {
            console.log('Error in sending ids : ', error);
      })
    }
    
}