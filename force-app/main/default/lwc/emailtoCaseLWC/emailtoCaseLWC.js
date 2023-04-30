import { LightningElement, wire, track } from 'lwc';
import getEmailtoCase from '@salesforce/apex/EmailtoCaseLWCController.getEmailtoCase';
import createLead from '@salesforce/apex/EmailtoCaseLWCController.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class EmailtoCaseLWC extends NavigationMixin(LightningElement) {

    @track caseRecordList = [];
    @track ischeckBoxTrue = false;
    @track isLoading = false;
    handleRedirect(event) {
        let caseId = event.currentTarget.dataset.id;
       // alert('caseID'+caseId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: caseId,
                objectApiName: 'Case',
                actionName: 'view',
            },
        });

    }
    onhandleSelected(event) {
       // alert('checkbox value' + event.target.value);
        //alert('checkbox value' + event.target.checked);
        this.caseRecordList.push(event.target.value);

    }
    onhandleBulkLead() {
     //alert('caseRecordList '+this.caseRecordList);
      if (this.caseRecordList.length>0) {
        //alert('Inside if '+this.caseRecordList);
        createLead({ selectedCaseList: this.caseRecordList })
            .then(result => {
                //alert('inside dispatch event');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Lead Created Successfully',
                        variant: 'success'
                    })
                );
                //eval("$A.get('e.force:refreshView').fire();");
            }).catch(error => {
                //alert('error' + error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }).finally(() => {
                //console.log('Experiment completed');
                window.location.reload();
              });
      }     
    }
    @wire(getEmailtoCase) caseList;
    onhandleChange(event) {
        this.isLoading = true;
        let caseNumber = event.currentTarget.name;
        createLead({ selectedCaseList: caseNumber })
            .then(result => {
                
                //alert('inside dispatch event');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Lead Created Successfully',
                        variant: 'success'
                    })
                );
                this.showSpinner = false;
            }).catch(error => {
                //alert('error' + error);
                this.showSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                        
                    })
                );
            }).finally(() => {
                console.log('Experiment completed');
                window.location.reload();
              });
              
    }
}