public class uploadDoctoSalesforceLeegality {
    public static String uploadDoctoIntEnquiry()
    {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sandbox.leegality.com/api/v3.0/document/details');
        req.setMethod('GET');
        String username = 'bhanwar706@techmatrixconsulting';
        String password = 'Welcome@1'; 
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        req.setHeader('X-Auth-Token','EDAUzsIrZGlyIOrxb5JrmDMC2Rrl6qPH');
        Blob pdfBody;
        String file = EncodingUtil.base64Encode(pdfBody);
        String reqBody = '{ "documentId" : "hF7qx5o", "irn" : "0066D000007JvV0QAK"}';
        req.setBody(reqBody);
        HttpResponse resp = http.send(req);
        System.debug(resp);
        return password;
    } 
}