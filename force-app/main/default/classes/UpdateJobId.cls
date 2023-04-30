@RestResource(urlMapping='/updateJobId/*')
Global With Sharing class UpdateJobId{
    @HTTPPUT
    global static string doPut(){
        RestRequest req = RestContext.request;
        
        system.debug('req'+JSON.deserializeUntyped(RestContext.request.requestBody.toString()));
        Map<String,object> requestMap= (Map<String,object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        
        system.debug('requestMap'+requestMap);        
        return 'Successfully Updated';
    }
    
}