import { LightningElement, track, wire, api } from 'lwc';
import IMAGES from "@salesforce/resourceUrl/static_images";
//import companylist from '@salesforce/apex/newClientNew.ClientNewSearch';    //for api call results
import tempCompanylist from '@salesforce/apex/newClientNew.tempClientNewSearch';
import clientNewSearchByName from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchByName';
import clientNewSearchId from '@salesforce/apex/newClientByCompanyNameIQ.ClientNewSearchId';
import clientFieldDataCapIQ from '@salesforce/apex/newClientByCompanyNameIQ.clientDifferentField';
import clientFieldEntityDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchEnityData';
import clientFieldFinanceDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchFinanceData';
import clientFieldCorpFinanceDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchCorpFinanceData';
import clientNewSearchByNamemca from '@salesforce/apex/newClientDataFromMCA.newClientCompanySearchByName';
import clientFieldcurrentBoardMemberDataMCA from '@salesforce/apex/newClientDataFromMCA.newClientCompanyCrossDirectorShipCurrentData';
import checkduplicate from '@salesforce/apex/CheckDuplicateForNewClient.checkduplicate';
import industriesValues from '@salesforce/apex/dependancySectorWithSolution.PicklistValues';
import leadSourceValues from '@salesforce/apex/dependancySectorWithSolution.newClientSourcePicklistValues';

//import Experties from '@salesforce/apex/dependancySectorWithSolution.PicklistValues';
import NEW_CLIENT_OBJ_NAME from '@salesforce/schema/Lead';
// import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// import { createRecord } from 'lightning/uiRecordApi';
// import LastName_FIELD from '@salesforce/schema/Lead.LastName';
// import FirstName_FIELD from '@salesforce/schema/Lead.FirstName';
// import Email_FIELD from '@salesforce/schema/Lead.Email';
// import CountryCode_Field from '@salesforce/schema/Lead.CountryCode__c';
// import Company_Field from '@salesforce/schema/Lead.Company';
// import Phone_FIELD from '@salesforce/schema/Lead.MobilePhone';
// import Sector_FIELD from '@salesforce/schema/Lead.Sector__C';
import { NavigationMixin } from 'lightning/navigation';
//import NEW_CLIENTSTATUS_FIELD from '@salesforce/schema/Lead.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import CreateLead from '@salesforce/apex/CreateleadHelper.Createlead';
// By Ravi...
const Colume = [{ label: 'Client Name', fieldName: 'Name', type: 'text' }, { label: 'Owner Name', fieldName: 'Owner.Name', type: 'text' }, { label: 'Parent Name', fieldName: 'Parent.Name', type: 'text' }];
const COLS = [
    { label: 'Client Name', fieldName: 'Name', type: 'text', wrapText: true },
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
export default class ClientNew extends NavigationMixin(LightningElement) {
    // @track mp = new map(key,value);
    @track ifExternalData = false;
    @track searchCompany1;
    @track capIQ;
    @track mcaId;
    @track capIqCreatedBy = 'No';
    @track modifiedByCapIq;
    @track ifMcaCallout = false;
    @track mcaData = false;
    @track showCapIq = false;
    @track totalAssets;
    @track totalCurrentAssets;
    @track totalCL;
    @track totalDebt;
    @track totalEquity;
    @track totalLiab;
    @track employees;
    @track totalRev;
    @track ebit;
    @track companyStatus;
    @track ebitda;
    @track companyTickter;
    @track primarySIC;
    @track ceoName;
    @track iqULTParent;
    @track companyType;
    @track companyHQAddress;
    @track shortDescription;
    @track exchange;
    @track showexternalbutton = false;
    @track companyWebsite;
    @track longDescription;
    @track yearFounded;
    @track ifSearch = false;
    @track chairmanName;
    @track countryINC;
    @track iqRev;
    @track boardMember;
    @api searchCompany;
    @track searchString = '';
    @track companylist = '';
    @track companylists = [];
    @track companyEmail = '';
    @track companyMobilePhone = '';
    @track companyWebsite = '';
    @track companyHowCanWeHelpYou = '';
    @track companyExpertise = '';
    @track companySubSector = '';
    @track companySector = '';
    @track companySubExpertise = '';
    @track companyCorridor = '';
    @track companyCompanyHQ = '';
    @track companyAddress = '';
    @track companyChamber = '';
    @track companyClientName = '';
    @track companyLawFirmContacts = '';
    @track companyLawFirm = '';
    @track companyClientContact = '';
    @track companyInboundReferral = '';
    @track companyGTEmployee = '';
    @track countryCode = '';
    @track companySolution = '';
    @track isDisabed = true;
    @track isDisabedDuplicate = false;
    @track isShowModal = false;
    @track companySubsector = '';
    @track channelValue = '';
    @track street;
    @track city;
    @track state;
    @track companyZIP;
    @track country;
    isGTEmpDisabled = true;
    isInboundDisabled = true;
    isLowFirmDisabled = true;
    isClientContactDisabled = true;
    isChamberDisabled = true;
    isPEVCConDisabled = true;
    isPEVCDisabled = true;
    @track mapOfValues = [];
    @track PevcConRefVal = '';
    @track PevcRefVal = '';
    @track companyChambercontact = '';
    @track showParent = false;


    @track ifclick = false;
    fieldValueForValidation;

    @track searchString = '';
    companyListResult = [];

    @track options = [];
    value = '';

    @track showAccordians = false;
    @track showFields = true;
    @track showError = false;
    @track companyName = '';
    @track clientData;
    @track ifResult = false;
    @track ifExisting = false;
    newClientObjName = NEW_CLIENT_OBJ_NAME.objectApiName;
    @track isClientduplicate = false;
    @track companyCorridor = '';
    counter = 0;


    CountryNameValue = 'India';

    activeAccordionSections = ['details', 'companies', 'address', 'referralInfo', 'sectors'];
    ifData = false
    cols = COLS;
    colume = Colume;
    
    @track arrDataList = [];
    @track leadObject={
        FirstName:'',
        LastName:'',
        Sector__c:'',
        Email:'',
        Company:'',
        MobilePhone:'',
        countryCode__c:'',
        LeadSource:'Manual',
        State:'', 
        Street:'',
        City:'',
        PostalCode:'',
        Country:'',
        SubSector__c:'',
        Total_Assets__c:'',
        Total_Current_Assets__c:'',
        Total_Current_Liabilities__c:'',
        Total_Debt__c:'',
        Total_Equity__c:'',
        Total_Liabilities__c:'',
        Industry__c:'',
        CEO_Name__c:'',
        Global_Ultimate_Owner__c:'',
        Public_Private_Company__c:'',
        Ticker_Symbol__c:'',
        External_Database_Source__c:'None',
        Company_Status__c:'',
        Total_No_of_employees__c:'',
        Total_Revenue__c:'',
        Earnings_Before_Interest_and_Taxes_EBIT__c:'',
        EBITDA__c:'',
        Chairman_Name__c:'',
        Country_of_Incorporation__c:'',
        Board_of_Directors__c:'',
        MCA_ID__c:'',
        Stock_Exchange_symbol__c:'',
        Company_Website__c:'',
        Company_Overview__c:'',
        Year_Founded__c:'',
        Chairman_Name__c:'',
        Revenue__c:'',
        capIQId__c:'',
        LawFirm__c:'',
        Channel__c:'',
        InboundReferral__c:'',
        GTEmployee__c:'',
        Chamber_contacts__c:'',
        Chamber__c:'',
        InvestorsPrivateEquityFirms__c:'',
        Investors_Private_Equity_Firms__c:'',
        LawFirmContacts__c:'',
        ClientName__c:'',
        ClientContact__c:''


    };
    @track ListAllypes;
    @track TypeOptions;
    @track ListAllypesLeadSource;
    @track TypeOptionsLeadSource;
    isIndustrydisable=true;
    isClientContactDisabled=false;
    accountRecordID='';
    isLawFirm=false;
    isExistingClient=false;
    isChamberShow=false;
    isInvesterPrivate=false;
    isGtEmployee=false;
    isGtMemberFirm=false;

    @track recordTypeName='LawFirmIndependentDirectors';
    connectedCallback() {
        leadSourceValues()
        .then(data=>{
            if(data){
                try {
                    console.log('1204',data);
                    this.ListAllypesLeadSource = data; 
                    let options = [];
                    for (var key in data) {
                        options.push({ label: data[key].picklistlabel  , value: data[key].picklistvalue  });
                       
                    }
                        console.log('options',options);
                        this.TypeOptionsLeadSource = options;
                       
                     
                } catch (error) {
                    console.error('check error here', error);
                }

            }
        }) .catch(error => {
            console.log('1221',error)
        });
    }
    handleCompanyNameChange(event){
        this.isDisabed=true;
        this.isDisabedDuplicate=false;
    }
    handleCountryNameChange(event) {

        this.CountryNameValue = event.detail;
        //console.log('------>',event.detail);
    }
    exclamationImage = IMAGES + '/static_images/images/exclamation_1.png';

    // by Ravi  

    async callRowAction(event) {
        try {

            console.log('---->>> call ROw Action  this.searchString  <<<------');
            this.leadObject.Company = event.detail.row.Name;
            this.showAccordians = true;
            console.log('159  --->this.showAccordians', this.showAccordians);
            console.log('this.searchString ', this.searchString);
            if (this.searchString != '') {
                console.log(this.searchString);
                tempCompanylist({ searchString: this.searchString })
                    .then((result) => {
                        if (result.length > 0 && this.searchString != '') {
                            this.ifSearch = false;

                            let data = JSON.parse(JSON.stringify(result));
                            for (var i = 0; i < data.length; i++) {
                                data[i].rowNumber = i + 1;
                            }
                            this.clientData = data;

                            this.ifData = false;
                            this.ifResult = true;
                            this.ifclick = false;
                            //this.showAccordians = true;
                            this.companyName = this.searchString;
                            this.showError = false;
                        } else if (result.length > 0 && this.searchString == '') {
                            console.log('Step 2');
                            this.ifSearch = false;
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            //this.showAccordians = false;
                            this.companyName = this.searchString;
                            this.ifExisting = false;
                            this.ifclick = true;

                        } else if (result.length == 0) {
                            this.ifSearch = true;

                            console.log('Step 3', result.length);
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.showAccordians = true;
                            this.companyName = this.searchString;
                            this.ifExisting = true;
                            //this.showError = false;
                            this.ifclick = false;
                            console.log('<---204---->');
                        }

                    })
                    .catch((error) => {
                        console.log("212  an error has occured :  ", error);
                    })
            }
            else {
                this.ifSearch = false;
                this.ifData = false;
                this.ifResult = false;
                this.showAccordians = false;
                this.companyName = this.searchString;
                this.ifExisting = false;
                this.showError = false;
                this.ifSearch = false;
            }





            // this.searchString =  event.detail.row.Name; 
            console.log('--229----');
            console.log('this.searchString ', this.searchString);

            this.ifData = false;
            for (let x in this.mapOfValues) {
                if (this.mapOfValues[x].value == this.searchString) {
                    this.mcaId = this.mapOfValues[x].key;
                }
            }
            this.companyName = this.searchString;
            console.log('241  Company List ---->', JSON.stringify(this.companylist));
            //let mp = new map(JSON.stringify(this.companylist));
            //console.log('Map   --->',this.mp);
            if (this.ifMcaCallout == false) {
               await clientNewSearchId({ CompanyName: this.searchString })
                    .then((result) => {
                        this.leadObject.capIQId__c = result;
                        console.log('mca ',  this.leadObject.capIQId__c);
                    }).catch((error) => {
                        console.log("250 an error has occured :  ", error);
                    })
                    this.fatchDataFromExternalDataBase();
                //this.capIqCreatedBy = 'Yes';
                //this.modifiedByCapIq = '';
            }
            else if (this.ifMcaCallout == true) {
                console.log(this.mcaId);
                clientFieldFinanceDataMCA({ mcaId: this.mcaId })
                    .then((result) => {
                        console.log(result);
                        this.leadObject.eb= result[1];
                        this.leadObject.EBITDA__c = result[2];
                    }).catch((error) => {
                        console.log("263  an error has occured :  ", error);
                    })
                clientFieldCorpFinanceDataMCA({ mcaId: this.mcaId })
                    .then((result) => {
                        console.log(result);
                        this.leadObject.Total_Assets__c = result[0];
                        this.leadObject.Total_Current_Assets__c = result[1];
                        this.leadObject.Total_Equity__c = result[4];
                        this.leadObject.Total_Current_Liabilities__c = result[2]
                        this.leadObject.Total_Liabilities__c = result[5];
                        this.leadObject.Total_Revenue__c = result[7];
                    }).catch((error) => {
                        console.log("275 an error has occured :  ", error);
                    })
                clientFieldCorpFinanceDataMCA({ mcaId: this.mcaId })
                    .then((result) => {
                        console.log(result);
                        this.leadObject.Total_Assets__c = result[0];
                        this.leadObject.Total_Current_Assets__c = result[1];
                        this.leadObject.Total_Equity__c = result[4];
                        this.leadObject.Total_Current_Liabilities__c = result[2]
                        this.leadObject.Total_Liabilities__c = result[5];
                        this.leadObject.Total_Revenue__c = result[7];
                    }).catch((error) => {
                        console.log("287 an error has occured :  ", error);
                    })
                clientFieldcurrentBoardMemberDataMCA({ mcaId: this.mcaId })
                    .then((result) => {
                        console.log(result);
                        this.leadObject.Board_of_Directors__c = result[0];
                    }).catch((error) => {
                        console.log("294  an error has occured :  ", error);
                    })


                console.log('287');
            }
            console.log('298');



        }
        catch (e) {

        }
    }
    // ENd.....
    //for checking the length of mobile number
    handleMouseoutOnMobile(event) {
        let phoneField = this.template.querySelector('.phone_number__c');
        console.log('mobile on out ', event.target.value);
        let numberLength = event.target.value;
        console.log('length', numberLength.length);
        if (numberLength.length < 10 && numberLength.length >= 1 && this.countryCode == 'India (+91)') {
            phoneField.setErrors({ 'body': { 'output': { 'fieldErrors': { 'MobilePhone': [{ 'message': 'Mobile Number should be 10 Digits' }] } } } });

        }

    }
    handleMCAClick() {
        console.log(this.searchString);
        if (this.searchString != '') {
            this.ifclick = false;
            this.companyName = this.searchString;
            this.mcaData = true;
            //this.searchString = this.searchString +' '+this.CountryNameValue;
            console.log('this.searchString  ---->>', this.searchString);
            clientNewSearchByNamemca({ searchString: this.searchCompany1 })
                .then((data) => {
                    console.log(data);
                    if (data) {
                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            arrData.Name = data[x];
                            arrDataListTemp.push(arrData);
                            //mp.put(x,arrData.Name);
                        }
                        this.arrDataList = arrDataListTemp;
                        this.companylist = data;
                        for (let key in data) {
                            // Preventing unexcepted data
                            if (data.hasOwnProperty(key)) { // Filtering the data in the loop
                                this.mapOfValues.push({ value: data[key], key: key });
                            }
                        }

                        this.error = undefined;
                        console.log('351  company List', JSON.stringify(this.companylist));
                        this.ifMcaCallout = true;
                        console.log('353   this.arrDataList.length', this.arrDataList.length);
                        if (this.arrDataList.length == 0) {

                            this.showAccordians = true;
                            this.ifData = false;
                            this.ifExternalData = true;
                        } else {
                            this.ifData = true;
                            this.ifExternalData = false;
                        }
                    }
                    else if (error) {
                        this.error = error;
                        this.companylist = 'Its';
                        this.showAccordians = true;
                        this.ifData = false;
                        this.ifExternalData = true;
                    }
                }).catch((error) => {
                    console.log("360 an error has occured :  ", error);
                })
            // console.log('company 1',this.companylist.target);
            this.ifResult = false;
            //this.showAccordians = true;
            this.ifExisting = false;
            this.showError = false;
        }
        else {
            this.ifclick = true;
        }

    }
    handleNewClientSource(event) {
        if (event.target.value != this.channelValue) {

            let source = event.target.value;
            console.log(source);
            if (source == "Law Firm") {

                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = false;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "Existing Client") {

                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;


                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = false;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "GT Employee") {

                this.companyInboundReferral = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = false;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            } else if (source == "GT Member Firms") {

                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;



                this.isGTEmpDisabled = true;
                this.isInboundDisabled = false;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;



            } else if (source == "Chamber") {

                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = false;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;



            }
            else if (source == "Investors / Private Equity Firms") {
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;

                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = false;
                this.isPEVCDisabled = false;


            } else {
                console.log('hi else', this.companyGTEmployee)
                this.companyInboundReferral = null;
                this.companyGTEmployee = null;
                this.PevcConRefVal = null;
                this.PevcRefVal = null;
                this.companyChambercontact = null;
                this.companyChamber = null;
                this.companyLawFirmContacts = null;
                this.companyLawFirm = null;
                this.companyClientContact = null;
                this.companyClientName = null;
                console.log('hi else after', this.companyGTEmployee)


                this.isGTEmpDisabled = true;
                this.isInboundDisabled = true;
                this.isLowFirmDisabled = true;
                this.isClientContactDisabled = true;
                this.isChamberDisabled = true;
                this.isPEVCConDisabled = true;
                this.isPEVCDisabled = true;


            }

        }
    }
    handleNewClientSourceClick(event) {
        let source = event.target.value;
        if (source != 'Law Firm' && source != 'Investors / Private Equity Firms' && source != 'Chamber' && source != 'Visiting card' && source != 'GT Member Firms' && source != 'GT Employee' && source != 'Existing Client') {

            this.companyInboundReferral = null;
            this.companyGTEmployee = null;
            this.PevcConRefVal = null;
            this.companyLawFirm = null;
            this.PevcRefVal = null;
            this.companyChambercontact = null;
            this.companyChamber = null;
            this.companyClientContact = null;
            this.companyClientName = null;

            this.isGTEmpDisabled = true;
            this.isInboundDisabled = true;
            this.isLowFirmDisabled = true;
            this.isClientContactDisabled = true;
            this.isChamberDisabled = true;
            this.isPEVCConDisabled = true;
            this.isPEVCDisabled = true;
        }

    }
    handleClientClick(event) {
        console.log(event.currentTarget.dataset.id);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Account',
                actionName: 'view'
            }
        })

    }
    handleexpertychange(event) {
        this.isDisabed = true;
        this.isDisabedDuplicate = false;
        this.companyExpertise = event.target.value;
        console.log('companyExpertise', this.companyExpertise);
    }
    handlesubexperties(event) {
        this.isDisabed = true;
        this.isDisabedDuplicate = false;
        this.companySubExpertise = event.target.value;
        console.log('companySubExpertise', this.companySubExpertise);
    }

    fatchDataFromExternalDataBase() {
        this.isDisabed = true;
        this.isDisabedDuplicate = false;
       // this.companySolution = event.target.value;
        console.log('companySolution', this.leadObject.capIQId__c);
        clientFieldDataCapIQ({ companyId:  this.leadObject.capIQId__c})

            .then((result) => {

                console.log(result,);
                this.leadObject.Total_Assets__c= result[0];
                console.log('679', this.leadObject.Total_Assets__c);
                this.leadObject.Total_Current_Assets__c = result[1];
                this.leadObject.Total_Current_Liabilities__c= result[2];
                this.leadObject.Total_Debt__c = result[3];
                this.leadObject.Total_Equity__c = result[4];
                this.leadObject.Total_Liabilities__c = result[5];
                this.leadObject.Total_No_of_employees__c = result[6];
                this.Total_Revenue__c = result[7];
                this.leadObject.Earnings_Before_Interest_and_Taxes_EBIT__c = result[8];
                this.leadObject.EBITDA__c = result[9];
                this.leadObject.Ticker_Symbol__c = result[10];
                this.leadObject.Industry__c = result[11];
                this.leadObject.CEO_Name__c = result[12];
                this.leadObject.Global_Ultimate_Owner__c = result[13];
                this.leadObject.Public_Private_Company__c = result[14];
                //this.shortDescription = result[15];
                this.leadObject.Stock_Exchange_symbol__c= result[16];
                this.leadObject.Company_Website__c = result[17];
                this.leadObject.Company_Overview__c = result[18];
                this.leadObject.Year_Founded__c = result[19];
                this.leadObject.Chairman_Name__c = result[20];
                this.leadObject.Country_of_Incorporation__c = result[21];
                this.leadObject.Revenue__c = result[22];
                this.leadObject.Board_of_Directors__c = result[23];
                // this.street = result[24];
                // this.city = result[25];
                // this.state = result[26];
                // this.companyZIP = result[27];
               
            })
    }

    handleEnter(event) {
        console.log('CHECK', event.keyCode);
        if (event.keyCode === 13) {
            this.handleClick();
        }
    }
    handleCreateEnquiry(event) {
        try{

      
        const defaultValues = encodeDefaultFieldValues({
            Client__c: event.currentTarget.dataset.id

        });

        console.log(defaultValues);

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'IntegratedEnquiry__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
        console.log('line 666');
    }catch(e){
           console.log('671',e); 
    }
    }

    // onchange fuction for company name input
    handleChange(event) {
        this.isDisabed=true;
        this.isDisabedDuplicate=false;
        this.showexternalbutton = false;
        this.ifExternalData = false;
        console.log('hello ', this.searchString);
        if (event.target.value != ' ' && event.target.value != null) {
            this.searchString = event.target.value;
            this.leadObject.Company=event.target.value;

            if (this.searchString != '') {

                console.log(this.searchString);
                tempCompanylist({ searchString: this.searchString })
                    .then((result) => {
                        if (result.length > 0 && this.searchString != '') {

                            this.ifSearch = false;
                            console.log('line 642 ', JSON.stringify(result));
                            let data = JSON.parse(JSON.stringify(result));
                            for (var i = 0; i < data.length; i++) {

                                data[i].rowNumber = i + 1;

                                if (data[i].ParentId != undefined || data[i].ParentId != null) {
                                    console.log('inside null');
                                    this.showParent = true;
                                    data[i].ShowParent = true;
                                } else {
                                    data[i].ShowParent = false;
                                }
                            }
                            console.log('657 ', JSON.stringify(data));
                            this.clientData = data;
                            this.ifData = false;
                            this.ifResult = true;
                            this.ifclick = false;
                            this.showexternalbutton = false;
                            //this.showAccordians = true;
                            this.leadObject.Company = this.searchString;
                            this.showError = false;
                        } else if (result.length > 0 && this.searchString == '') {
                            console.log('Step 2');
                            this.ifSearch = false;
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.showAccordians = false;
                            this.leadObject.Company = this.searchString;
                            this.ifExisting = false;
                            this.ifclick = true;
                            this.showexternalbutton = false;

                        } else {
                            this.ifSearch = true;

                            console.log('Step 3');
                            this.clientData = '';
                            this.ifData = false;
                            this.ifResult = false;
                            this.ifclick = false;
                            this.showexternalbutton = true;
                            //this.showAccordians = true;
                            this.leadObject.Company = this.searchString;
                            this.ifExisting = true;
                            this.showError = false;
                        }

                    })
                    .catch((error) => {
                        console.log("714 an error has occured :  ", error);
                    })
            }
            else {
                this.ifSearch = false;
                this.ifData = false;
                this.ifResult = false;
                this.showAccordians = false;
                this.leadObject.Company = this.searchString;
                this.ifExisting = false;
                this.showError = false;
                this.ifSearch = false;
            }

        }


        this.companyListResult = [];
        console.log('   -----   ');
        this.companyEmail = '';
        this.companySubsector = '';
        this.companyExpertise = '';
        this.companyHowCanWeHelpYou = '';
        this.companyWebsite = '';
        this.companyMobilePhone = '';
        this.companySubSector = '';
        this.companySector = '';
        this.companyCorridor = '';
        this.companySubExpertise = '';
        this.companyAddress = '';
        this.companyCompanyHQ = '';
        this.companyChamber = '';
        this.companyClientName = '';
        this.companyGTEmployee = '';
        this.companyInboundReferral = '';
        this.companyClientContact = '';
        this.companyLawFirm = '';
        this.companyLawFirmContacts = '';
        this.countryCode = '';
       

    }
    handleCountryCodeChange(event) {
        this.countryCode = event.detail.value;
    }
    inputchange = (e) => {
        console.log('hiiiiiiiiii');
        let ph = this.template.querySelector('.phone_number__c');
        console.log('hiiiiiiiiii', ph);
        if (e.target.value.length > 10 && this.leadObject.countryCode__c == 'India (+91)') {
           // ph.setErrors({ 'body': { 'output': { 'fieldErrors': { 'MobilePhone': [{ 'message': 'Mobile Number should be 10 Digits' }] } } } });
           // return
        }
        let condition = this.validAlphabetLetter(e.target.value);
        console.log('e.target.value', e.target.value);
        if (!condition) {
          //  ph.setErrors({ 'body': { 'output': { 'fieldErrors': { 'MobilePhone': [{ 'message': 'Only Numbers Are Allowed' }] } } } });
        }
    }
    validAlphabetLetter = (l) => {
        let check = true;
        let checkvalidation = true;
        let arrayofphonefield = Array.from(l);
        arrayofphonefield.forEach(dig => {
            checkvalidation = /^[0-9]$/.test(dig);

            if (checkvalidation == false) {
                check = false;
            }
        });
        return check;
    }


    handleClick() {

        try {
            this.searchCompany1 = this.searchString + ' ' + this.CountryNameValue;
            clientNewSearchByName({ searchString: this.searchCompany1 })
                .then((data) => {
                    if (data) {
                        let arrDataListTemp = [];
                        for (let x in data) {
                            let arrData = {};
                            arrData.Name = data[x];
                            arrDataListTemp.push(arrData);
                        }
                        this.arrDataList = arrDataListTemp;
                        this.companylist = data;
                        this.error = undefined;
                        //console.log('811 company List',JSON.stringify(this.companylist));
                        //console.log('this.data.length',this.arrDataList.length);
                        if (this.arrDataList.length == 0) {
                            console.log('this.handleMCA');
                            this.handleMCAClick();
                        } else {
                            this.ifData = true;

                        }
                    }
                    else if (error) {
                        this.error = error;
                        this.companylist = 'Its';
                        if (this.arrDataList.length == 0) {
                            console.log('821 this.handleMCA');
                        }
                    }
                })

        } catch (e) {
            console.log('Error', e);
            if (this.arrDataList.length == 0) {
                console.log('829 this.handleMCA');
            }
        }
        this.showexternalbutton = false;
        //console.log('825  this.data.length',this.arrDataList.length);
    }

    handleComboxChange(event) {
        this.value = event.detail.value;
        console.log('value', this.value);
        console.log('aa', this.companyListResult[this.value]);

        clientNewSearchByName({ company: this.companyListResult[this.value] })
            .then((result) => {
                console.log('result from combox api', result);
            })
            .catch((error) => {
                console.log('eror from combobox api', error);
            })
    }
    async handleduplicate(event) {
        await checkduplicate({ solution: this.companySolution, experty: this.companyExpertise, subexperty: this.companySubExpertise, Company: this.companyName })
            .then(result => {
                console.log('result', result);
                if (!result[1]) {
                    const eventt = new ShowToastEvent({
                        title: 'There is no duplicate record',
                        //  message:'',
                        variant: 'success'
                    });
                    this.dispatchEvent(eventt);
                }

                this.isShowModal = result[1];
                this.isClientduplicate = result[0];
                this.isDisabed = false;
                this.isDisabedDuplicate = true;
            })
    }
    handleno() {
        this.isShowModal = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'list'
            },
            state: {

                filterName: 'All_Open_New_Clients',
            }

        });
        eval("$A.get('e.force:refreshView').fire();");
    }
    handleyes() {
        this.isShowModal = false;
        this.isDisabed = false;
        this.template.querySelector('.selfclick').click();

    }
    hideModalBox() {
        this.isDisabed = true;
        this.isDisabedDuplicate = false;
        this.isShowModal = false;

    }
    handleSubmit(event) {

        console.log('hi');
        const eventt = new ShowToastEvent({
            message: 'New client record created successfully.',
            variant: 'success'
        });
        this.dispatchEvent(eventt);
        console.log('hi');
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'list'
            },
            state: {

                filterName: 'All_Open_New_Clients',
            }

        });
        eval("$A.get('e.force:refreshView').fire();");

    }
    handleError(evt) {
        console.log('error', JSON.stringify(evt));
        console.log('error', JSON.parse(JSON.stringify(evt)));
        console.log('validastion : ', JSON.parse(JSON.stringify(evt)).detail.output.fieldErrors.Name[0].message);

         let showFirstNameValidation = JSON.parse(JSON.stringify(evt)).detail.output.fieldErrors.Name[0].message;

         if(showFirstNameValidation){

            //let FNameField = this.template.querySelector('.fNameField');
           // FNameField.setErrors({ 'body': { 'output': { 'fieldErrors': { 'Name': [{ 'message': 'Please Enter First Name' }] } } } });
             
           let attachmentPoint = this.template.querySelector('div[ishtmlcontainer=true]');
               attachmentPoint.innerText = 'Please Enter First Name';
            const test = new ShowToastEvent({
                title: 'First Name is mandatory',
                variant:'error',
               message:
                    'First Name npot filled',
            });
             this.dispatchEvent(test);
         }


        if (this.isClientduplicate) {
            const event = new ShowToastEvent({
                title: 'Client Exist',
                variant: 'error',
                message:
                    'Record already Exist, Kindly close the New Client and create an Enquiry against the client account',
            });
            this.dispatchEvent(event);
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Opportunity',
                    actionName: 'new'
                }
            });
            eval("$A.get('e.force:refreshView').fire();");
        } else {
            this.isDisabed = false;
            if (this.counter == 0) {
                this.counter++;
                this.template.querySelector('.selfclick').click();

            }

        }

    }
    handleValidation(event) {
        if (event.target.fieldName == 'MobilePhone') {
            console.log('first');
            var myReg = /[0-9]{10}/;
            console.log('second');
            var MyText = event.detail.value;
            console.log('3');
            var Result = MyText.match(myReg);
            console.log('4', Result);

        }
    }

    handleclicksubmit(event) {
       console.log('hi Submit');
        this.createLeadrecord();

    }
    handleCancel() {
        eval("$A.get('e.force:refreshView').fire();");
        this.showAccordians = false;
        this.companyListResult = [];
        console.log('   -----   ');
        this.companyEmail = '';
        this.companyExpertise = '';
        this.companyHowCanWeHelpYou = '';
        this.companyWebsite = '';
        this.companyMobilePhone = '';
        this.companySubSector = '';
        this.companySector = '';
        this.companyCorridor = '';
        this.companySubExpertise = '';
        this.companyAddress = '';
        this.companyCompanyHQ = '';
        this.companyChamber = '';
        this.companyClientName = '';
        this.companyGTEmployee = '';
        this.companyInboundReferral = '';
        this.companyClientContact = '';
        this.companyLawFirm = '';
        this.companyLawFirmContacts = '';
        this.countryCode = '';

    }
    handleLwaFirmContact(event) {

        this.companyLawFirmContacts = event.detail.value;

    }

    handleLwaFirm(event) {

        this.companyLawFirm = event.detail.value;
    }
    handleChamberContact(event) {
        this.companyChambercontact = event.detail.value;
    }
    handleChamber(event) {
        this.companyChamber = event.detail.value;
    }
    handlePEVCContact(event) {
        this.PevcConRefVal = event.detail.value;
    }
    handlePEVC(event) {
        this.PevcRefVal = event.detail.value;
    }

    handleGtFirm(event) {
        this.companyInboundReferral = event.detail.value;
    }
    handleGtEmployee(event) {
        this.companyGTEmployee = event.detail.value;
    }
    handleClientContact(event) {
        this.companyClientContact = event.detail.value;
    }
    handleClientName(event) {
        this.companyClientName = event.detail.value;
    }
    handleSelection(){
        
    }
    Fields={};
    handleLookUpChange(event){
       
        if(event.detail != null){
        if(this.leadObject.Channel__c=='Law Firm'){
            if(event.detail != null ){
                this.leadObject.LawFirm__c=event.detail.selectedRecord.Id;
              //  this.leadObject.LawFirmContacts__c=event.detail.selectedRecord.Id;

                this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }else  if(this.leadObject.Channel__c=='Investors / Private Equity Firms'){
            if(event.detail != null){
                this.leadObject.Investors_Private_Equity_Firms__c=event.detail.selectedRecord.Id;
              //  this.leadObject.InvestorsPrivateEquityFirms__c=event.detail.selectedRecord.Id;

                this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }else if(this.leadObject.Channel__c=='GT Employee'){
            if(event.detail != null){
                this.leadObject.GTEmployee__c=event.detail.selectedRecord.Id;
               // this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }else  if(this.leadObject.Channel__c=='Existing Client'){
            if(event.detail != null){
                this.leadObject.ClientName__c=event.detail.selectedRecord.Id;
               // this.leadObject.ClientContact__c=event.detail.selectedRecord.Id;
                this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }else  if(this.leadObject.Channel__c=='GT Member Firms'){
            if(event.detail != null){
                this.leadObject.InboundReferral__c=event.detail.selectedRecord.Id;
               // this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }else  if(this.leadObject.Channel__c=='Chamber'){
            if(event.detail != null){
                this.leadObject.Chamber__c=event.detail.selectedRecord.Id;
               // this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
                this.accountRecordID=event.detail.selectedRecord.Id;
            }
        }
    }
      
    }
  
    handleFieldChange(event){
        console.log('---->>'+ JSON.stringify(event.detail));
        var eventName=event.target.name;
        //console.log('event name name',eventName,event.detail.value);

        if(event.target.postalCode!='' || event.target.city!='' ||event.target.province!='' || event.target.country!=''  || event.target.street!=''){
            this.leadObject.City=event.target.city;
            this.leadObject.State=event.target.province;
            this.leadObject.Street=event.target.street;
            this.leadObject.PostalCode=event.target.postalCode;
            this.leadObject.Country=event.target.country;
        }
        switch(eventName){
            case 'Name':
                this.leadObject.FirstName=event.detail.value;
                break;
            case 'LName':
                this.leadObject.LastName=event.detail.value;
                break;
            case 'Company':
                this.leadObject.Company=event.detail.value;
                break;
            case 'Email':
                this.leadObject.Email=event.detail.value;
                    break;    
            case 'Country Code':
                this.leadObject.countryCode__c=event.detail.value;
                break;
            case 'leadSource':
                this.leadObject.Channel__c=event.detail.value;
                 if(event.detail.value=='Law Firm'){
                    this.isLawFirm=true;
                    this.isChamberShow=false;
                    this.isGtMemberFirm=false;
                    this.isExistingClient=false;
                    this.isGtEmployee=false;
                    this.isInvesterPrivate=false;

                 }else if(event.detail.value=='Investors / Private Equity Firms'){
                           this.isInvesterPrivate=true;
                           this.isLawFirm=false;
                           this.isChamberShow=false;
                           this.isGtMemberFirm=false;
                           this.isExistingClient=false;
                           this.isGtEmployee=false;
                         
                 }else if(event.detail.value=='GT Employee'){
                           this.isGtEmployee=true;
                           this.isLawFirm=false;
                           this.isChamberShow=false;
                           this.isGtMemberFirm=false;
                           this.isExistingClient=false;
                           this.isInvesterPrivate=false;
                 }else if(event.detail.value=='Existing Client'){
                          this.isExistingClient=true;
                          this.isLawFirm=false;
                          this.isChamberShow=false;
                          this.isGtMemberFirm=false;
                          this.isGtEmployee=false;
                          this.isInvesterPrivate=false;
                 }else if(event.detail.value=='GT Member Firms'){
                        this.isGtMemberFirm=true;
                        this.isLawFirm=false;
                        this.isChamberShow=false;
                        this.isExistingClient=false;
                        this.isGtEmployee=false;
                        this.isInvesterPrivate=false;
                 }else if(event.detail.value=='Chamber'){
                        this.isChamberShow=true;
                        this.isLawFirm=false;
                        this.isGtMemberFirm=false;
                        this.isExistingClient=false;
                        this.isGtEmployee=false;
                        this.isInvesterPrivate=false;
                 } 
                break;    
            case 'Mobile Phone':
                    this.leadObject.MobilePhone=event.detail.value;
                    this.inputchange(event);
                    break;  
            case 'Sector':
                console.log("Score value is 20");
                this.isIndustrydisable=true;
                this.leadObject.Sector__c=event.detail;
                if( this.leadObject.Sector__c=event.detail){
                    this.handleIndustryPiclistValues();
                }
                break;  
            case 'SubSector__c':
                this.leadObject.SubSector__c=event.detail.value;
                break;           
            default:
                console.log("error");
        }
        console.log('---->>'+ JSON.stringify(this.leadObject));
      
    }
    createLeadrecord() {
        console.log('inside submit');
      
        CreateLead({leadObject:JSON.stringify(this.leadObject)})
        .then(result => {
            console.log('Data:'+ JSON.stringify(result));
            this.handleSubmit(result);
        }) .catch(error => {
            console.log(error);
            this.error = error;
        }); 
        console.log('inside submit');

       
    }
    handleIndustryPiclistValues(event){
        console.log('1196');
        industriesValues({Sector: this.leadObject.Sector__c})
        .then(data=>{
            if(data){
                try {
                    console.log('1204',data);
                    this.ListAllypes = data; 
                    let options = [];
                    for (var key in data) {
                        options.push({ label: data[key].picklistlabel  , value: data[key].picklistvalue  });
                       
                    }
                        console.log('options',options);
                        this.TypeOptions = options;
                        this.isIndustrydisable=false;
                     
                } catch (error) {
                    console.error('check error here', error);
                }

            }
        }) .catch(error => {
            console.log('1221',error)
        });
    }
    handleChildData(event){
        console.log('child data : ' , event.detail);
  }
  handleLookUpContactChange(event){
    console.log(event.detail.selectedRecord);
    if(event.detail != null ){
    if(this.leadObject.Channel__c=='Law Firm'){
        if(event.detail != null){
          //  this.leadObject.LawFirm__c=event.detail.selectedRecord.Id;
              this.leadObject.LawFirmContacts__c=event.detail.selectedRecord.Id;
        }
    }else  if(this.leadObject.Channel__c=='Investors / Private Equity Firms'){
        if(event.detail != null){
            //this.leadObject.Investors_Private_Equity_Firms__c=event.detail.selectedRecord.Id;
            this.leadObject.InvestorsPrivateEquityFirms__c=event.detail.selectedRecord.Id;
        }
    }else  if(this.leadObject.Channel__c=='Existing Client'){
        if(event.detail != null){
            //this.leadObject.Client__c=event.detail.selectedRecord.Id;
            this.leadObject.ClientContact__c=event.detail.selectedRecord.Id;
           
        }
    }else  if(this.leadObject.Channel__c=='Chamber'){
        if(event.detail != null){
            //this.leadObject.Chamber__c=event.detail.selectedRecord.Id;
            this.leadObject.Chamber_contacts__c=event.detail.selectedRecord.Id;
          
        }
    }

  }
}
  
   
}