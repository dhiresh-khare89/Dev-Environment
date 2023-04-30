import { LightningElement } from 'lwc';

export default class LookupDemo extends LightningElement {
  // handel custom lookup component event 
    lookupRecord(event){
        alert('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
    }

}