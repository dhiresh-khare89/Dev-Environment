/**
 * @description      :
 * @author           : Mohd Sameer Salmani
 * @group            :
 * @last modified on : 06-12-2022
 * @last modified by : Mohd Sameer Salmani
 **/
import { LightningElement, api } from 'lwc';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class ShowToastMessage extends LightningElement {
    @api message
    @api variant
    @api mode

    showToast(){
        const toastEvent = new ShowToastEvent({
            title: 'Record Saved!',
            message: this.message,
            variant: this.variant
        });
        this.dispatchEvent(toastEvent);
    }
}