/* 
     Written By: Bhanwar Singh
     Created Date: 1/12/2023
     Last Modified By : Bhanwar Singh
     Last Modified Date : 27-04-23
     Description : This class is used to find data from MCA. 
     Variable Used in Method : - 
       searchString : - Company Name from LWC component.
       mcaId : - Company MCA Id
*/

public class newClientDataFromMCA {
    @AuraEnabled
    public static  Map<String,String> newClientCompanySearchByName(String searchString){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Search API' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"","filter":{"name":"'+searchString+'","email":"","domain":"","domainSearch":false,"address":"India","contact":"","fatherName":"","dateOfInception":""},"entitySearch":false,"nameMatch":true,"nameMatchThreshold":false,"sources":["mca", "mca_director", "pan", "gst", "iec", "tan", "epf", "udyam", "udyog_aadhaar", "lin", "lei","startup_recognition"]}';
        req.setTimeout(30000);
        System.debug('resp.getBody() --->'+reqBody);
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaEntitySearchWrapperMain respoApex=(mcaEntitySearchWrapperMain) System.JSON.deserialize(resp.getBody(), mcaEntitySearchWrapperMain.class);
        Map<String,String> listCompany = new Map<String,String>();
        
            try{
                for(Integer i=0;i<20;i++){
                String str;
                    if(respoApex.result[i].location != Null){
                        str = respoApex.result[i].name + '  ' +respoApex.result[i].location;
                    }
                    else{
                        str = respoApex.result[i].name;
                    }
                listCompany.put(respoApex.result[i].kid,str);
            }
            }
            Catch(Exception e){
                ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'newClientCompanySearchByName' , '' , reqBody,resp.getBody(), entitySearch.URL__c );
            }
        
           
        System.debug(listCompany);    
        return listCompany;
    }
    @AuraEnabled
    public static List<String> newClientCompanySearchEnityData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Profile - DataBase API' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"id":"'+mcaId+'","template":"karza_test"}';
        req.setTimeout(30000);
        req.setBody(reqBody);
        List<String> results = new List<String>(); 
        HttpResponse resp;
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        try{
            resp = http.send(req); 
            
            mcaEntityDataBaseWrapper respoApex=(mcaEntityDataBaseWrapper) System.JSON.deserialize(resp.getBody(), mcaEntityDataBaseWrapper.class);
            String regAdd = respoApex.Result.profile.registeredAddress;
            results.add(regAdd);
            String status = respoApex.Result.statutoryRegistration.Lei[0].entityStatus;
            results.add(status);
            String symbol = respoApex.Result.statutoryRegistration.ExchangeInformation.NseSecurity[0].symbol;
            results.add(symbol);
            String countryofINC = respoApex.Result.statutoryRegistration.mca[0].countryOfIncorporation;
            results.add(countryofINC);
            String domParent = respoApex.Result.statutoryRegistration.Lei[0].dparentName;
            results.add(domParent);
            String isin = respoApex.Result.statutoryRegistration.ExchangeInformation.BseSecurity[0].isin;
            results.add(isin);
            String ultParent = respoApex.Result.statutoryRegistration.Lei[0].uparentName;
            results.add(ultParent);
            
            String dateofINC = respoApex.Result.profile.dateOfIncorporation;
            results.add(dateofINC);
            String classZ = respoApex.Result.statutoryRegistration.mca[0].class_Z;
            results.add(classZ);
            String listingStatus = respoApex.Result.statutoryRegistration.mca[0].listingStatus;
            results.add(listingStatus);
            String industry = respoApex.Result.statutoryRegistration.mca[0].industry;
            results.add(industry);
            String email = respoApex.Result.profile.email;
            results.add(email);
            String contact = respoApex.Result.profile.contact;
            results.add(contact);
            String bod = newClientDataFromMCA.newClientBODMCA(resp.getBody());
            results.add(bod);
            String website = respoApex.Result.statutoryRegistration.ExchangeInformation.BseSecurity[0].websites[0];
            results.add(website);
        }
        catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'newClientCompanySearchEnityData' , '' , reqBody,resp.getBody(), entitySearch.URL__c );
        }
        for(String str : results){
            System.debug(str);
        }
        return results;
    }
    public static string newClientBODMCA(String respBody){
        String bod = '';
        try{
            mcaEntityDataBaseWrapper respoApex=(mcaEntityDataBaseWrapper) System.JSON.deserialize(respBody, mcaEntityDataBaseWrapper.class);
            bod = respoApex.Result.Management.Current[0].name + ' (' +respoApex.Result.Management.Current[0].designation+' Email:- ' +respoApex.Result.Management.Current[0].email+')' ;
            for(integer i=1;i<20;i++){
                bod = bod +' , ' + respoApex.Result.Management.Current[i].name + ' (' +respoApex.Result.Management.Current[i].designation+' Email:- ' +respoApex.Result.Management.Current[i].email+')';
            }
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'newClientDataFromMCA' , 'newClientBODMCA' , '' , '',respBody, '' );
        }
        return bod;
    }
    
    // MCA Entity Profile URL for Address and Directors
    @AuraEnabled
    public static  void newClientCompanySearchEnityProfile(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        MCA__mdt  entitySearch = [SELECT x_karza_key__c, URL__c ,Label FROM MCA__mdt Where Label = 'Entity Profile' Limit 1];
        req.setEndpoint(entitySearch.URL__c);
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key',entitySearch.x_karza_key__c);
        
        String reqBody = '{"entityId":"'+mcaId+'","consent":"y"}';
        req.setTimeout(30000);
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        MCAEntityProfileWrapper_cls respoApex=(MCAEntityProfileWrapper_cls) System.JSON.deserialize(resp.getBody(), MCAEntityProfileWrapper_cls.class);
        //System.debug(respoApex.Result.Management.Current[1].name);
        System.debug(respoApex);
    }
    
    @AuraEnabled
    public static List<String> newClientCompanySearchCorpFinanceData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.kscan.in/v1/corp/docs/details/financial');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
        
        String reqBody = '{"entityId":"'+mcaId+'","financialYear":["2019-20"],"financialType":"both","noOfYearsToMerge":"1","consent":"y"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaCorpFinanceWrapper respoApex=(mcaCorpFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaCorpFinanceWrapper.class);
        List<String> listCorpFinance = new List<String>();
        try{
            System.debug(respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets);
        String totalAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalAssets;
        String totalCurrentAssets = respoApex.Result.Financial[0].Data.Current.BalanceSheet.Assets.totalCurrentAssets;
        String currentLiabilties = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.currentLiabilties;
        String nonCurrentFinancialLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.nonCurrentFinancialLiabilities;
        String totalEquity = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalEquity;
        String totalLiabilities = respoApex.Result.Financial[0].Data.Current.BalanceSheet.EquityLiabilities.totalLiabilities;
        String totalDilutedEarningsLossPerShare = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.totalDilutedEarningsLossPerShare;
        String totalRev = respoApex.Result.Financial[0].Data.Current.ProfitAndLoss.Revenue.totalRev;
        
        listCorpFinance.add(totalAssets);
        listCorpFinance.add(totalCurrentAssets);
        listCorpFinance.add(currentLiabilties);
        listCorpFinance.add(nonCurrentFinancialLiabilities);
        listCorpFinance.add(totalEquity);
        listCorpFinance.add(totalLiabilities);
        listCorpFinance.add(totalDilutedEarningsLossPerShare);
        listCorpFinance.add(totalRev);
        System.debug(listCorpFinance);
        }
        catch(Exception e){
            
        }
        return listCorpFinance;
    }
    @AuraEnabled
    public static List<String> newClientCompanySearchFinanceData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.kscan.in/v3/corp/docs/financialSummary');
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
        
        String reqBody = '{"consent":"Y","entityId":"'+mcaId+'","financialYear":["2020-21"],"financialType":"both"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaFinanceWrapper respoApex=(mcaFinanceWrapper) System.JSON.deserialize(resp.getBody(), mcaFinanceWrapper.class);
        System.debug(respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss);
        List<String> listCorpFinance = new List<String>();
        String profitLoss = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.profitLoss;
        String ebit = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebit;
        String ebitda = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.ebitda;
        String revenuefromOperations = respoApex.Result.Standalone[0].Data.CurrentFinancialSummary.IncomeState.revenuefromOperations;
        try{
            listCorpFinance.add(profitLoss);
        listCorpFinance.add(ebit);
        listCorpFinance.add(ebitda);
        listCorpFinance.add(revenuefromOperations);
        }
        catch(Exception e){

        }
        return listCorpFinance;
    }
    @AuraEnabled
    public static String newClientCompanyCrossDirectorShipCurrentData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.kscan.in/v3/common-director');
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
        
        String reqBody = '{"id":"'+mcaId+'","directorship":"cross"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaCrossDirCurrentWrapper respoApex=(mcaCrossDirCurrentWrapper) System.JSON.deserialize(resp.getBody(), mcaCrossDirCurrentWrapper.class);
        String dir = respoApex.Result[0].Directors[0].name + '(' + respoApex.Result[0].Directors[0].dateOfAppointment +') ';
        try{
            
            for(Integer i=1;i<10;i++){
                dir = dir +' ; '+ respoApex.Result[0].Directors[i].name + '(' + respoApex.Result[0].Directors[i].dateOfAppointment +') ';
            }
        }
        catch(Exception e){

        }
        return dir;
    }
    @AuraEnabled
    public static String newClientCompanyCrossDirectorShipFormerData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.kscan.in/v3/common-director');
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
        
        String reqBody = '{"id":"'+mcaId+'","directorship":"past"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaCrossDirFormerWrapper respoApex=(mcaCrossDirFormerWrapper) System.JSON.deserialize(resp.getBody(), mcaCrossDirFormerWrapper.class);
        String dir = respoApex.Result[0].FormerDirectors[0].name + '(' + respoApex.Result[0].FormerDirectors[0].tenureEndDate +') ';
        try{
            
            for(Integer i=1;i<10;i++){
                dir = dir +' ; '+ respoApex.Result[0].FormerDirectors[i].name + '(' + respoApex.Result[0].FormerDirectors[i].tenureEndDate +') ';
            }
        }
        catch(Exception e){

        }
        return dir;
    }
    @AuraEnabled
    public static void newClientAlertsData(String mcaId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://testapi.kscan.in/v3/alerts');
       
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
        
        String reqBody = '{"id":"'+mcaId+'"}';
        req.setBody(reqBody);

        HttpResponse resp = http.send(req);        
		// InputRequests respoApex=(InputRequests) System.JSON.deserialize(resp.getBody(), InputRequests.class);
        System.debug('resp.getBody() --->'+resp.getBody());
        mcaAlertsWrapper respoApex=(mcaAlertsWrapper) System.JSON.deserialize(resp.getBody(), mcaAlertsWrapper.class);
        System.debug(respoApex);
        /*String dir = respoApex.Result[0].FormerDirectors[0].name + '(' + respoApex.Result[0].FormerDirectors[0].tenureEndDate +') ';
        try{
            
            for(Integer i=1;i<10;i++){
                dir = dir +' ; '+ respoApex.Result[0].FormerDirectors[i].name + '(' + respoApex.Result[0].FormerDirectors[i].tenureEndDate +') ';
            }
        }
        catch(Exception e){

        }*/
        
    }
}