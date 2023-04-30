({
    clientCouncilhelper : function(component,helper) {
        var comments = component.get("v.myCCval");
        var recId= component.get("v.recordId");
        var action = component.get("c.sendEnquiryApprovalRequest");
        console.log('comments : ' + comments);        
        if(comments == null || comments =='' || comments == 'undefined'){           
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": "Please add comments",
                type: 'error'    
            });
            toastEvent.fire();
            
        }
        else{
            action.setParams({ "recordId" : recId ,
                              "assignApproval": 'ClientCouncilApproval',
                              "comments": comments});
            
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Sent Successfully",
                        type: 'success'    
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        }
        $A.get('e.force:refreshView').fire();
        
    }
})