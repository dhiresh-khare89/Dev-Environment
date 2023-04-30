@RestResource(urlMapping='/updateClientId/*')
Global With Sharing class UpdateClientId{
    @HTTPPUT
    global static string doPut(){
        RestRequest req = RestContext.request;
        
        system.debug('req'+JSON.deserializeUntyped(RestContext.request.requestBody.toString()));
        
        
        return 'Successfully Updated';
    }
    
}