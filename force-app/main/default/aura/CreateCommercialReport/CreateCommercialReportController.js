({
    doInit : function(component, event, helper) {
        helper.helperMethod(component,helper);
        helper.getIntegratedEnquiryNameHelperMethod(component,helper);
    },
	download : function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var url = '/apex/CreateCommercialReportVF?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    },
    
    onClick : function (component, event, helper) {
        debugger;
        var anchorId = event.target.getAttribute("data-anchorId");
          var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": anchorId
            });
            navEvt.fire();
         }
})