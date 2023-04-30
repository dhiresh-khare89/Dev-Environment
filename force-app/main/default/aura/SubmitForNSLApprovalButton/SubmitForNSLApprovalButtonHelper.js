({
    helperMethod : function(component,event,helper) {
        debugger;
        //  alert('inside helper');
        var comments = component.get("v.myVal");
        var recId= component.get("v.recordId");
        var objectName = component.get("v.sObjectName");
        
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var newClientOwnerId = component.get("{!v.newClientRecord.OwnerId}");
        console.log('userId : ' + userId + ' and newClientOwnerId : ' + newClientOwnerId);
        var expertise = component.get("{!v.newClientRecord.Expertise__c}");
        var subExpertise = component.get("{!v.newClientRecord.SubExpertise__c}");
        var action = component.get("c.sendEnquiryApprovalRequest");
        action.setParams({ "recordId" : recId ,
                          "assignApproval": 'NSL_Approval',
                          "comments": comments});				
        // alert('after calling');
        action.setCallback(this,function(response){
            //alert('inside call back');
            var state = response.getState();
            // alert('Success');
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Sent Successfully",
                    duration:' 5000',
                    type: 'success'    
                });
                toastEvent.fire();
            }
        });
        console.log('expertise : ' + expertise + ' and sub exp : ' + subExpertise + ', object : ' + objectName);
        
        // if it is lead record page, then validate expertise/subexpertise
        if(objectName == 'Lead'){
            if(expertise == null || subExpertise == null){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please fill Expertise/Sub Expertise",
                    duration:' 5000',
                    type: 'error'    
                });
                toastEvent.fire();    
            }
            else if(comments == null || comments == ""){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please add comments",
                    duration:' 5000',
                    type: 'error'    
                });
                toastEvent.fire(); 
            }
            else if(userId != newClientOwnerId){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Only new client owner can submit for NSL approval",
                    duration:' 8000',
                    type: 'error'    
                });
                toastEvent.fire(); 
            }
            
            else{
                $A.enqueueAction(action);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }
        }
        // else no validation
        else{
            $A.enqueueAction(action);
            $A.get('e.force:refreshView').fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
        $A.get('e.force:refreshView').fire();
        
    }
})