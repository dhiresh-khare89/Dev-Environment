/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create Subsidiarys For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createSubsidiarys {
    public static void deleteOldSubsidiarys(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Subsidiary__c> listinvtoDelete = new List<Subsidiary__c>([Select Id From Subsidiary__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
        }
        createSubsidiarys.createSubsidiarysFromCAPIQ(clientId ,companyID ,obj);
    }
    @future(callout=true)
    public static void createSubsidiarysFromCAPIQ(Id clientId ,String companyID ,String obj)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        //System.debug(capIq.UserName__c + ':' + capIq.Password__c);
       
        String reqBody = '{"inputRequests": [{"function":"GDSHV","mnemonic":"IQ_COMPANY_CORP_TREE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}}]}';
        req.setBody(reqBody);
        System.debug(reqBody);
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        
        List<Subsidiary__c> listsub = new List<Subsidiary__c>();
        try{
            for(Integer i=0;i<30;i++)
            {
                Subsidiary__c sub = new Subsidiary__c();   
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[2] == 'CurrentSubsidiary'){
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[0]!=NULL){
                    sub.Name = createSubsidiarys.companyNamebyCapIq(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
                    
                }    
                if(obj == 'Lead'){
                    sub.new_client__c = clientId;
                    
                } 
                    if(sub.Name != 'None'){
                        sub.ExternalDataSource__c = 'CapIQ';
                        listsub.add(sub);
                    }
                }
            }
        }
        catch(Exception e){
   			ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'createSubsidiarys' , 'createSubsidiarysFromCAPIQ' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
        System.debug(listsub);
        insert listsub;
    }
    public static String companyNamebyCapIq(String companyId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c FROM CapIQ__mdt Limit 1];
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        //System.debug(capIq.UserName__c + ':' + capIq.Password__c);
       
        String reqBody = '{"inputRequests": [{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"IQ'+companyId+'"}]}';
        req.setBody(reqBody);
 
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        String companyName = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
        //System.debug(companyName);
        try{
            return companyName;
        }catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'createSubsidiarys' , 'companyNamebyCapIq' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            return 'None';
        }
    }
}