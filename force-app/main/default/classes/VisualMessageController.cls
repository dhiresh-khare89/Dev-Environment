public class VisualMessageController {
    /*By :-Suresh gupta
*Date:- 12 March 2023
*Purpose:- To show visual message on "New client" record page if "Client" record is already being created with same client name.
*/
    /*------------------------------------------------------*/  
    @AuraEnabled(cacheable = true)
    Public static wrapperClass getClientDetails (String company){
        try{
            List<Account> clientList = [SELECT Id, Name FROM Account WHERE Name =: company];
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            System.debug('Base URL: ' + sfdcBaseURL );  
            if(clientList.size()>0){
                wrapperClass wrapperClassObj = New wrapperClass();
                wrapperClassObj.accountName = clientList[0].name;
                wrapperClassObj.accRecordPageUrl = sfdcBaseURL+'/'+clientList[0].id;
                System.debug('wrapperClassObj : ' + wrapperClassObj);
                return wrapperClassObj;
            }
            else{
                return Null;
            }
        }
        catch(exception e){
            system.debug(e.getMessage());
            return null;
        }
        
    }
     public class wrapperClass{
        @AuraEnabled public String accountName;
        @AuraEnabled public String accRecordPageUrl;
    }
}