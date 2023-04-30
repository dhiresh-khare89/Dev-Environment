({
	 helperMethod : function(component,helper){
        //alert("Step1");
        var recId= component.get("v.recordId");
        var action1 = component.get("c.EnquiryRelatedCommercialAndCommercialLineItem");
         action1.setParams({ "IntegratedEnquiryId" : recId });
        action1.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapList=[]; 
                for ( var key in response.getReturnValue() ){
                    wrapList.push({value:response.getReturnValue()[key], key:key});
                }
                component.set('v.wrapperList',wrapList);
                console.log('test---->'+JSON.stringify(component.get("v.wrapperList")));
            }
        });
        $A.enqueueAction(action1);
    },
     getIntegratedEnquiryNameHelperMethod : function(component,helper){
        //alert("Step1");
        var recId= component.get("v.recordId");
        var action2 = component.get("c.getIntegratedEnquiryName");
        action2.setParams({ "IntegratedEnquiryId" : recId });
        action2.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.IntegratedEnquiryName',response.getReturnValue());
                console.log("Enquiry Name"+component.get("v.IntegratedEnquiryName"));
            }
        });
        $A.enqueueAction(action2);
    }
})