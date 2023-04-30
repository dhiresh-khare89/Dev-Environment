({
    submitComments : function (component, event, helper) {
        helper.helperMethod(component,event,helper);
       
    },
    
    closeComponent : function(component,event,helper){
        console.log('close');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
    
})