trigger TaskTrigger on Task (before insert,before update,after update,after insert,after delete) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            TaskTriggerHandler.IsBeforeInsert(Trigger.new);
        }else if(trigger.isUpdate){
            
        }
    }else if(trigger.isAfter){
        if(trigger.isInsert){
            
        }else if(trigger.isUpdate){
            
        }
    }
}