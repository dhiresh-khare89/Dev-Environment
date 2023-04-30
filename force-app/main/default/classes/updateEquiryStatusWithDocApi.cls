@RestResource(urlMapping='/updateEquiryStatusWithDocApi/*')
global class updateEquiryStatusWithDocApi{
    @HTTPPUT
    global static string doPut(){
        Savepoint sp = Database.setSavepoint();
        
        try{
            RestRequest req = RestContext.request;
            blob body = req.requestBody;
            string RequestString = body.toString();
            string FinalDocumentName;
            system.debug('requested string'+RequestString);
            JsonForFinalStatusUpdateOnEnquiry jsondata = parse(RequestString);
            List<ID> listOfEnquiryIds = jsondata.childEnquiryIds.split(',');
            System.debug('listOfEnquiryIds'+listOfEnquiryIds);
            List<Opportunity> listEnquiryRecords=[Select Id,Creative_Hub_Status__c,Creative_Hub_Id__c from opportunity Where id IN :listOfEnquiryIds];
            List<IntegratedEnquiry__c> IntegratedEnquiryRecord=[Select id,Creative_Hub_Id__c, Creative_Hub_Status__c from IntegratedEnquiry__c Where Id=:jsondata.IntegratedEnquiryId limit 1];
            For(IntegratedEnquiry__c IntegratedEnquiryRec:IntegratedEnquiryRecord){
                if(jsondata.typeofDocument=='Pitch Presentation'){
                    IntegratedEnquiryRec.Pitch_Presentation_Status__c=jsondata.Creative_Hub_Status;
                    IntegratedEnquiryRec.Creative_Hub_Id__c= jsondata.Creative_Hub_ID;
                }else if(jsondata.typeofDocument=='Proposal'){
                    IntegratedEnquiryRec.Proposal_Status__c=jsondata.Creative_Hub_Status;
                    IntegratedEnquiryRec.Creative_Hub_Id__c= jsondata.Creative_Hub_ID;   
                }
            }
            database.update(IntegratedEnquiryRecord);
            For(Opportunity opp:listEnquiryRecords){
                if(jsondata.typeofDocument=='Pitch Presentation'){
                    FinalDocumentName='Pitch Deck';
                    opp.Pitch_Presentation_Status__c=jsondata.Creative_Hub_Status;
                    opp.Creative_Hub_Id__c= jsondata.Creative_Hub_ID;
                }else if(jsondata.typeofDocument=='Proposal'){
                    FinalDocumentName='Proposal';
                    opp.Proposal_Status__c=jsondata.Creative_Hub_Status;
                    opp.Creative_Hub_Id__c= jsondata.Creative_Hub_ID;   
                }
                
            }
            Database.update(listEnquiryRecords);
            if(jsondata.binaryFile!=NULL){
                
                ContentVersion cv = createContentVersion(jsondata.binaryFile, FinalDocumentName,jsondata.IntegratedEnquiryId,jsondata.typeofDocument);
                return 'Successfully Uploded';
            }else{
                return 'Successfully Updated';
            }
        }catch(exception e){
            Database.rollback( sp );
            return 'Record Not Updated';
            
            
        }
    }
    
    public static JsonForFinalStatusUpdateOnEnquiry parse(String json) {
        return (JsonForFinalStatusUpdateOnEnquiry)System.JSON.deserialize(json, JsonForFinalStatusUpdateOnEnquiry.class);
    }
    
    public class JsonForFinalStatusUpdateOnEnquiry {
        public String Creative_Hub_Status;
        public String Creative_Hub_ID;
        public String IntegratedEnquiryId;
        public string childEnquiryIds;   
        public string binaryFile;
        public string typeofDocument;
    }
    private static ContentVersion createContentVersion(String base64, String filename, string idd,string docType) {
        Id contentDocumentId;
        ContentVersion cv = new ContentVersion();
        List<ContentVersion> contver;
        string finalFileName=filename;
        finalFileName=finalFileName+'.Pdf';
        system.debug('size'+[SELECT Id, ContentDocumentId , title,filetype,fileextension, IsLatest,FirstPublishLocationId  FROM ContentVersion
                             where title =:filename and FirstPublishLocationId=:idd LIMIT 1].size());
        if(docType=='Proposal'){
            contver=[SELECT Id, ContentDocumentId , title,filetype,fileextension, IsLatest,FirstPublishLocationId  FROM ContentVersion
                     where TypeOfFile__c='Proposal'and FirstPublishLocationId=:idd LIMIT 1];
        }else if(docType=='Pitch Presentation'){
            contver=[SELECT Id, ContentDocumentId ,fileextension, IsLatest,FirstPublishLocationId,TypeOfFile__c    FROM ContentVersion
                     where TypeOfFile__c='Pitch Deck' and FirstPublishLocationId=:idd LIMIT 1];
        }
        if(contver.size()!=0){
            
            contentDocumentId = [SELECT Id, ContentDocumentId , title,filetype,fileextension, IsLatest,FirstPublishLocationId  FROM ContentVersion
                                 where title =:filename and FirstPublishLocationId=:idd LIMIT 1].ContentDocumentId;
            
            cv.VersionData = EncodingUtil.base64Decode(base64);
            cv.Title = filename;    
            cv.PathOnClient = finalFileName;
            cv.TypeOfFile__c=filename;
            cv.ContentDocumentId=contentDocumentId;
            
        }else{
            cv.VersionData = EncodingUtil.base64Decode(base64);
            cv.Title = filename;
            cv.IsMajorVersion = true; 
            cv.TypeOfFile__c=filename;
            cv.FirstPublishLocationId=idd;     
            cv.PathOnClient = finalFileName;
        }    
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
}