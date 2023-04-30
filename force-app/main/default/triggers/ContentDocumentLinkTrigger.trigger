trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
 if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            ContentDocumentLinkTriggerHandler.isAfterInsert(Trigger.new);
        }
    }
    
}