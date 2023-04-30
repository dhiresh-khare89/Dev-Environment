@RestResource(urlMapping='/updateClientContactId/*')
Global With Sharing class UpdateClientContactId{
    @HTTPPUT
    global static string doPut(){
        RestRequest req = RestContext.request;
        
        system.debug('req'+JSON.deserializeUntyped(RestContext.request.requestBody.toString()));
        
        
        return 'Successfully Updated';
    }
    
}