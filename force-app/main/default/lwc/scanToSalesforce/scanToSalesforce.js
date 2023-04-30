import { LightningElement, api, track ,wire} from 'lwc';
import { NavigationMixin,CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ScanToSalesforce_Title_Error_Msg from '@salesforce/label/c.Scan2SFDC_ErrorMsg_Title';
import ScanToSalesforce_Body_Error_Msg from '@salesforce/label/c.Scan2SFDC_ErrorMsg_Body';

const { userAgent } = navigator;

export default class ScanToSalesforce extends NavigationMixin(LightningElement) {
    @api prop2;
    @api prop1;
    
     //temp=1;
    @track properties;
    
    constructor() {
        super();
        console.log('Constructor');
    }
    // @wire(){
    //     alert('Inside The Wire');
    // }
    @wire(CurrentPageReference) // this is added to the remove Cache data W-001112
    renderedCallback(CurrentPageReference) {    
        
            
            var agent = navigator.platform;
            console.log('agent', agent);
            //alert(navigator.platform);
            if (navigator.platform == 'Win32') {
                console.log('agent :', agent);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: ScanToSalesforce_Title_Error_Msg,
                        message: ScanToSalesforce_Body_Error_Msg,
                        variant: 'error'
                    })

                );
                //redirectRecentListView();
                try{
                    

                    this[NavigationMixin.Navigate]({
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: 'Lead',
                            actionName: 'list'
                        },
                        state: {
    
                            filterName: 'Recent'
                        }
                    });
                    // setTimeout(() => {
                    //     location.reload();
                           
                    // }, 4000); 
                }
                catch(error){
                    console.log('navigation error : ' , error);
                }

            }
            else if(navigator.platform=='MacIntel'){
                console.log('agent :', agent);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: ScanToSalesforce_Title_Error_Msg,
                        message: ScanToSalesforce_Body_Error_Msg,
                        variant: 'error'
                    })

                );
                try{

                    this[NavigationMixin.Navigate]({
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: 'Lead',
                            actionName: 'list'
                        },
                        state: {
    
                            filterName: 'Recent'
                        }
                    });
                    // setTimeout(() => {
                    //     location.reload();
                           
                    // }, 4000); 
                }
                catch(error){
                    console.log('navigation error : ' , error);
                }
            }
            else if (navigator.platform == 'iPhone'){
                
               
                    //alert('--->>>eneterd');
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            //url: 'ms-outlook://'
                            url: 'https://apps.apple.com/in/app/scan-to-salesforce-pardot/id1442743563'
                            //url: 'https://play.google.com/store/apps/details?id=com.sansan.scantosalesforce'

                        }
                    });
                    //temp=2;
                    try{

                        this[NavigationMixin.Navigate]({
                            type: 'standard__objectPage',
                            attributes: {
                                objectApiName: 'Lead',
                                actionName: 'list'
                            },
                            state: {
        
                                filterName: 'Recent'
                            }
                        });
                        // setTimeout(() => {
                        //     location.reload();
                               
                        // }, 4000); 
                    }
                    catch(error){
                        console.log('navigation error : ' , error);
                    }
            }
            else {
                
                // if(temp==1){
                     //alert('--->>>eneterd');
                     this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            //url: 'ms-outlook://'
                            //url: 'https://apps.apple.com/in/app/scan-to-salesforce-pardot/id1442743563'
                            url: 'https://play.google.com/store/apps/details?id=com.sansan.scantosalesforce'




                        }
                    });
                    //temp=2;
                    try{

                        this[NavigationMixin.Navigate]({
                            type: 'standard__objectPage',
                            attributes: {
                                objectApiName: 'Lead',
                                actionName: 'list'
                            },
                            state: {
        
                                filterName: 'Recent'
                            }
                        });
                        // setTimeout(() => {
                        //     location.reload();
                               
                        // }, 4000); 
                    }
                    catch(error){
                        console.log('navigation error : ' , error);
                    }
          // }
            
                }
                   
        //alert('--->>>eneterd1');

    }
    
    
}