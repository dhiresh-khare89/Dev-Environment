/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create Client News (Key Development and Alerts) For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createClientNews {
    public static void deleteOldClientNews(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Client_News__c> listinvtoDelete = new List<Client_News__c>([Select Id From Client_News__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            System.debug(listinvtoDelete);
            delete listinvtoDelete;
        }
        createClientNews.createClientNewsFromCAPIQ(clientId ,companyID ,obj);
    }
    @future(callout=true)
    public static void createClientNewsFromCAPIQ(Id clientId ,String companyID , String obj){
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        String username = 'apiadmin@in.gt.com';
        String password = 'GTBharat@123'; 
        Blob headerValue = Blob.valueOf  (username + ':' + password);
 
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
        
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C2"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C12"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C5"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C15"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C13"}},'+
            //'{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C11"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C10"}},'+
            //'{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C9"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C6"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C4"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C1"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C3"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C7"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"50","keyDevFilter" : "C8"}}'+']}';
        req.setBody(reqBody);
        List<Client_News__c> cNewslist = new List<Client_News__c>();
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        try{
            for(Integer j=0; j<12 ;j++){
                try{
                    for(Integer i=0;i<50 ;i++){
               
				          Client_News__c news = new Client_News__c();
                   
                if(respoApex.GDSSDKResponse[j].Rows[i].Row[0] != 'Data Unavailable'){
                    news = createClientNews.createClientNewsDataFromCAPIQ(respoApex.GDSSDKResponse[j].Rows[i].Row[0],clientId,obj);
                    news.ExternalDataSource__c = 'CapIQ';
                    cNewslist.add(news);       
                }
                   }
                }	
                Catch(Exception e)
                {
                    
                }
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        System.debug(cNewslist);
        insert cNewslist;
    }
    public static Client_News__c createClientNewsDataFromCAPIQ(String keyDevId , Id clientId ,String obj)
    {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        String username = 'apiadmin@in.gt.com';
        String password = 'GTBharat@123'; 
        Blob headerValue = Blob.valueOf  (username + ':' + password);
        Client_News__c cNews = new Client_News__c ();
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"IQ_KEY_DEV_TYPE", "identifier":"'+keyDevId+'"},{"function":"GDSP","mnemonic":"IQ_KEY_DEV_DATE","identifier":"'+keyDevId+'"},{"function":"GDSP","mnemonic":"IQ_KEY_DEV_HEADLINE","identifier":"'+keyDevId+'"}]}';
        req.setBody(reqBody);
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        
        try{
            cNews.Name = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            cNews.IQ_KEY_DEV_TYPE__c = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            
            //cNews.Key_Development_Date__c = respoApex.GDSSDKResponse[1].Rows[0].Row[0];
            cNews.IQ_KEY_DEV_HEADLINE__c = respoApex.GDSSDKResponse[2].Rows[0].Row[0];
            if(obj == 'Lead')
            {
                cNews.New_Client__c = clientId;
            }
            else{
                cNews.Client__c = clientId;
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        return cNews;
    }
        
}