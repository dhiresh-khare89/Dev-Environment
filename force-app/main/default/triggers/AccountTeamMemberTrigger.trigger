trigger AccountTeamMemberTrigger on AccountTeamMember (before insert,before delete,after delete) {
    
    if(Trigger.isBefore){
        if(Trigger.isupdate){
            System.debug('before update Account Team Member'+Trigger.old);
        }
        
    }
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            System.debug('before delete Account Team Member'+Trigger.old);
        }
        
    }
    if(Trigger.isAfter){
       if(Trigger.isDelete){
        System.debug('after delete Account Team Member'+Trigger.old);
        }  
        
    }

}