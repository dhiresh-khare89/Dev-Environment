public class ContentDocumentLinkTriggerHandler {
    //-------------------------Method for updating after insert context-------------------------------------------------------
    public static void isAfterInsert(List<ContentDocumentLink> ContentDocumentLinkList) {
        insertFileRelatedInformationInACustomObject(ContentDocumentLinkList); 
    }
    
     //-------------------------Inserting file related information in a custom object-------------------------------------------
    public static void insertFileRelatedInformationInACustomObject(List<ContentDocumentLink> ContentDocumentLinkList) {
        try{ 
            List<FileRelatedInformation__c> cusFilObjList = new List<FileRelatedInformation__c>();
            Set<Id> linkEntitId = new Set<Id>();
            Set<Id> contDocId = new Set<Id>();
            List<Opportunity> oppObjList = new List<Opportunity>();
            
            for(ContentDocumentLink cntDocLink : ContentDocumentLinkList){
                if(String.isNotBlank(cntDocLink.LinkedEntityId) && String.isNotBlank(cntDocLink.ContentDocumentId)){
                    linkEntitId.add(cntDocLink.LinkedEntityId);
                    contDocId.add(cntDocLink.ContentDocumentId);
                    System.debug('contDocId : '+contDocId);
                }
            }
            List<User> userList = [Select Id From User Where Id =: linkEntitId];
            System.debug('userList=='+userList); 
            String idObj = '';
            String accName = '';
            if(linkEntitId.size() > 0){
                List<ContentDocumentLink> cntDocLinkList = [SELECT ContentDocument.Title, LinkedEntity.Name, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:linkEntitId AND ContentDocumentId =:contDocId AND LinkedEntityId Not In: userList];
                System.debug('cntDcLinkList : '+cntDocLinkList);
                
                System.debug('linkEntitId : '+linkEntitId);
                List<Contact> cntList = [SELECT AccountId FROM Contact WHERE Id =:linkEntitId];
                System.debug('cntList : '+cntList);
                
                if(cntList.isEmpty()) {
                    oppObjList = [SELECT Id,AccountId,StageName,Expertise__c FROM Opportunity WHERE Id =:linkEntitId];
                    System.debug('oppObjList : '+oppObjList); 
                }
                
                if(cntList.size()>0){
                    idObj = cntList[0].AccountId;
                    System.debug('idObj Contact : '+idObj);
                } else if(oppObjList.size()>0){
                    idObj = oppObjList[0].AccountId;
                    System.debug('idObj Contact : '+idObj);
                }
                else{
                    idObj = '';
                }
                Account acc = [SELECT Id, Name FROM Account WHERE Id =:idObj];
                accName = acc.Name;
                System.debug('accName : '+accName);
                
                
                List<Job__c> Jobs = [SELECT Name FROM Job__c WHERE Enquiry__c =: oppObjList[0].Id]; 
                
                
                for(ContentDocumentLink cntDocLink: cntDocLinkList){
                    FileRelatedInformation__c cusFilObj = new FileRelatedInformation__c();
                    cusFilObj.Name = cntDocLink.ContentDocument.Title;
                    System.debug('cusFilObj.Name=='+cusFilObj.Name);
                    cusFilObj.RelatedClient__c = accName;
                    System.debug('cusFilObj.RelatedClient__c=='+cusFilObj.RelatedClient__c);
                    cusFilObj.EnquiryStage__c = oppObjList[0].StageName;
                    System.debug('cusFilObj.EnquiryStage__c=='+cusFilObj.EnquiryStage__c);
                    cusFilObj.Expertise__c = oppObjList[0].Expertise__c;
                    System.debug('cusFilObj.Expertise__c=='+cusFilObj.Expertise__c);
                    if(!Jobs.isEmpty()){
                        cusFilObj.Name = Jobs[0].Name ;
                        System.debug('cusFilObj.Name=='+cusFilObj.Name);
                    }
                    
                    cusFilObj.ParentName__c = cntDocLink.LinkedEntity.Name;
                    System.debug('cusFilObj.ParentName__c=='+cusFilObj.ParentName__c);
                    cusFilObj.FileURL__c = 'https://grantthornton--dev1.sandbox.lightning.force.com/lightning/r/ContentDocumentt/'+cntDocLink.ContentDocumentId+'/view';
                    cusFilObjList.add(cusFilObj);
                }
                
                if(!cusFilObjList.isEmpty()){
                    System.debug('cusFilObjList : '+cusFilObjList);
                    insert cusFilObjList;
                }
            }
        }
        catch(Exception e) {
            System.debug(e);
        }

    }

}