public class newClientNew {
  @AuraEnabled(cacheable=true)
    public static List<String> ClientNewSearch(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');

        req.setMethod('POST');
        String username = 'apiadmin@in.gt.com';
        String password = 'Welcome@123'; 
        Blob headerValue = Blob.valueOf(username + ':' + password);

        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
         req.setHeader('Content-Type','application/json');

        String reqBody = '{"inputRequests": [ {'+
    
            '"function":"GDSHE",' +
    
            '"mnemonic":"IQ_COMPANY_NAME_QUICK_MATCH",'+

            '"identifier" :"'+searchString+
            '",' +
            '"properties" : { "startRank":"1",'+
    
                '"endRank":"10" }' +
                '}]}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);
        System.debug('logLevel'+resp.getStatusCode());
       
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
      clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
     /* System.debug('respoApex>> '+respoApex);
      System.debug('respoApex>> '+respoApex.GDSSDKResponse[0].Rows);
      System.debug('respoApex>>1 '+respoApex.GDSSDKResponse[0].NumCols);
      System.debug('respoApex>>2222 '+respoApex.GDSSDKResponse[0].Rows[0].Row);*/
        
       list<string> temp = new list<string>();
       
       // integer I = 0;
        for(Integer i = 0 ; i < (respoApex.GDSSDKResponse[0].Rows).size() ; i++){
            
            temp.add(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
            
        }
      
        return temp;

   }

    // temp method to check whether the company is already in record
   @AuraEnabled
   public static List<Account> tempClientNewSearch(String searchString){
       string strFilter;
       if(searchString.containsWhitespace()){
           String str= searchString.replaceAll('\\s+', ' ');
           strFilter = str.trim();
           strFilter +='%';
       }else{
           strFilter = searchString.trim();
           strFilter = strFilter + '%';
       }
       system.debug('strFilter'+strFilter);
       list<account> clientList = [select name ,ParentId,Parent.Name ,Owner.Name from account where name Like :strFilter];
      	return clientList;
   }

	
}