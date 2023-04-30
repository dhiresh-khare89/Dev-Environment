public class mcatoSalesforceData {
    public static String getFinancialSummary(){
        	Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://testapi.kscan.in/v3/corp/docs/financialSummary');
            req.setMethod('POST');
            req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Accept','*/*'); 
            String reqBody = '{"consent":"Y","entityId":"U40109MH2005SGC153645","financialYear":["2018-19"],"financialType":"both"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp --> MCA '+ resp.getBody());
            String resp1;
            return resp1;
    }
    public static String getCorpDetailFinancials(){
        	Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://testapi.kscan.in/v1/corp/docs/details/financial');
            req.setMethod('POST');
            req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Accept','*/*'); 
            String reqBody = '{"entityId":"U01114HR2017PTC067125","financialYear":["2019-20"],"financialType":"both","noOfYearsToMerge":"1","consent":"y"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp --> MCA '+ resp.getBody());
            String resp1;
            return resp1;
    }
    Public static String getEntitySearch(String Name){
        	Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://testapi.kscan.in/v3/search/byIdOrName');
            req.setMethod('POST');
            req.setHeader('x-karza-key','jmrtLRabGd7IqcIs');
            req.setHeader('Content-Type','application/json'); 
            req.setHeader('Accept','*/*'); 
            String reqBody = '{"id":"","filter":{"name":"'+Name+'","email":"","domain":"","domainSearch":,"address":"","contact":"","fatherName":"","dateOfInception":""},"entitySearch":true,"nameMatch":true,"nameMatchThreshold":false,"sources":[" "]}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp --> MCA '+ resp.getBody());
            String resp1;
            return resp1;
    }
}