/* 
     Written By: Bhanwar Singh
     Created Date: 22-03-23
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This is Used as A Wrapper For MCA Entity 
     
*/
public class createInvestors {
    public static void deleteOldInv(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Investor__c> listinvtoDelete = new List<Investor__c>([Select Id From Investor__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            delete listinvtoDelete;
        }
        createInvestors.createInvestorsFromCAPIQ(clientId ,companyID ,obj);
    }
    @future(callout=true)
    public static void createInvestorsFromCAPIQ(Id clientId ,String companyID ,String obj)
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
        
       
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR","identifier":"'+companyID
        +'", "properties": {"startRank":"1","endRank":"20"}},{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR_STAKE","identifier":"'+  companyID
        + '","properties": {"startRank":"1","endRank":"20"}},{"function":"GDSHE","mnemonic":"IQ_INVESTORS_CURR_TRANSACTION_ID","identifier":"' + companyID
        +'", "properties": {"startRank":"1","endRank":"20"}}]}';
        req.setBody(reqBody);
 
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        List<Investor__c> listinv = new List<Investor__c>();
        try{
            for(Integer i=0;i<20 ;i++)
            {
            if(respoApex.GDSSDKResponse[0].Rows[i].Row!=NULL){
                System.debug('respoApex.GDSSDKResponse[0].Rows[i].Row' + respoApex.GDSSDKResponse[0].Rows[i].Row);
                System.debug('Company'+ respoApex.GDSSDKResponse[0].Rows[i].Row[0]+'Percentage '+ respoApex.GDSSDKResponse[1].Rows[i].Row[0]+'Transiction Id'+ respoApex.GDSSDKResponse[2].Rows[i].Row[0]);
                Investor__c inv = new Investor__c ();
                if(respoApex.GDSSDKResponse[0].Rows[i].Row[0] != 'Data Unavailable'){
                    inv.Name =  respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    inv.Investor_Percentage_of_Shares_held__c = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    inv.Transaction_IDs__c = respoApex.GDSSDKResponse[2].Rows[i].Row[0];
                    inv.ExternalDataSource__c = 'CapIQ';
                    if(obj == 'Lead')
                    {
                        inv.New_Client__c = clientId;
                    }
                    else
                    {
                        inv.Client__c = clientId;
                    }
                    listinv.add(inv);
                }
                    
            }
            else{
                i=30;
            }
               
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        insert listinv;
    }
    //@future(callout=true)
    public static void createInvestorsFromMCA(Id clientId,String mcaId, String obj)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Corp Details ShareHolder' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"entityId":"'+mcaId+'","consent":"y"}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp;
        List<Investor__c> listinv = new List<Investor__c>();
        try {
            resp  = http.send(req);        
            MCACorpInvestorWrapper_cls respoApex=(MCACorpInvestorWrapper_cls) System.JSON.deserialize(resp.getBody(), MCACorpInvestorWrapper_cls.class);
            for(Integer i=0;i<respoApex.Result.ShareHolders.size();i++){
                Investor__c inv = new Investor__c();
                inv.Name = respoApex.Result.ShareHolders[i].name;
                String invper = respoApex.Result.ShareHolders[i].percentageOfHoldingByShares;
                List<String> spliters;
                if(invper !='Data Unavailable'){
                    try{
                        spliters = invper.split('\\.');
                        invper = spliters[0]+'.';
                        spliters = spliters[1].split('');
                        invper = invper+spliters[0]+spliters[1];     
                        }catch(Exception e){
                        
                       }
                }
                inv.Investor_Percentage_of_Shares_held__c = invper;
                if(obj == 'Lead')
                    {
                        inv.New_Client__c = clientId;
                    }
                else{
                        inv.Client__c = clientId;
                    }
                inv.ExternalDataSource__c = 'CapIQ';
               listinv.add(inv);
            }
        }
        catch(Exception e){
            
        }
        System.debug(listinv);
        insert listinv;
    }

}