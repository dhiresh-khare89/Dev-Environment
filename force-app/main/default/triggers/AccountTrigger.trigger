trigger AccountTrigger on Account (before insert,before update,after update,after insert) {
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            List<Account> acctListIds = new List<Account>();
            List<Account> acctList = new List<Account>();
            List<Account> acctProposedList = new List<Account>();
            for(Account acc:Trigger.New){
                if(acc.Pick_Record__c!= Trigger.oldMap.get(acc.id).Pick_Record__c && acc.Pick_Record__c==true){
                  acctListIds.add(acc);
                }
                if(acc.Status_DS_Team_Remark_Status__c!=Trigger.oldMap.get(acc.Id).Status_DS_Team_Remark_Status__c){
                    acctList.add(acc);
                }
                if(acc.OwnerId!=Trigger.oldMap.get(acc.Id).OwnerId && acc.Proposed_Account_Owner_Approval_Status__c=='Approved'){
                    acctProposedList.add(acc);
                }
            }
            AccountTriggerHelper.sendDSTeamApprovalRequest(acctListIds);
            if(acctList.size()>0){
                AccountTriggerHelper.updateDSTeamApprovalFields(acctList); 
                AccountTriggerHelper.sendEmailToProposedOwner(acctProposedList);
            }
            if(acctProposedList.size()>0){
                AccountTriggerHelper.sendEmailToProposedOwner(acctProposedList);
            }
        }
    }
    //Bhanwar 
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert){
            for(Account acc : Trigger.New)
            {
                String obj = 'Account';
                createInvestors.createInvestorsFromCAPIQ(acc.Id,acc.capIQId__c , obj);
                createCompetitor.createCompetitorFromCAPIQ(acc.Id,acc.capIQId__c , obj);
                createClientContact.createContactFromCAPIQBOD(acc.Id , acc.capIQId__c );
                createClientContact.createContactFromCAPIQProfessional(acc.Id , acc.capIQId__c);
                createClientNews.createClientNewsFromCAPIQ(acc.Id, acc.capIQId__c, obj);
                
            }
        }
    }
}