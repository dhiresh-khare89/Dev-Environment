import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccount from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoMap';
import { CloseActionScreenEvent } from 'lightning/actions';
import clientNewSearchByName from '@salesforce/apex/capIQButtontoUpdateClient.ClientNewSearchByName';
import clientNewSearchId from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchId';
import updateCompetitor from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoCompetitor';
//import getCompanyName from '@salesforce/apex/capIQButtontoUpdateClient.ClientNewSearchByName';
import updateNewClient from '@salesforce/apex/capIQButtontoUpdateClient.sendCapIQIdtoNewClient';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Lead.FirstName';
import LastNAME_FIELD from '@salesforce/schema/Lead.LastName';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import ExternalDataSource_FIELD from '@salesforce/schema/Lead.External_Database_Source__c';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import userId from '@salesforce/user/Id';
import EnrichDataFromExternalDB_AuthorizationMsg_Body from '@salesforce/label/c.EnrichDataFromExternalDB_AuthorizationMsg_Body';
import EnrichDataFromExternalDB_AuthorizationMsg_Header from '@salesforce/label/c.EnrichDataFromExternalDB_AuthorizationMsg_Header';
import EnrichDataFromExternalDB_ErrorMsg_Body from '@salesforce/label/c.EnrichDataFromExternalDB_ErrorMsg_Body';


const FIELDS = ['Lead.capIQId__c', 'Lead.FirstName', 'Lead.LastName', 'Lead.Status', 'Lead.SectorCoordinator__c' , 'Lead.Company', 'Lead.External_Database_Source__c'];
const COLS = [
    { label: 'New Client Name', fieldName: 'Name', type: 'text', wrapText: true },
    {
        type: "button", typeAttributes: {
            label: 'Select',
            name: 'View',
            title: 'View',
            disabled: false,
            value: 'view',
            iconPosition: 'left'

        }
    }
];

export default class CapIQButton extends LightningElement {
    @track ifUpdated = false;
    @api recordId;
    @api objectApiName;
    @api flexipageRegionWidth;
    @track show = true;
    @track ifFirstNameNotAvailable = false;
    @track dataResult = false;
    @track ifYes = false;
    @track ifData = false;
    @track companyNameChange;
    @track companyNameChangeOld;
    @track arrDataList = [];
    @track comapnyNameLength = true;
    @track showButton = false;
    prfName;
    showComp =false;
    showErrorMessage1= false;
    showErrorMessage2= false;
    headerMsg = EnrichDataFromExternalDB_AuthorizationMsg_Header;
    errMsg1 = EnrichDataFromExternalDB_ErrorMsg_Body;
    errMsg2 = EnrichDataFromExternalDB_AuthorizationMsg_Body;
    capIqId = '';
    @track capIq;
    showUpdatedScreen = false;
    firstName;
    companyName;
    lastName;
    cols = COLS;
    showSpinner = false; //Added by AK
    showSpinner1 = true;

    @api callFromParent(paremt1) {
        console.log('RecordId InSide LWC :', paremt1);
        this.recordId = paremt1;


    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            console.log('Wired data : ', data);
            console.log('capIq data : ', data.fields.capIQId__c.value);
            console.log('sectorCoordintaor : ', data.fields.SectorCoordinator__c.value);
            console.log('First Name : ', data.fields.FirstName.value);
            console.log('userId : ' , userId);
            if (data.fields.Status.value === 'NotAccept'){
                
                this.showErrorMessage1 = true;
                this.showErrorMessage2 = false;
                this.showSpinner1 = false;
            }
            else{
                if(data.fields.SectorCoordinator__c.value === userId || this.prfName === 'System Administrator'){
                    this.showComp = true;
                    
                }
                else{
                    this.showErrorMessage2 = true;
                    this.showErrorMessage1 = false;
                }
                this.showSpinner1 = false;
            }

            this.lastName = data.fields.LastName.value;
            this.companyName = data.fields.Company.value;
            this.companyNameChangeOld = this.companyName;
            if (data.fields.FirstName.value == null) {
                this.ifFirstNameNotAvailable = true;
            }
            if (data.fields.capIQId__c.value !== null) {
                this.showUpdatedScreen = true;
                console.log('Val1 : ', this.showUpdatedScreen);
            }
            else if (data.fields.capIQId__c.value === null) {
                this.showUpdatedScreen = false;
                console.log('Val2 : ', this.showUpdatedScreen);
            }
        }
        else if (error) {
            console.log('Error : ', error);
        }
    }

    @wire(getRecord, {
        recordId: userId,
        fields: [PROFILE_NAME_FIELD]
    }) wireuser({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.prfName = data.fields.Profile.value.fields.Name.value;
            if (this.prfName == 'System Administrator') {
                // this.showComp = true;
            }
            console.log(' this.prfName : ', this.prfName);
        }
    }
    async handleRowAction(event) {
        console.log('HandleRowAction ---> ', event.detail.row.Name);
        this.showSpinner = true; //Added BY AK
        this.companyName = event.detail.row.Name;
        await clientNewSearchId({ companyName: this.companyName })
            .then((result) => {
                this.capIq = result;
                if (result == 'Data Unavailable') {
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                }
                console.log('capIQ ID --->', this.capIq);
            }).catch((error) => {
                console.log("250 an error has occured :  ", error);
            })
        updateNewClient({ recordId: this.recordId, capIqId: this.capIq })
            .then((result) => {

                console.log('capIQ ID --->', result);
                if (result) {
                    this.ifUpdated = true;
                    this.dataResult = true;
                    this.ifYes = false;
                    this.ifData = false;
                } else {
                    this.ifUpdated = true;
                    this.dataResult = false;
                    this.ifYes = false;
                    this.ifData = false;
                }
                this.showSpinner = false;//Added By AK
            }).catch((error) => {
                this.showSpinner = false;//Added By AK
                console.log("95 an error has occured :  ", error.message);
            })

    }

    fieldValidation() {
        try {
            let isValid = true;

            let inputFields = this.template.querySelectorAll('.validate');
            console.log('InputFields : ', inputFields);
            inputFields.forEach(inputField => {
                if (!inputField.checkValidity()) {
                    inputField.reportValidity();
                    isValid = false;
                }
                this.objInsurance[inputField.name] = inputField.value;
            });
            return isValid;
        } catch (error) {
            console.log('Error : ', error);
        }
    }

    getFirstName(event) {
        //this.firstName=event.target.value;
        NAME_FIELD.FirstName = event.target.value;
        this.firstName = event.target.value;
        console.log('First Name : ', this.firstName);
    }

    getLastName(event) {
        LastNAME_FIELD.LastName = event.target.value;
        this.lastName = event.target.value;
        console.log('Last Name : ', this.lastName);
    }

    updateFirstNameButton(event) {
        console.log('clicked and this.firstName : ', this.firstName);
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[NAME_FIELD.fieldApiName] = this.firstName;
        fields[LastNAME_FIELD.fieldApiName] = this.lastName;
        const recordInput = { fields };
        console.log('fileds : ', fields);
        // console.log('this.firstName.trim() ',this.firstName.trim());
        if (this.firstName) {
            if (this.firstName.trim()) {
                updateRecord(recordInput)
                    .then(() => {
                        //this.dispatchEvent(new CloseActionScreenEvent()); 
                        this.showUpdatedScreen = true;
                        this.ifFirstNameNotAvailable = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'First Name updated',
                                variant: 'success'
                            })
                        );

                    })
                    .catch(error => {
                        console.log('error : ', error);
                    })
            }


        }

        if (this.firstName == undefined || this.firstName == null || this.firstName.trim() < 1) {
            console.log('first name  : ', this.firstName);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Required',
                    message: 'Please fill First Name',
                    variant: 'warning'
                })
            );
        }
        else if (this.lastName == '' || this.lastName == null || this.lastName.trim() < 1) {
            this.dispatchEvent(

                new ShowToastEvent({
                    title: 'Required',
                    message: 'Please fill Last Name',
                    variant: 'warning'
                })
            );
            //window.alert('Please fill First Name');
            console.log('Invalid');
        }

    }


    handleClick(event) {
        console.log('handle Click');
        this.companyName = this.companyNameChange;
        try {
            clientNewSearchByName({ searchString: this.companyName })
                .then((data) => {
                    if (data) {
                        if (data == 'Data Unavailable') {
                            this.ifUpdated = true;
                            this.dataResult = false;
                            this.ifYes = false;
                            this.ifData = false;
                        } else {
                            console.log(data);
                            let arrDataListTemp = [];
                            for (let x in data) {
                                let arrData = {};
                                arrData.Name = data[x];
                                arrDataListTemp.push(arrData);
                            }
                            this.arrDataList = arrDataListTemp;
                            //this.companylist = data;
                            this.error = undefined;

                            //console.log('811 company List',JSON.stringify(this.companylist));
                            //console.log('this.data.length',this.arrDataList.length);
                            if (this.arrDataList.length == 0) {
                                console.log('this.arrDataList ---> ', this.arrDataList.length);
                                const fields = {};
                                fields[ID_FIELD.fieldApiName] = this.recordId;
                                fields[ExternalDataSource_FIELD.fieldApiName] = 'None';
                                const recordInput = { fields };
                                updateRecord(recordInput)
                                    .then(() => {
                                        console.log('Update External Data Source');

                                    })
                                    .catch(error => {
                                        console.log('error : ', error);
                                    })
                                this.ifUpdated = true;
                                this.dataResult = false;
                                this.ifYes = false;
                                this.ifData = false;

                            } else {
                                this.ifData = true;
                                console.log('191 this.arrDataList ---> ', this.arrDataList.length);
                            }
                        }
                    }
                    else if (error) {
                        this.error = error;
                        //this.companylist = 'Its';
                        if (this.arrDataList.length == 0) {
                            console.log('this.handleMCA');
                        }
                    }
                })

        } catch (e) {
            console.log('Error', e);
            if (this.arrDataList.length == 0) {
                console.log('this.handleMCA');
            }
        }
    }
    handleChange(event) {
        this.ifData = false;
        this.companyNameChange = event.target.value;
        this.companyNameChange = this.companyNameChange.replace(/^\s+|\s+$/gm,'');
        if(this.companyNameChange != this.companyNameChangeOld){
            this.showButton = true;
        }
        else{
            this.showButton = false;
        }
        if(this.companyNameChange.length < 3){
            this.showButton = false;
            this.comapnyNameLength = false;
        }else{
            this.comapnyNameLength = true;
        }
        console.log('this.companyName  Old --->>> ', this.companyNameChangeOld);
        console.log('this.companyName New  --->>> ', this.companyNameChange);
    }
    giveCompany(event) {
        this.ifYes = true;
        this.showUpdatedScreen = true;
        this.show = false;
    }
    refreshPage() {

        this.dispatchEvent(new CloseActionScreenEvent());
        setTimeout(() => {
            eval("$A.get('e.force:refreshView').fire();");

        }, 1000);
        console.log('page refreshed!!');
        var dataToSend = 'trnsfer';
        const sendDataEvent = new CustomEvent('callLWC', {
            detail: { dataToSend }
        });

        //Actually dispatching the event that we created above.
        this.dispatchEvent(sendDataEvent);
        console.log('page refreshed!!309');

    }
}