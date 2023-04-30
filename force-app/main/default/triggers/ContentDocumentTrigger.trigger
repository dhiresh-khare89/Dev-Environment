trigger ContentDocumentTrigger on ContentDocument (before insert) {
    IF (Trigger.isInsert) {  
        Set<Id> oppIds = new Set<Id>();
    for(ContentDocument att : trigger.New){
         if(att.ParentId.getSobjectType() == IntegratedEnquiry__c.SobjectType){
              oppIds.add(att.ParentId);
         }
    }
    leegalityDocApiCallout.sendDocToEnquiryOwner(oppIds);
    }

}