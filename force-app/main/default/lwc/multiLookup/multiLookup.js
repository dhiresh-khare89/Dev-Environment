import { LightningElement, api, wire, track } from 'lwc';
import getResults from '@salesforce/apex/lwcMultiLookupController.getResults';
import getSelectedAttendees from '@salesforce/apex/lwcMultiLookupController.getSelectedAttendees';
import updateAttendees from '@salesforce/apex/lwcMultiLookupController.updateAttendees';
// import AttendeesWrapper from '@salesforce/apex/AttendeesWrapper';

export default class MultiLookup extends LightningElement {
      @api objectName = 'User';
      @api fieldName = 'Name';
      @api Label;
      @track searchRecords = [];
      @track selectedRecords = [];
      @api required = false;
      @api iconName = ''
      @api LoadingText = false;
      @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
      @track messageFlag = false;
      @api eventId;
      @api userIds = [];
      @api userIdToSend = '';


      @wire(getSelectedAttendees, { eventId: '$eventId' })
      test({ data, error }) {
            if (data) {
                  console.log('Data : ', data);
                  data.forEach(element => {
                        this.selectedRecords.push({ 'recId': element.Id, 'recName': element.Name });
                        this.userIds.push(element.Id);
                        if (this.userIdToSend === '' || this.userIdToSend === null || this.userIdToSend === undefined) {
                              this.userIdToSend += element.Id;
                        }
                        else {

                              this.userIdToSend += ',' + element.Id;
                        }
                        this.sendUserIds();

                  });

            }
            else if (error) {
                  console.log('error : ', error);
            }
      }


      sendUserIds() {
            console.log('UserIds : ' , this.userIdToSend);
            updateAttendees({ eventId: this.eventId, attendeesIds: this.userIdToSend })
                  .then(result => {
                        console.log('Ids sent');

                  })
                  .catch(error => {
                        console.log('Error in sending ids : ', error);
                  })

      }


      searchField(event) {

            var currentText = event.target.value;
            var selectRecId = [];
            for (let i = 0; i < this.selectedRecords.length; i++) {
                  selectRecId.push(this.selectedRecords[i].recId);
            }
            this.userIds = selectRecId;
            this.LoadingText = true;
            getResults({ ObjectName: this.objectName, fieldName: this.fieldName, value: currentText, selectedRecId: selectRecId })
                  .then(result => {
                        this.searchRecords = result;
                        this.LoadingText = false;

                        this.txtclassname = result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
                        if (currentText.length > 0 && result.length == 0) {
                              this.messageFlag = true;
                        }
                        else {
                              this.messageFlag = false;
                        }

                        if (this.selectRecordId != null && this.selectRecordId.length > 0) {
                              this.iconFlag = false;
                              this.clearIconFlag = true;
                        }
                        else {
                              this.iconFlag = true;
                              this.clearIconFlag = false;
                        }
                  })
                  .catch(error => {
                        console.log('-------error-------------' + error);
                        console.log(error);
                  });


      }

      setSelectedRecord(event) {
            var recId = event.currentTarget.dataset.id;
            var selectName = event.currentTarget.dataset.name;
            let newsObject = { 'recId': recId, 'recName': selectName };
            this.userIds.push(recId);

            this.userIdToSend += ',' + event.currentTarget.dataset.id;
            this.sendUserIds();
            
            this.selectedRecords.push(newsObject);
            this.txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            let selRecords = this.selectedRecords;
            this.template.querySelectorAll('lightning-input').forEach(each => {
                  each.value = '';
            });
            const selectedEvent = new CustomEvent('selected', { detail: { selRecords }, });
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);

      }

      removeRecord(event) {
            try {
                  
                  let index = this.userIds.indexOf(event.target.name);

                  this.userIds.splice(this.userIds.indexOf(event.target.name), 1);

                  let str='';
                  this.userIds.forEach(element => {
                        if(str ==''){
                              str += element;
                        }
                        else{
                              str += ',' + element;
                        }
                  });
                  this.userIdToSend = str;
                  this.sendUserIds();
                  console.log('userIds after : ', this.userIds);


                  let selectRecId = [];
                  for (let i = 0; i < this.selectedRecords.length; i++) {
                        if (event.detail.name !== this.selectedRecords[i].recId)
                              selectRecId.push(this.selectedRecords[i]);
                  }
                  this.selectedRecords = [...selectRecId];
                  let selRecords = this.selectedRecords;
                  const selectedEvent = new CustomEvent('selected', { detail: { selRecords }, });
                  // Dispatches the event.
                  this.dispatchEvent(selectedEvent);
                  
            }
            catch (error) {
                  console.log('Error in removing record : ', error);
            }
      }

}