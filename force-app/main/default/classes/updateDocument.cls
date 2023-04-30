@RestResource(urlMapping='/uploadDocumentOnEnquiry/*')
global without sharing class updateDocument{
    @HTTPPOST
    global static string doPost(){
        Savepoint sp = Database.setSavepoint();
        try{
            RestRequest req = RestContext.request;
            blob body = req.requestBody;
            string RequestString = body.toString();
            JsonForFinalStatusUpdateOnEnquiry jsondata = parse(RequestString);
            if(jsondata.files!=NULL){
                ContentVersion cv = createContentVersion(jsondata.files, 'File.pdf',jsondata.irn);
                
                ContentDocumentLink cdl = createContentLink(cv.Id, jsondata.irn);
                
                return 'Successfully Uploded';
            }else{
                return 'Record Not Updated';
            }
        }catch(exception e){
            Database.rollback( sp );
            return 'Record Not Updated';
            
        }
    }
    private static ContentVersion createContentVersion(String base64, String filename, string idd) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.IsMajorVersion = true;    
        cv.FirstPublishLocationId=idd;     
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    public static JsonForFinalStatusUpdateOnEnquiry parse(String json) {
        return (JsonForFinalStatusUpdateOnEnquiry)System.JSON.deserialize(json, JsonForFinalStatusUpdateOnEnquiry.class);
    }
    
    public class JsonForFinalStatusUpdateOnEnquiry {
        public String irn;  
        public string files;
    }
    
}