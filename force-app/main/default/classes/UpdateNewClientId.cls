@RestResource(urlMapping='/updateNewClientId/*')
Global With Sharing class UpdateNewClientId{
    @HTTPPUT
    global static string doPut(){
        RestRequest req = RestContext.request;
        
        system.debug('req'+JSON.deserializeUntyped(RestContext.request.requestBody.toString()));
        Map<String,object> requestMap= (Map<String,object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        //For(requestMap.keyset())
        //List<Lead> lead1=[Select Id From Lead Where Id In :];
        
        
        return 'Successfully Updated';
    }
    
}