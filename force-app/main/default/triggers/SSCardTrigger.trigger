/*
* Author :Gaurav Kumar 
* Class :SSCardTriggerHelper
* Date :09/01/2023
*/
trigger SSCardTrigger on sansancard__SSCard__c (before insert ,after insert,after delete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            SSCardTriggerHelper.insertLeadFromVisitingCard(Trigger.new);
        }
    }
}