/* 
     Written By: Bhanwar Singh
     Created Date: 1/5/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 04/11/2023
     Last Update:- Modifed the Financial Year Format from 2022 to 2022-23
     Description : This class is used to Update New Client Which are coming from Email , Web and ChatBot.
     Variable Used : - 
       searchString : - Company Name from LWC component Enrich From External Database. 
       companyName : - Company Name after Selection of Company
       companyId : - Company CAPIQ Id
       recordId : - New Client Record Id
*/
public class capIQButtontoUpdateClient
    {
        //This Class is Used For Searching Company Name From Enrich From External DataBase Button on Detail Page.
        //By Bhanwar
        @AuraEnabled
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
             resp = http.send(req);
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
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'capIQButtontoUpdateClient' , 'ClientNewSearchByName' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            
        }
         
       System.debug(listCompany);
        return listCompany;

   }
        //This Class is Used For Updating in Account by Enrich From External DataBase Button
        //By Bhanwar
        @AuraEnabled
        public static Boolean sendCapIQIdtoMap(Id recordId)
        {
            System.debug('Running Client');
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
            req.setEndpoint(capIq.EndPointURL__c);
            Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
            
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',authorizationHeader);
            req.setHeader('Content-Type','application/json');
            Account acc = [SELECT Id, Name , capIQId__c From Account Where Id =: recordId Limit 1];
            String companyID = acc.capIQId__c;
            Boolean result;
            if(companyID == NULL)
            {
                List <String> compNameList = newClientByCompanyNameIQ.ClientNewSearchByName(acc.Name);
                System.debug('compNameList ===>' + compNameList);
                companyID = newClientByCompanyNameIQ.ClientNewSearchId(compNameList[0]);
                System.debug('companyID ===>' + companyID);
                acc.capIQId__c = companyID;
            }
            
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
            
            
            req.setBody(reqBody);
            
            HttpResponse resp = http.send(req); 
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            System.debug(respoApex.GDSSDKResponse[0]); 
            try{
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
                
                /*String iqProfessional = respoApex.GDSSDKResponse[35].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[35].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[35].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[35].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[35].Rows[4].Row[0];
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
                acc.Total_Assets__c = totalAssets;
                acc.Total_Current_Assets__c = totalCA;
                acc.Total_Current_Liabilities__c = totalCL;
                acc.Total_Debt__c = totalDebt;
                acc.Total_Equity__c =totalEquity;
                acc.Total_Liabilities__c = totalLiab;
                acc.Total_No_of_employees__c = employees;
                acc.Total_Revenue__c = totalRev;
                acc.Earnings_Before_Interest_and_Taxes_EBIT__c = ebit;
                acc.EBITDA__c = ebitda;
                acc.Ticker_Symbol__c = companyTickter;
                //acc.Industry__c = primarySIC;
                //acc.CEO_Name__c = ceoName;
                acc.Global_Ultimate_Owner__c = iqULTParent;
                acc.Public_Private_Company__c = companyType;
                acc.Business_Short_Description__c = shortDescription;
                acc.Stock_Exchange_symbol__c= exchange;
                acc.Company_Website__c = companyWebsite;
                acc.Company_Overview__c = longDescription;
                acc.Year_Founded__c = yearFounded;
                //acc.Chairman_Name__c = chairmanName;
                acc.Country_of_Incorporation__c = countryINC;
                acc.Revenue__c = iqRev;
                
                update acc;
                System.debug(acc);
                result= true;
            }
            catch(Exception e)
            {
                result = false;
            }
            return result;
            
        }
        
        //This Class is Used For Updating in Competitor by Enrich From External DataBase Button
        //By Bhanwar
        @AuraEnabled
        public static String sendCapIQIdtoCompetitor(Id recordId)   
        {
            System.debug('Running Competitor');
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            CapIQ__mdt capIq = [SELECT Id, UserName__c, Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
            req.setEndpoint(capIq.EndPointURL__c);
            Blob headerValue = Blob.valueOf  (capIq.UserName__c + ':' + capIq.Password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization',authorizationHeader);
            req.setHeader('Content-Type','application/json');
            Competitor__c comp = [SELECT Id, Name , capIQId__c From Competitor__c Where Id =: recordId Limit 1];
            String companyID = comp.capIQId__c;
            System.debug('companyID ===>' + comp );
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
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"20"}},'+
                '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"20"}},'+
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
            comp.Total_Assets__c = totalAssets;
            comp.Total_Current_Assets__c = totalCA;
            comp.Total_Current_Liabilities__c = totalCL;
            comp.Total_Debt__c = totalDebt;
            comp.Total_Equity__c =totalEquity;
            comp.Total_Liabilities__c = totalLiab;
            comp.Total_Revenue__c = totalRev;
            comp.Earnings_Before_Interest_and_Taxes_EBIT__c = ebit;
            comp.EBITDA__c = ebit;
            comp.Revenue__c = iqRev;
            update comp;
            System.debug(comp);
            return ebit;
        }
        //This Class is Used For Updating in Lead by Enrich From External DataBase Button
        //By Bhanwar 13/03/2023
        @AuraEnabled
        public static Boolean sendCapIQIdtoNewClient(Id recordId , String capIqId)
        {
            Lead lead = [SELECT Name,Company,capIQId__c, Currency_Format__c From Lead Where Id = :recordId];
            String companyID=capIqId;
            System.debug('Client ---->'+lead.Company);
            lead.capIQId__c = capIqId;
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            CapIQ__mdt capIq = [SELECT Id, UserName__c,NumberofBoardMember__c , Password__c, EndPointURL__c  FROM CapIQ__mdt Limit 1];
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
                ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'capIQButtontoUpdateClient' , 'sendCapIQIdtoNewClient' , '' , reqBody,resp.getBody(), capIq.EndPointURL__c );
            }
            clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
            try{
                System.debug(respoApex.GDSSDKResponse[1].Rows[0].Row[0]); 
                lead.Ticker_Symbol__c = respoApex.GDSSDKResponse[1].Rows[0].Row[0]; 
                lead.Industry__c=respoApex.GDSSDKResponse[2].Rows[0].Row[0]; 
                lead.CEO_Name__c=respoApex.GDSSDKResponse[3].Rows[0].Row[0];
                lead.Global_Ultimate_Owner__c=respoApex.GDSSDKResponse[4].Rows[0].Row[0];
                lead.Public_Private_Company__c=respoApex.GDSSDKResponse[5].Rows[0].Row[0];
                String presidentName=respoApex.GDSSDKResponse[6].Rows[0].Row[0];
                
                
                
                lead.ClientBackground__c=respoApex.GDSSDKResponse[7].Rows[0].Row[0];
                String primarySICCode=respoApex.GDSSDKResponse[8].Rows[0].Row[0];
                lead.Stock_Exchange_symbol__c=respoApex.GDSSDKResponse[9].Rows[0].Row[0];
                String cooName=respoApex.GDSSDKResponse[10].Rows[0].Row[0];
                String cfoName=respoApex.GDSSDKResponse[11].Rows[0].Row[0];
                String companyStreet=respoApex.GDSSDKResponse[12].Rows[0].Row[0];
                String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                String countryName=respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                String totalNo = respoApex.GDSSDKResponse[15].Rows[0].Row[0];
                totalNo = totalNo.split('\\.')[0];
                lead.Total_No_of_employees__c=totalNo;
                if(respoApex.GDSSDKResponse[16].Rows[0].Row[0] != 'Data Unavailable'){
                    lead.Website=respoApex.GDSSDKResponse[16].Rows[0].Row[0];
                }
                
                lead.Company_Overview__c=respoApex.GDSSDKResponse[17].Rows[0].Row[0];
                lead.Year_Founded__c=respoApex.GDSSDKResponse[18].Rows[0].Row[0];
                //    String competeterAll=respoApex.GDSSDKResponse[19].Rows[0].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[19].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[19].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[19].Rows[4].Row[0];
                lead.Chairman_Name__c = respoApex.GDSSDKResponse[20].Rows[0].Row[0];
                lead.Country_of_Incorporation__c = respoApex.GDSSDKResponse[21].Rows[0].Row[0];
                String companyPhone = respoApex.GDSSDKResponse[22].Rows[0].Row[0];
                String ultParentCAPIQ = respoApex.GDSSDKResponse[23].Rows[0].Row[0];
                lead.Company = respoApex.GDSSDKResponse[24].Rows[0].Row[0];
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
    */          String ebit = respoApex.GDSSDKResponse[39].Rows[0].Row[0];
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
                lead.Earnings_Before_Interest_and_Taxes_EBIT__c = decimal.valueOf(ebit);
                lead.Total_Equity__c = decimal.valueOf(respoApex.GDSSDKResponse[40].Rows[0].Row[0]);
                String iqRev =respoApex.GDSSDKResponse[41].Rows[0].Row[0];
                if(iqRev !='Data Unavailable'){
                    try{
                    spliters = iqRev.split('\\.');
                    iqRev = spliters[0]+'.';
                    spliters = spliters[1].split('');
                    iqRev = iqRev+spliters[0];           
                }catch(Exception e){
                    
                }
        
                }
                lead.Total_Revenue__c  = decimal.valueOf(iqRev);
                lead.Total_Assets__c = decimal.valueOf(respoApex.GDSSDKResponse[42].Rows[0].Row[0]);
                lead.EBITDA__c = decimal.valueOf(respoApex.GDSSDKResponse[43].Rows[0].Row[0]);
                lead.Net_Income__c = decimal.valueOf(respoApex.GDSSDKResponse[44].Rows[0].Row[0]);
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
                lead.Gross_Profit__c = decimal.valueOf(gp);
                lead.Total_Current_Liabilities__c = decimal.valueOf(respoApex.GDSSDKResponse[46].Rows[0].Row[0]);
                lead.Currency_Format__c = 'INR in Millions';
                lead.Total_Current_Assets__c  = decimal.valueOf(respoApex.GDSSDKResponse[47].Rows[0].Row[0]);
                lead.Total_Liabilities__c = decimal.valueOf(respoApex.GDSSDKResponse[48].Rows[0].Row[0]);
                lead.Total_Revenue__c = decimal.valueOf(respoApex.GDSSDKResponse[49].Rows[0].Row[0]);
                lead.Total_Debt__c = decimal.valueOf(respoApex.GDSSDKResponse[50].Rows[0].Row[0]);
                lead.External_Database_Source__c = 'CapIQ';
                //String holderName  = respoApex.GDSSDKResponse[51].Rows[0].Row[0]+ ' , ' + respoApex.GDSSDKResponse[51].Rows[1].Row[0] +' , ' + respoApex.GDSSDKResponse[51].Rows[2].Row[0] + ' , ' + respoApex.GDSSDKResponse[51].Rows[3].Row[0] + ' , '+respoApex.GDSSDKResponse[51].Rows[4].Row[0];
                String iqISIN /*= respoApex.GDSSDKResponse[52].Rows[0].Row[0]*/;
                String keyDevId = respoApex.GDSSDKResponse[53].Rows[0].Row[0];
                String fYear = respoApex.GDSSDKResponse[55].Rows[0].Row[0];
                decimal fy = decimal.valueOf(fYear);
                fYear = string.valueOf(fy) + '-' + string.valueof(fy+1).right(2);
                lead.Financial_Year__c = fYear;
                lead.Client_Group_Name__c = respoApex.GDSSDKResponse[56].Rows[0].Row[0];
                lead.Client_Group_Name_CIQID__c = respoApex.GDSSDKResponse[57].Rows[0].Row[0];
                lead.Global_Ultimate_Owner_ID__c = respoApex.GDSSDKResponse[58].Rows[0].Row[0];
                
            }
            catch(Exception e){
                System.debug('Exception');
            }
            /*try{
                String city=respoApex.GDSSDKResponse[13].Rows[0].Row[0];
                String companyAddress = respoApex.GDSSDKResponse[25].Rows[0].Row[0];
                String companyZIP = respoApex.GDSSDKResponse[26].Rows[0].Row[0];
                String state = respoApex.GDSSDKResponse[27].Rows[0].Row[0];
                String companyStreet1 = respoApex.GDSSDKResponse[28].Rows[0].Row[0];
                lead.Company_HQ__CountryCode__s = respoApex.GDSSDKResponse[14].Rows[0].Row[0];
                
                lead.CompanyHQ__Street__s = companyStreet1;
                lead.CompanyHQ__PostalCode__s = companyZIP;
                lead.CompanyHQ__StateCode__s = state;
                lead.CompanyHQ__City__s=city;
            }
            catch(Exception e){
                
            }*/
           String boardMember;
    
            try{
                boardMember = respoApex.GDSSDKResponse[33].Rows[0].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[0].Row[0]+') ';
    
                for(Integer i=1;i<10;i++)
                {
                    
                    boardMember =boardMember + ';  '+ respoApex.GDSSDKResponse[33].Rows[i].Row[0]+ '  (' +respoApex.GDSSDKResponse[34].Rows[i].Row[0]+')  ';
                }
            }
            catch(Exception e)
            {
            }
            
            lead.Board_of_Directors__c =  boardMember;
            System.debug('Currency format : ' + lead.Currency_Format__c);
            update lead;
            System.debug('companyID : ' + companyID);
            if(companyId == 'Data Unavailable' || companyId == ''){
                System.debug('false');
                return false;
            }
            else{
                System.debug('true');
                return true;
            }
            
            
        }
        
        //Created By Gaurav Kumar 
        //Date :18-April-2023
        //Description : Enrich Data From External Database button Accebility for Sector Business Partner  
        @AuraEnabled
        public static String getCurrentUserProfile(){
            Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
            System.debug('Current Profile :'+p.Name);
            return p.Name;
        }
    }