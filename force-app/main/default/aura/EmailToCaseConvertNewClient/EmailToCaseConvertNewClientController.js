({
    init : function(component, event, helper) {
        
        component.set("v.showSpinner", true);        
        var recId = component.get("v.recordId");
        var action = component.get("c.createNewClient");
        action.setParams({ "recordId" : recId});
        action.setCallback(this,function(response){
            var state = response.getState();
            var responseValue = response.getReturnValue();
            console.log('pickListResponse : ' + responseValue);
            if (state === "SUCCESS") {
                if(responseValue == true){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "New Client Create Successfully",
                        duration:' 2000',
                        type: 'success'    
                    });
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if(responseValue == false){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please fill Name/Mobile/Email/Sector/Website/Client Name!!!",
                        duration:' 2000',
                        type: 'error'    
                    });
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
        
        
    }
})