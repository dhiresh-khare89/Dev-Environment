import { LightningElement, api, track, wire } from 'lwc';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import apexSubExpertise from '@salesforce/apex/UpdateProfessionalServicesController.apexSubExpertise'

import LeadObject from '@salesforce/schema/Lead';

export default class UpdateProfessionalServices extends LightningElement {
    @api recordId;
    @api leadData = {};
    @track nextPage = false;
    
    renderedCallback() {
        console.log('in renderer');
        console.log('currnet record id===>' + this.recordId)
    }

    handleClick() {
        console.log(JSON.stringify(this.leadData));
        console.log(this.leadData);
        this.nextPage = true;
        apexSubExpertise({ leadId: this.recordId, expertisePick: this.leadData.Expertise__c })
            .then((result) => {
               const subExpertOpt=[];
                subExpertOpt = result;
                console.log('result from apex ==>', JSON.stringify(result));
                console.log('this.subExpertOpt ==>', JSON.stringify(subExpertOpt));
            })
            .catch((error) => {
                console.log(error)
            });


    }
    handlePicklistChange(event) {
        this.leadData[event.target.name] = event.target.value;
        console.log(JSON.stringify(this.leadData));
        console.log(event.target.value);
    }

}