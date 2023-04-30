import { LightningElement, track } from 'lwc';

export default class EngagementPartnerAndLeaderInPursuit extends LightningElement {
    @track isOpenForm = false;
    @track showData = false;
    handleOpenForm(){
      this.isOpenForm = true;
    }

    closeOpenForm(){
        this.isOpenForm = false;
        this.showData = true;
    }
}