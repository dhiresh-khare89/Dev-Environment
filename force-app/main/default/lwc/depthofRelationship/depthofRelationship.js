import { LightningElement, track, wire } from 'lwc';
import getAccountAndRelatedContacts from '@salesforce/apex/depthofRelationshipApexLWC.getClientContact';
import searchAccounts from '@salesforce/apex/depthofRelationshipApexLWC.getClientContact';
import { refreshApex } from '@salesforce/apex';
const columnList = [
    {label: 'Action', type: 'button-icon', fieldName: 'Id',
        typeAttributes : {iconName : 'utility:preview', name : 'preview'}
    },    
    {label : 'Account Name', fieldName : 'Name', type: 'text', sortable: true},
    {label : 'Account Type', fieldName : 'Type', type: 'text', sortable: true},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Industry', fieldName : 'Industry', type: 'text', sortable: true},
    {label : 'Website', fieldName : 'Website'},
];

export default class DispExtDataOnAccDepthofRelationshipountSearch1 extends LightningElement {
    
    //For icons
    @track showDetails = false;
    @track showRightBtn = true;
    @track showDownbtn = false;

    @track currentAccountName;
    @track searchAccountId;

    //For account
    @track accountList = [];    
    @track accountError;
    @track columnList = columnList;
    @track accountData = true;
    @track dataNotFoundForAccount;

    //For Contact data
    @track contactsData = [];
    @track dataNotFoundForExtContact;
    @track extContactData = false;

    handleChangeAccName(event){
        this.currentAccountName = event.target.value;   
        const keySearch = event.target.value;

        if(keySearch) {
            searchAccounts({keySearch})
            .then(result => {
                this.accountList = result;
                this.accountError = undefined;
                this.accountData = true;                          
                this.dataNotFoundForAccount = '';
                if(this.accountList == ''){
                    this.accountData = false; 
                    this.dataNotFoundForAccount = 'There is Account found with Searched name';
                }        
            })
        }else {
            this.accountError = error;
            this.accountList = undefined; 
            this.accountData = false;          
        } 
      }
    
    //For related data
    @wire (getAccountAndRelatedContacts, {accountId : '$accountId'}) 
    wireRecord(result){
        const { data, error } = result;
        if(data){         
            this.contactsData = data; 
            console.log('con:'+this.contactsData);
            this.error = undefined;
            this.dataNotFoundForExtContact = '';
            if(this.contactsData == ''){
                this.extContactData = false; 
                this.dataNotFoundForExtContact = 'There is no Contact found related to Account name';
            }        
            
        }else{
            this.error = error;
            this.contactsData = undefined;
        }
    }

    handleRowAction( event ) {
        if (event.detail.action.name === 'preview') {
            this.searchAccountName = this.currentAccountName;
            this.extContactData = true;
        }        
    }
}