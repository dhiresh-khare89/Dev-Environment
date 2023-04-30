import { LightningElement, wire, track } from "lwc";
import objectApiName1 from "@salesforce/schema/IntegratedEnquiry__c";
import getClientList from "@salesforce/apex/clientLookupIntEnquiry.getClientList";
import checkduplicate from '@salesforce/apex/checkDupliacteForIntegratedEnquiry.checkDuplicate';
import {NavigationMixin} from 'lightning/navigation';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class NewIntegratedEnquiryCustomPage extends NavigationMixin(LightningElement) {
  @track objectApiName = objectApiName1;
  @track closeDate;
  @track closeDate3;
  @track closeDate1;
  @track expertise;
  @track solution1;
  @track solution;
  @track name;
  @track sector;
  @track data1;
  @track intName = "";
  @track intName1;
  @track gtUser;
  @track existingContact;
  @track existingClient;
  @track lawContact;
  @track lawClient;
  @track chamberClient;
  @track chamberContact;
  @track pevcContact;
  @track pevcClient;
  @track isDisabed=true;
  @track isValidationDate = false;
  @track today = new Date();
  isShowModal=false;
  subExpertis='';
  activeAccordionSections = ['rDetails', 'ieDetails', 'clientDetails'];

  @wire(getClientList, { name: "$name" })
  wiredData({ error, data }) {
    if (data) {
      this.data1 = data[0]["Sector__c"];
      this.sector = this.data1;
      this.intName1 = data[0]["Name"];
    } else if (error) {
    }
  }
  handleSuccess(event) {
    const evt = new ShowToastEvent({
      title: "Account created",
      message: "Record ID: " + event.detail.id,
      variant: "success",
    });
    this.dispatchEvent(evt);
  }
  
  handleChange(event) {
    this.name = event.target.value;
  }
  handleChangeName(event) {
    this.solution1 = event.target.value;
    console.log("Solution--->>", this.solution1);
     if (this.solution1 == null) {
      this.intName = "";
    } else {
      this.intName =
        this.intName1 +
        "-" +
        this.solution1 +
        "-" +
        String(this.today.getDate()).padStart(2, "0") +
        String(this.today.getMonth() + 1).padStart(2, "0") +
        this.today.getFullYear();
    }
    //this.intName = this.intName1  + '-' + this.solution1 + '-' + String(this.today.getDate()).padStart(2, '0') + '/' + String(this.today.getMonth() + 1).padStart(2, '0') + '/' + this.today.getFullYear();
  }
  handleSubExpertyChange(event){
    this.subExpertise=event.details.value;
  }
  handleChangeDate(event) {
    this.closeDate1 = event.target.value;
    
    this.closeDate3 = this.today.getFullYear() +'-' + String(this.today.getMonth() + 1).padStart(2, "0") + '-' +String(this.today.getDate()).padStart(2, "0");
        
    if (this.solution1 == null) {
      this.intName = "";
    } else {
      this.intName =
        this.intName1 +
        "-" +
        this.solution1 +
        "-" +
        String(this.today.getDate()).padStart(2, "0") +
        String(this.today.getMonth() + 1).padStart(2, "0") +
        this.today.getFullYear();
    }
    let fieldcloseDate  = this.template.querySelector('.close_date');
    if(this.closeDate1<this.closeDate3){
    console.log("this.closeDate1 ==>",this.closeDate1);
    fieldcloseDate.setErrors({'body':{'output':{'fieldErrors':{'CloseDate__c':[{'message':'Close Date Can not Be Less than Today'}]}}}});
    }
    else{
    console.log("this.closeDate3 ==>",this.closeDate3);
    }
  }
  handleSubmit(event) {
    console.log("hi");
    const eventt = new ShowToastEvent({
    title: 'Integrated Enquiry',
    variant:'success',
    message:
        'Integrated Enquiries successfully created',
});
this.dispatchEvent(eventt);
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "IntegratedEnquiry__c",
        actionName: "list",
      },
      state: {
        filterName: "All",
      },
    });
  }
  handleclicksubmit(event) {
    this.template
      .querySelectorAll("lightning-input-field")
      .forEach((element) => {
        element.reportValidity();
      });
  }
  handleCancel() {
    eval("$A.get('e.force:refreshView').fire();");
  }
  async handleduplicate(event){
    await checkduplicate({solution:this.solution,experty:this.expertise,subexperty:this.subExpertis,Company:this.name})
     .then(result=>{
         console.log('result',result);
         if(!result){
             const eventt = new ShowToastEvent({
                 title: 'There is no duplicate record',
                 message:'There is no duplicate record.',
                 variant:'success'    
             });
             this.dispatchEvent(eventt);
         }
        
         this.isShowModal=result;
         this.isDisabed=false;
     })
 }
  handleno(){
    this.isShowModal=false;
    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
          objectApiName: 'IntegratedEnquiry__C',
          actionName: 'list'
      },
      state: {
          
          filterName: 'Recent' ,
  }
  
  });
  eval("$A.get('e.force:refreshView').fire();");
  }
  handleyes(){

  }
  hideModalBox(){
    this.isShowModal=false;

}
}