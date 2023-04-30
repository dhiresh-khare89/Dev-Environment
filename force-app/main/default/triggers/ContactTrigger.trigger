trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            List<Contact> contactListIds = new List<Contact>();
            List<Contact> contactList = new List<Contact>();
            for(Contact cc:Trigger.New){
                if(cc.Pick_Record__c!= Trigger.oldMap.get(cc.id).Pick_Record__c && cc.Pick_Record__c==true){
                    contactListIds.add(cc);
                }
                if(cc.DS_Team_Approval_Status__c!=Trigger.oldMap.get(cc.Id).DS_Team_Approval_Status__c){
                    contactList.add(cc);
                }
            }
            ContactTriggerHelper.sendDSTeamApprovalRequest(contactListIds);
            if(contactList.size()>0){
                ContactTriggerHelper.updateDSTeamApprovalFields(contactList); 
            }
            
            
        }
    }
}