/* 
     Written By: Bhanwar Singh
     Created Date: 9/27/2022
     Last Modified By : Bhanwar Singh
     Last Modified Date : 04/11/2023
     Last Update:- Modifed the Financial Year Format from 2022 to 2022-23
     Description : This class is used to find data from CAPIQ. 
     Variable Used in Method : - 
       searchString : - Company Name from LWC component. 
       companyName : - Company Name after Selection of Company
       companyId : - Company CAPIQ Id
*/

public class newClientByCompanyNameIQ {
    @AuraEnabled
    //Client New Search By Name 
     public static List<String> ClientNewSearchByName(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
       
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        //List<AggregateResult> a = [SELECT Count(Id) From lead Where Company =: searchString];
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        List<String> listCompany= new List<String>();
        String reqBody = '{"inputRequests": [ {'+
    
            '"function":"GDSHE",' +
    
            '"mnemonic":"IQ_COMPANY_NAME_QUICK_MATCH",'+

            '"identifier" :"  '+ searchString +'",'
             +'"properties": {"startRank":"1","endRank":"5"}'+
                '}]}';
         req.setTimeout(30000);
         req.setBody(reqBody);
        HttpResponse resp;     
       
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        
         try{
             resp= http.send(req);   
             clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
         
            for(integer i=0;i<5;i++)
        {
            if(respoApex.GDSSDKResponse[0].Rows[i].Row[0] != 'Data Unavailable')
            {
                String companyName12 = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                listCompany.add(companyName12);
            }
        }
        }
        catch(Exception e){
            if(listCompany.isEmpty()){
                 if(searchString != ''){
                     List<String> listName = searchString.split(' ');
                    searchString = listName[0];
        
                    for(Integer i=1 ; i < (listName.size()-1);i++ ){
                        searchString += ' '+listName[i];
                    }
                    System.debug(searchString);
                 
                listCompany = newClientByCompanyNameIQ.ClientNewSearchByNameit(searchString);
                 }
             }
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'ClientNewSearchByName' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
         
       System.debug(listCompany);
        return listCompany;

   }
    public static List<String> ClientNewSearchByNameit(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
       
        req.setMethod('POST');
       CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        //List<AggregateResult> a = [SELECT Count(Id) From lead Where Company =: searchString];
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        List<String> listCompany= new List<String>();
        String reqBody = '{"inputRequests": [ {'+
    
            '"function":"GDSHE",' +
    
            '"mnemonic":"IQ_COMPANY_NAME_QUICK_MATCH",'+

            '"identifier" :"  '+ searchString +'",'
             +'"properties": {"startRank":"1","endRank":"5"}'+
                '}]}';
          req.setTimeout(30000);
         req.setBody(reqBody);

        HttpResponse resp;      
       
		
         try{
             resp = http.send(req);        
       
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            for(integer i=0;i<5;i++)
        {
            if(respoApex.GDSSDKResponse[0].Rows[i].Row[0] != 'Data Unavailable')
            {
                String companyName12 = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                listCompany.add(companyName12);
            }
        }
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'ClientNewSearchByNameit' , '' , reqBody,resp.getBody(),capIq.EndPointURL__c);
        }
         
       System.debug(listCompany);
        return listCompany;

   }
   //Client Name Search ID
   @AuraEnabled
    public static String ClientNewSearchId(String companyName)
    {
        System.debug(companyName);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);

        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
        //System.debug('companyID ===>' + CompanyName );
        String reqBody = '{"inputRequests":[{"function":"GDSHE","mnemonic":"IQ_COMPANY_ID_QUICK_MATCH", "identifier":"'+ companyName+
        '","properties": {"startRank":"1","endRank":"5"}}]}';
        System.debug(reqBody);
        
        req.setBody(reqBody);

        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        //System.debug(respoApex.GDSSDKResponse[0].Rows[1]);  
        String companyId='';
        String tempCompanyName;
        try{
            for(Integer i=0;i<5;i++){
                tempCompanyName = newClientByCompanyNameIQ.companyNamebyCapIq(respoApex.GDSSDKResponse[0].Rows[i].Row[0]);
                system.debug(tempCompanyName);
                if(tempCompanyName == companyName){
                    companyId = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    i=i+10;
                }
            }
            if(companyId == ''){
            	companyId = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
            }
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'ClientNewSearchId' , '' , reqBody,resp.getBody(),capIq.EndPointURL__c);
        
        }
        
        //System.debug(companyId);
        return companyId;
    }
    
    
    //Get Different Field From IQ
    @AuraEnabled
    public static List<String> clientDifferentField(String companyId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, NumberofBoardMember__c ,Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);

        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
       
        //System.debug('companyID ===>' + leads );
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
        '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"'+capIq.NumberofBoardMember__c +'"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSP","mnemonic":"IQ_EBIT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_EQUITY","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_ASSETS","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_EBITDA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_NI","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_GP","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_CL","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_CA","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_LIAB","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_REV","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_TOTAL_DEBT","identifier":"'+companyID+'","properties" : {"periodType" : "IQ_FY"}},'+
        '{"function":"GDSP","mnemonic":"IQ_HOLDER_NAME","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"} },'+
        '{"function":"GDSP","mnemonic":"IQ_HOLDER_PERCENT","identifier":"'+companyID+'","properties" : {"asOfDate" : "01/01/2022", "startRank" : "1","endRank" : "5", "currencyId" : "EUR", "currencyConversionModeId" : "Historical"}},'+
        '{"function":"GDSP","mnemonic":"IQ_ISIN","identifier":"'+companyID+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_ID","identifier":"'+companyID+'","properties": {"startDate":"01/01/2022","endDate":"09/09/2022","keyDevFilter" : "C2,T36"}},'+
        '{"function":"GDSP","mnemonic":"IQ_FISCAL_Y","identifier":"'+companyID+'"},'+
        '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_IMM_PARENT_CIQID","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"5"}},'+
        '{"function":"GDSP","mnemonic":"IQ_ULT_PARENT_CIQID","identifier":"'+companyID+'"},'+']}';

        
        req.setBody(reqBody);

        HttpResponse resp; 
        try{
            resp = http.send(req); 
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'ClientNewSearchByName' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
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
        employees = employees.split('\\.')[0];
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
 */       String ebit = respoApex.GDSSDKResponse[39].Rows[0].Row[0];
        List<String> spliters;
        if(ebit !='Data Unavailable'){
            try{
			spliters = ebit.split('\\.');
            ebit = spliters[0]+'.';
            spliters = spliters[1].split('');
            ebit = ebit+spliters[0];            
        }catch(Exception e){
            
        }
        }
        String totalEquity = respoApex.GDSSDKResponse[40].Rows[0].Row[0];
        String iqRev = respoApex.GDSSDKResponse[41].Rows[0].Row[0];
        if(iqRev !='Data Unavailable'){
            try{
			spliters = iqRev.split('\\.');
            iqRev = spliters[0]+'.';
            spliters = spliters[1].split('');
            iqRev = iqRev+spliters[0];           
        }catch(Exception e){
            
        }

        }
        String totalAssets = respoApex.GDSSDKResponse[42].Rows[0].Row[0];
        String ebitda = respoApex.GDSSDKResponse[43].Rows[0].Row[0];
        String ni = respoApex.GDSSDKResponse[44].Rows[0].Row[0];
        String gp = respoApex.GDSSDKResponse[45].Rows[0].Row[0];
        if(gp !='Data Unavailable'){
            try{
                spliters = gp.split('\\.');
                gp = spliters[0]+'.';
                spliters = spliters[1].split('');
                gp = gp+spliters[0];     
                }catch(Exception e){
                
               }
        }
        
        String totalCL = respoApex.GDSSDKResponse[46].Rows[0].Row[0];
        String totalCA = respoApex.GDSSDKResponse[47].Rows[0].Row[0];
        String totalLiab = respoApex.GDSSDKResponse[48].Rows[0].Row[0];
        String totalRev = respoApex.GDSSDKResponse[49].Rows[0].Row[0];
        String totalDebt = respoApex.GDSSDKResponse[50].Rows[0].Row[0];
        //String holderName  = respoApex.GDSSDKResponse[51].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[51].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[51].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[51].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[51].Rows[4].Row[0];
        String iqISIN /*= respoApex.GDSSDKResponse[52].Rows[0].Row[0]*/;
        String keyDevId = respoApex.GDSSDKResponse[53].Rows[0].Row[0];
        String fYear = respoApex.GDSSDKResponse[55].Rows[0].Row[0];
        String clientGroup = respoApex.GDSSDKResponse[56].Rows[0].Row[0];
        String clientGroupId = respoApex.GDSSDKResponse[57].Rows[0].Row[0];
        String ultOwnerId = respoApex.GDSSDKResponse[58].Rows[0].Row[0];
        String boardMember = respoApex.GDSSDKResponse[33].Rows[0].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[0].Row[0]+') ';
        try{
          for(Integer i=1;i<=respoApex.GDSSDKResponse[33].Rows.size();i++)
          {
            boardMember =boardMember + ';  '+ respoApex.GDSSDKResponse[33].Rows[i].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[i].Row[0]+')  ';
          }
        }
        catch(Exception e)
        {

        }
        List<String> result = new List<String> ();

        result.add(totalAssets);
        result.add(totalCA);
        result.add(totalCL);
        result.add(totalDebt);
        result.add(totalEquity);
        result.add(totalLiab);
        result.add(employees);
        result.add(totalRev);
        result.add(ebit);
        result.add(ebitda);
        result.add(companyTickter);
        result.add(primarySIC);
        result.add(ceoName);
        result.add(iqULTParent);
        result.add(companyType);

        
        result.add(shortDescription);
        result.add(exchange);
        result.add(companyWebsite);
        String ld = longDescription;
        if(ld.length() > 120000 ){
            ld = ld.substring(0, 119998);
        }
        longDescription =ld;
        
        result.add(longDescription);
        result.add(yearFounded);
        result.add(chairmanName);
        result.add(countryINC);
        result.add(iqRev);
        result.add(boardMember);
        decimal fy = decimal.valueOf(fYear);
        fYear = string.valueOf(fy) + '-' + string.valueof(fy+1).right(2);
        
        result.add(fYear);
        result.add(ni);
        result.add(gp);
        result.add(clientGroup);
        result.add(clientGroupId);
        result.add(ultOwnerId);
        if(companyStreet !='Data Unavailable'){
            result.add(companyStreet);
        }
         else{
            companyStreet = '';
            result.add(companyStreet);
        }
        
        if(city !='Data Unavailable'){
            result.add(city);
        }
        else{
            city = '';
            result.add(city);
        }
        if(state !='Data Unavailable'){
            result.add(state);
        }
        else{
            state = ' ';
            result.add(state);
        }
        if(companyZIP !='Data Unavailable'){
           
        result.add(companyZIP);
        }
        else{
            companyZIP = '';
            result.add(companyZIP);
        }
        return result;
    }
    //Key Development ID
    public static void keyDevelopmentID(String keyId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        

        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
         req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);

        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
         req.setHeader('Content-Type','application/json');
        
       
       
        String reqBody = '{"inputRequests":[{"function":"GDSP","mnemonic":"IQ_KEY_DEV_HEADLINE","identifier":"'+keyId+'"},'+
        '{"function":"GDSP""mnemonic":"IQ_KEY_DEV_DATE","identifier":"'+keyId+'"},'+
        '{"function":"GDSP","mnemonic":"IQ_KEY_DEV_TYPE","identifier":"'+keyId+'"}'+
        ']}';

        
        req.setBody(reqBody);

        HttpResponse resp;
        try{
            resp = http.send(req);
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        } 
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'keyDevelopmentID' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        } 
    }
    public static String companyNamebyCapIq(String companyId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
        req.setEndpoint(capIq.EndPointURL__c);
        Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        
       
        String reqBody = '{"inputRequests": [{"function":"GDSP","mnemonic":"IQ_COMPANY_NAME","identifier":"'+companyId+'"}]}';
        req.setBody(reqBody);
        String companyName ;
        HttpResponse resp;
        try{
            resp = http.send(req);
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        	companyName = respoApex.GDSSDKResponse[0].Rows[0].Row[0];
        } 
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientByCompanyNameIQ' , 'companyNamebyCapIq' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
        }
        
        //System.debug(companyName);
        return companyName;
    }
}