import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';


export default class RedirectToNewClientPage extends NavigationMixin(LightningElement) {
    tabName='New_Integrated_Enquiry';
    connectedCallback(){
      
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'New_client'
            }
        });

    }

}