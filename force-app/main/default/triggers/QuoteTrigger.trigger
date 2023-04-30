trigger QuoteTrigger on Quote (before insert) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            QuoteTriggerHandler.isBeforeInsert(Trigger.new); 
        }
    }
}