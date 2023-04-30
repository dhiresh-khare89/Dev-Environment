/*
API : 50
*/
import { LightningElement,api,wire} from 'lwc';
// import apex method from salesforce module 
import fetchLookupData from '@salesforce/apex/CustomLookupLwcController.fetchLookupData';
import fetchDefaultRecord from '@salesforce/apex/CustomLookupLwcController.fetchDefaultRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const DELAY = 300; // dealy apex callout timing in miliseconds  
export default class genericLookupFinal extends LightningElement {
    // public properties with initial default values 
    @api label = 'custom lookup label';
    @api placeholder = 'search...'; 
    @api iconName = 'standard:account';
    @api sObjectApiName = 'Account';
    @api defaultRecordId = '';
    //@api nameLookup='lookupCustom';
    // private properties 
    lstResult = []; // to store list of returned records   
    hasRecords = true; 
    searchKey=''; // to store input field value    
    isSearchLoading = false; // to control loading spinner  
    delayTimeout;
    selectedRecord = {}; // to store selected lookup record in object formate 
    @api recordTypeName;
   // initial function to populate default selected lookup record if defaultRecordId provided  
   @api accountRecordId
    async connectedCallback(){
        
        if(this.defaultRecordId != ''){
           await fetchDefaultRecord({ recordId: this.defaultRecordId , 'sObjectApiName' : this.sObjectApiName,
           recordTypeName:this.recordTypeName })
            .then((result) => {
                if(result != null){
                    console.log('data 33',result)
                    this.selectedRecord = result;
                    this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
                }
            })
            .catch((error) => {
                this.error = error;
                this.selectedRecord = {};
            });
         }
    }
    // wire function property to fetch search record based on user input
  /*  @wire(fetchLookupData, { searchKey: '$searchKey' , sObjectApiName : '$sObjectApiName',RecordTypeName:'$RecordTypeName' })
     searchResult(value) {
        console.log('data 123',value);
        const { data, error } = value; // destructure the provisioned value
        this.isSearchLoading = false;
        if (data) {
             this.hasRecords = data.length == 0 ? false : true; 
             this.lstResult = JSON.parse(JSON.stringify(data)); 
         }
        else if (error) {
            console.log('(error---> ' + JSON.stringify(error));
         }
    };*/
       
  // update searchKey property on input field change  
    handleKeyChange(event) {
        // Debouncing this method: Do not update the reactive property as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
        this.isSearchLoading = true;
        const searchKey = event.target.value;
        this.searchKey = searchKey;
        console.log('hey ', this.searchKey);
        // window.clearTimeout(this.delayTimeout);
        // const searchKey = event.target.value;
        // this.delayTimeout = setTimeout(() => {
        // this.searchKey = searchKey;
        // }, DELAY);
        console.log('this.RecordTypeName',this.recordTypeName);
         fetchLookupData({searchKey:this.searchKey,sObjectApiName:this.sObjectApiName,RecordTypeName:this.recordTypeName,
            accountRecordId:this.accountRecordId})
         .then(data=>{

            this.isSearchLoading = false;
            if (data) {
                 this.hasRecords = data.length == 0 ? false : true; 
                 this.lstResult = JSON.parse(JSON.stringify(data)); 
               
             }
         }).catch(error=>{
            console.log('(error---> ' + JSON.stringify(error));
         });

         
    }
    // method to toggle lookup result section on UI 
    toggleResult(event){
        const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'searchInputField':
                clsList.add('slds-is-open');
               break;
            case 'lookupContainer':
                clsList.remove('slds-is-open');    
            break;                    
           }
    }
   // method to clear selected lookup record  
   handleRemove(){
    try{
        //changes by Rahul 
        const drop = this.template.querySelector('.slds-dropdown');
        drop.classList.add('drop-border');
        const ul = this.template.querySelector('ul.slds-listbox');
        ul.classList.add('ui-border');
        const label = this.template.querySelector('.label');
        label.classList.add('pos-abs');
        const oth = this.template.querySelector('.other');
        oth.classList.remove('width75');
        //changes by Rahul 

        this.searchKey = '';    
        this.selectedRecord = {};
        console.log('remove');
        
       this.lookupUpdatehandler('Null'); // update value on parent component as well from helper function 

        // remove selected pill and display input field again 
        const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
        searchBoxWrapper.classList.remove('slds-hide');
        searchBoxWrapper.classList.add('slds-show');
        const pillDiv = this.template.querySelector('.pillDiv');
        pillDiv.classList.remove('slds-show');
        pillDiv.classList.add('slds-hide');
    }catch(e){
        console.log('----------->>>'+e);
    }
  }
  // method to update selected record from search result 
handelSelectedRecord(event){   
     var objId = event.target.getAttribute('data-recid'); // get selected record Id 
     this.selectedRecord = this.lstResult.find(data => data.Id === objId); // find selected record from list 
     this.lookupUpdatehandler(this.selectedRecord); // update value on parent component as well from helper function 
     this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
}
/*COMMON HELPER METHOD STARTED*/
handelSelectRecordHelper(){
    this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');
     const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
     searchBoxWrapper.classList.remove('slds-show');
     searchBoxWrapper.classList.add('slds-hide');
     const pillDiv = this.template.querySelector('.pillDiv');
     pillDiv.classList.remove('slds-hide');
     pillDiv.classList.add('slds-show');     
     console.log('inside');
     //changes by Rahul 
     const drop = this.template.querySelector('.slds-dropdown');
     drop.classList.remove('drop-border');
     const ul = this.template.querySelector('ul.slds-listbox');
     ul.classList.remove('ui-border');
     const label = this.template.querySelector('.label');
     label.classList.remove('pos-abs');
     const oth = this.template.querySelector('.other');
     oth.classList.add('width75');
    //changes by Rahul 
}
// send selected lookup record to parent component using custom event
lookupUpdatehandler(value){    
    const oEvent = new CustomEvent('lookupupdate',
    {
        'detail': {selectedRecord: value}
    }
);
this.dispatchEvent(oEvent);
}
showPromptForNoData(){
    const eventt = new ShowToastEvent({
        title: 'To add a new value, please contact your sector business partner.',
        //  message:'',
        variant: 'warning'
    });
    this.dispatchEvent(eventt);
}
}