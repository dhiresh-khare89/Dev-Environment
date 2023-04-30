public class leegalityDocApiCallout {
    public static String sendDocToEnquiryOwner(Set<id> listEnquryids)
    {
        for(Id currentIntOppId : listEnquryids)
        {
            Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sandbox.leegality.com/api/v3.0/sign/request');
            req.setMethod('POST');
        String clientName = 'Bhanwar Singh';
        String clientEmail= 'bhanwar706@techmatrixconsulting.in';
        String clientPhone = '';
        String username = 'bhanwar706@techmatrixconsulting';
        String password = 'Welcome@1'; 
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        req.setHeader('X-Auth-Token','EDAUzsIrZGlyIOrxb5JrmDMC2Rrl6qPH');
        
        List <ContentDocumentLink> a = [SELECT Id, LinkedEntityId, ContentDocumentId,Visibility, ShareType,ContentDocument.Title,ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:currentIntOppId];
        Blob pdfBody;
        System.debug('pdfBody   --> '+pdfBody);
        String file = EncodingUtil.base64Encode(pdfBody);
        String reqBody = '{ "profileId" : "jEW7UzG","file" : { "name" : "Doc","file" : "' + 
            file + '" },"invitees" : [ {"name" : "' + clientName  +'","email" : " '
            +clientEmail+'","phone" : "'+clientPhone+'"} ],"irn" : "'+ currentIntOppId+  '"}';
        req.setBody(reqBody);
        HttpResponse resp = http.send(req);
        }
        String resp1;
        return resp1;
    }
}