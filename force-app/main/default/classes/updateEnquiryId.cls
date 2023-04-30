@RestResource(urlMapping='/updateEnquiryId/*')
Global With Sharing class updateEnquiryId{
    @HTTPPUT
    global static string doPut(){
            RestRequest req = RestContext.request;
            blob body = req.requestBody;
            string RequestString = body.toString();
            JsonForUserCreation data = parse(RequestString);
            System.debug(data.Id);
            Opportunity opp = [Select Id, Name, WCGTId__c From Opportunity Where Id =: data.ID Limit 1];
            opp.WCGTId__c = data.WCGTNewClientID;
            update opp;
            return 'Successfully Updated';
        
    }
    public static JsonForUserCreation parse(String json) {
        return (JsonForUserCreation)System.JSON.deserialize(json, JsonForUserCreation.class);
    }
    public class JsonForUserCreation {
        public String WCGTNewClientID;
        public Id ID;        
    }
}