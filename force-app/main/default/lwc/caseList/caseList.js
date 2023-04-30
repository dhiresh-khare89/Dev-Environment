import { LightningElement, wire } from 'lwc';
import getCaseList from '@salesforce/apex/caseslist.getCaseList';

const columns = [
    
    { label: 'Email', fieldName: 'SuppliedEmail', type: 'Email' },
    { label: 'Subject', fieldName: 'Subject', type: 'Text' },
    { label: 'Reason', fieldName: 'Reason', type: 'Text' },
];
export default class CaseList extends LightningElement {
    error;
    columns = columns;

    @wire(getCaseList)
    cases;
}