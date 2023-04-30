import { LightningElement, wire, track, api } from 'lwc';

import getRCCs from '@salesforce/apex/rCCFormHelper.getRCCs';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const COLS = [{label: 'Name Of Entity', fieldName:'Name', type:'text'}];

export default class RCCForm extends NavigationMixin(LightningElement) {
@api recordId;
isShowRccForm = false;
isRCCFormLoading = false;
enquiryId = [];
// Button will open RCC Form
openForm(){
    console.log('enquiryId : '+this.recordId);
    this.isShowRccForm = true;
    this.enquiryId = [
    {
        name: "EnquiryId",
        type:'String',
        value:this.recordId
    }
    ]
}

// After save close Rcc Form Flow
handleFlowStatusChange(event){
    if(event.detail.status === 'FINISHED'){
       this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'RCC Form Created Successfully',
            variant: 'success',
        })
       );
       this.isShowRccForm = false;
       return refreshApex(this.wiredRCCs);
    }
}

// Close RCC Form on Cancel

closeRccForm(){
    this.isShowRccForm = false;
}

// RCCs List View
cols = COLS;
RCCs;
wiredRCCs;
@track isDataFound = false;

@wire(getRCCs, {enquiryId : '$recordId'})
rccWire(result){
    this.wiredRCCs = result;
    console.log('wiredRCCs : '+JSON.stringify(this.wiredRCCs));
    if(result.data){
      //  this.leads = result.data;
      console.log('RCCs Data Found : '+result.data);
        this.RCCs = result.data.map((row)=>{
            return this.mapRCCs(row);
        });
        this.isRCCFormLoading = true;
        window.setTimeout(()=>{this.isRCCFormLoading = false;}, 1000);
    }
    if(result.error){
        console.error(result);
    }
}

mapRCCs(row){
    console.log('RCCs : '+ this.RCCs);
    this.isDataFound = true;
    return{
        ...row,
        link: `/${row.Id}`
    };
}



}