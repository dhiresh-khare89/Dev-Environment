trigger IntegratedEnquiryTriggger on IntegratedEnquiry__c (before insert,after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            IntegratedEnquiryTriggerHandler.isAfterInsert(Trigger.New, Trigger.newMap);
        }
    }
	if(Trigger.isBefore){
        if(Trigger.isInsert){
            IntegratedEnquiryTriggerHandler.isBeforeInsert(Trigger.New);
        }
    }
    
}