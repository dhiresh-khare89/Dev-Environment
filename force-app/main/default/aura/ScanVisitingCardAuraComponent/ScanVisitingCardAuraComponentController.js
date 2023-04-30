({  
    doAction : function(component, event, helper) 
    {  
        //window.open('https://play.google.com/store/apps/details?id=com.sansan.scantosalesforce'); 
        var agent = navigator.platform;
        //alert('agent : ' + agent);
        
        if (agent == 'Win32') {
            try{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "Test."
                });
                toastEvent.fire();
                
            }
            catch(error){
                console.log('error : ' + error);
            }
            
        }
    }  
})