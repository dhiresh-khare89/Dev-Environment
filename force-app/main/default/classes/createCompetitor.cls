/* 
     Written By: Bhanwar Singh
     Created Date: 2/23/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 12-04-23
     Description : This class is used to create competitors For New Client and Client Object.
     Variable Used : - 
       clientId : - New Client /Client Record Id 
       companyID : - CAPIQ ID of Client (Company)
       obj : - Which Object is used like Client or New Client
*/
public class createCompetitor {
    public static void deleteOldCompetitor(Id clientId ,String companyID ,String obj){
        if(obj == 'Lead'){
            List<Competitor__c> listinvtoDelete = new List<Competitor__c>([Select Id From Competitor__c Where New_Client__c =: clientId AND ExternalDataSource__c = 'CapIQ' Limit 10000]);
            //System.debug(listinvtoDelete);
            delete listinvtoDelete;
        }
        createCompetitor.createCompetitorFromCAPIQ(clientId ,companyID ,obj);
    }
     @future(callout=true)
    public static void createCompetitorFromCAPIQ(Id clientId, String companyID, String obj)
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
        
        System.debug('companyID ===>' + companyID );
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_COMPETITOR_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"20"}}]}';
        req.setTimeout(3000);
        req.setBody(reqBody);
        List<Competitor__c> complist = new List<Competitor__c>();
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        System.debug(respoApex);
        try{
            for(Integer i=0;i<20;i++){
                Competitor__c comp = new Competitor__c ();
                System.debug(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
                String competitorCompanyId = createCompetitor.ClientNewSearchId(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
                
                System.debug(competitorCompanyId);
                if(competitorCompanyId != 'Data Unavailable' && competitorCompanyId != '')
                {
                    System.debug('  competitorCompanyId  -->'+competitorCompanyId + ' clientId  -->' +clientId +' obj-->  '+ obj);
                    
                    comp = createCompetitor.createCompetitorFromCAPIQSingle(competitorCompanyId, clientId , obj);
                    System.debug('Return  --'+createCompetitor.createCompetitorFromCAPIQSingle(competitorCompanyId, clientId , obj));
                    System.debug('Value in comp'+comp);
                    complist.add(comp);
                }
                
            }
        }
        catch(Exception e){
            System.debug('List exception fired'+e.getLineNumber()+ '  ' +e.getMessage());         
        }
        System.debug('complist ----->'+complist);
        insert complist;
    }
    public static Competitor__c createCompetitorFromCAPIQSingle(String companyId , Id clientId ,String obj)
    {
        System.debug('Running Competitor');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c FROM CapIQ__mdt Limit 1];
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        Competitor__c comp = new Competitor__c ();
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"PARENT_NAME","identifier":"'+companyID+'","startDate":"01/01/202"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_TICKER","identifier":"' +companyID+'"},' +
        '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_INDUSTRY","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_CEO_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_TYPE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_PRESIDENT_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_SHORT_BUSINESS_DESCRIPTION","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_PRIMARY_SIC_CODE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_EXCHANGE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COO_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_CFO_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET2","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_CITY","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COUNTRY_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_EMPLOYEES","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_DESCRIPTION_LONG","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_YEAR_FOUNDED","identifier":"'+companyID+'"},'+
        '{"function":"GDSHE","mnemonic":"IQ_COMPETITOR_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSP","mnemonic":"IQ_CHAIRMAN_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COUNTRY_OF_INC","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_PHONE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_ADDRESS","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_ZIP","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_STATE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_STREET1","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_COMPANY_WEBSITE","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"DOM_ULTIMATE_PARENT_NAME","identifier":"'+companyID+'"},'+
        '{"function":"GDSHE","mnemonic":"IQ_INVESTORS_ALL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSP","mnemonic":"IQ_PROFESSIONAL_DIRECT_PHONE","identifier":"'+companyID+'"},'+
        '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSP","mnemonic":"IQ_EBIT","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_EQUITY","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_REV","identifier":"'+companyID+'","properties" : {"periodType" : "FY2022"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_ASSETS","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_EBITDA","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_NI","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_GP","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_CL","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_CA","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_LIAB","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_REV","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_DEBT","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_HOLDER_NAME","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"} },'+
        '{"function":"GDSP","mnemonic":"IQ_HOLDER_PERCENT","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"}},'+
        '{"function":"GDSP","mnemonic":"IQ_ISIN","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"01/01/2022","endDate":"09/09/2022","keyDevFilter" : "C2,T36"}},'+
        ']}';
 
        req.setTimeout(3000);
        req.setBody(reqBody);
 
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        System.debug(respoApex.GDSSDKResponse[0]); 
        String companyTickter=respoApex.GDSSDKResponse[1].Rows[0].Row[0]; 
        String primarySIC=respoApex.GDSSDKResponse[2].Rows[0].Row[0]; 
        String ceoName=respoApex.GDSSDKResponse[3].Rows[0].Row[0];
        String iqULTParent=respoApex.GDSSDKResponse[4].Rows[0].Row[0];
        String companyType=respoApex.GDSSDKResponse[5].Rows[0].Row[0];
        String presidentName=respoApex.GDSSDKResponse[6].Rows[0].Row[0];
        String shortDescription=respoApex.GDSSDKResponse[7].Rows[0].Row[0];
        String primarySICCode=respoApex.GDSSDKResponse[8].Rows[0].Row[0];
        String exchange=respoApex.GDSSDKResponse[9].Rows[0].Row[0];
        String cooName=respoApex.GDSSDKResponse[10].Rows[0].Row[0];
        String cfoName=respoApex.GDSSDKResponse[11].Rows[0].Row[0];
        String companyStreet=respoApex.GDSSDKResponse[12].Rows[0].Row[0];
        String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
        String countryName=respoApex.GDSSDKResponse[14].Rows[0].Row[0];
        String employees=respoApex.GDSSDKResponse[15].Rows[0].Row[0];
        String companyWebsite=respoApex.GDSSDKResponse[16].Rows[0].Row[0];
        String longDescription=respoApex.GDSSDKResponse[17].Rows[0].Row[0];
        String yearFounded=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
    //    String competeterAll=respoApex.GDSSDKResponse[19].Rows[0].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[19].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[19].Rows[4].Row[0];
        String chairmanName = respoApex.GDSSDKResponse[20].Rows[0].Row[0];
        String countryINC = respoApex.GDSSDKResponse[21].Rows[0].Row[0];
        String companyPhone = respoApex.GDSSDKResponse[22].Rows[0].Row[0];
        String ultParentCAPIQ = respoApex.GDSSDKResponse[23].Rows[0].Row[0];
        String companyName = respoApex.GDSSDKResponse[24].Rows[0].Row[0];
        String companyAddress = respoApex.GDSSDKResponse[25].Rows[0].Row[0];
        String companyZIP = respoApex.GDSSDKResponse[26].Rows[0].Row[0];
        String state = respoApex.GDSSDKResponse[27].Rows[0].Row[0];
        String companyStreet1 = respoApex.GDSSDKResponse[28].Rows[0].Row[0];
        //String companyWebsite = respoApex.GDSSDKResponse[29].Rows[0].Row[0];
        //System.debug(respoApex.GDSSDKResponse[30].Rows[0].Row[0]);
     //   String investorsAll = respoApex.GDSSDKResponse[31].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[31].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[31].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[31].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[31].Rows[4].Row[0];
        String professionalPhone = respoApex.GDSSDKResponse[32].Rows[0].Row[0];
      //  String boardMember = respoApex.GDSSDKResponse[33].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[33].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[33].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[33].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[33].Rows[4].Row[0];
      /*  String boardTitle = respoApex.GDSSDKResponse[34].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[34].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[34].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[34].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[34].Rows[4].Row[0];
        String iqProfessional = respoApex.GDSSDKResponse[35].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[35].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[35].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[35].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[35].Rows[4].Row[0];
        String iqProfesiionalPhone = respoApex.GDSSDKResponse[36].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[36].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[36].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[36].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[36].Rows[4].Row[0];
        String iqProfessionalEmail = respoApex.GDSSDKResponse[37].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[37].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[37].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[37].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[37].Rows[4].Row[0];
        String iqProfessionalTitle = respoApex.GDSSDKResponse[38].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[38].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[38].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[38].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[38].Rows[4].Row[0];
 */     String ebit = respoApex.GDSSDKResponse[39].Rows[0].Row[0];
        String totalEquity = respoApex.GDSSDKResponse[40].Rows[0].Row[0];
        String iqRev = respoApex.GDSSDKResponse[41].Rows[0].Row[0];
        String totalAssets = respoApex.GDSSDKResponse[42].Rows[0].Row[0];
        String ebitda = respoApex.GDSSDKResponse[43].Rows[0].Row[0];
        String ni = respoApex.GDSSDKResponse[44].Rows[0].Row[0];
        String gp = respoApex.GDSSDKResponse[45].Rows[0].Row[0];
        String totalCL = respoApex.GDSSDKResponse[46].Rows[0].Row[0];
        String totalCA = respoApex.GDSSDKResponse[47].Rows[0].Row[0];
        String totalLiab = respoApex.GDSSDKResponse[48].Rows[0].Row[0];
        String totalRev = respoApex.GDSSDKResponse[49].Rows[0].Row[0];
        String totalDebt = respoApex.GDSSDKResponse[50].Rows[0].Row[0];
        //String holderName  = respoApex.GDSSDKResponse[51].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[51].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[51].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[51].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[51].Rows[4].Row[0];
        String iqISIN /*= respoApex.GDSSDKResponse[52].Rows[0].Row[0]*/;
        String keyDevId = respoApex.GDSSDKResponse[53].Rows[0].Row[0];
        try{
            if(totalAssets != 'Data Unavailable'){
                comp.Total_Assets__c = totalAssets;
            }
            if(totalCA != 'Data Unavailable'){
                comp.Total_Current_Assets__c = totalCA;
            }
            if(totalCL != 'Data Unavailable'){
                comp.Total_Current_Liabilities__c = totalCL;
            }
            if(totalDebt != 'Data Unavailable'){
                comp.Total_Debt__c = totalDebt;
            }
            if(totalEquity != 'Data Unavailable'){
                comp.Total_Equity__c =totalEquity;
            }
            if(totalLiab != 'Data Unavailable'){
                comp.Total_Liabilities__c = totalLiab;
            }
            if(totalRev != 'Data Unavailable'){
                comp.Total_Revenue__c = totalRev;
            }
            if(ebit != 'Data Unavailable'){
                comp.Earnings_Before_Interest_and_Taxes_EBIT__c = ebit;
            }
            if(ebitda != 'Data Unavailable'){
                comp.EBITDA__c = ebitda;
            }
            if(obj == 'Lead')
            {
                comp.New_Client__c = clientId;
            }
            else{
                comp.Client__c = clientId;
            }
            comp.ExternalDataSource__c = 'CapIQ';
        comp.Name = companyName;
        }
        catch(Exception e){
            System.debug('No Problem');
        }            
        
        System.debug(comp);
        return comp;
    }
    public static String ClientNewSearchId(String companyName)
    {
        System.debug(companyName);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        //System.debug(CompanyName);
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c FROM CapIQ__mdt Limit 1];
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);

        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
        //System.debug('companyID ===>' + CompanyName );
        String reqBody = '{"inputRequests":[{"function":"GDSHE","mnemonic":"IQ_COMPANY_ID_QUICK_MATCH", "identifier":"'+ companyName+
        '","properties": {"startRank":"1","endRank":"5"}}]}';
        System.debug(reqBody);
        //req.setTimeout(3000);
        req.setBody(reqBody);

        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        //System.debug(respoApex.GDSSDKResponse[0].Rows[1]);  
        String companyId='';
        String tempCompanyName;
        try{
            if(companyId == ''){
            	companyId = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            }
        }
        catch(Exception e){
            
        }
        
        //System.debug(companyId);
        return companyId;
    }
}