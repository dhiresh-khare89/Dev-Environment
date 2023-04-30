trigger enquiryTrigger on Opportunity (before insert, before update ,after insert) {
    //Before Event
    if(Trigger.isBefore) {
        //Before Insert Event
        if(Trigger.isInsert) {
            EnquiryTriggerHelper.isBeforeInsert(Trigger.new, Null);
            
        }
        if(Trigger.isUpdate){
            EnquiryTriggerHelper.isBeforeUpdate(Trigger.new,Trigger.oldMap);
            List<Opportunity> opportunityList = new List<Opportunity>();
            for(Opportunity opportunityObj : Trigger.new){
                if(opportunityObj.StageName!=Trigger.oldMap.get(opportunityObj.Id).StageName && opportunityObj.StageName=='Nurture & Finalizing Closure'){
                    opportunityList.add(opportunityObj);
                }
            }
            EnquiryTriggerHelper.captureNurtureStageDate(opportunityList);
            List<Opportunity> oppoList = new List<Opportunity>();
            List<Opportunity> updateEnquiryFields = new List<Opportunity>();
            for(Opportunity oppoObj: Trigger.new){
                if(oppoObj.StatusDSTeamRemarkStatus__c!=Trigger.oldMap.get(oppoObj.Id).StatusDSTeamRemarkStatus__c){
                    oppoList.add(oppoObj);
                }
                if(oppoObj.Pick_Record__c==true){
                    updateEnquiryFields.add(oppoObj);
                }
            }
            if(oppoList.size()>0){
                EnquiryTriggerHelper.updateDSTeamApprovalFields(oppoList); 
            }
            if(!updateEnquiryFields.isEmpty()){
                EnquiryTriggerHelper.updateEnquiryFields(updateEnquiryFields);
            }
            //
            List<Opportunity> clientCouncilOpporList = new List<Opportunity>();
            for(Opportunity oppoObj: Trigger.new){
                if(oppoObj.CCApprovalStatus__c!=Trigger.oldMap.get(oppoObj.Id).CCApprovalStatus__c){
                    clientCouncilOpporList.add(oppoObj);
                }
            }
            if(oppoList.size()>0){
                EnquiryTriggerHelper.updateApprovalFieldsOfCCOnEnquiry(clientCouncilOpporList); 
            }
            //Suresh
            
            for(Opportunity oppoObj: Trigger.new){
                EnquiryTriggerHelper.updateCurrAndCompSteps(Trigger.new);
                system.debug('Testing Trigger');
            }
        }
        
        for(Opportunity opp : Trigger.new ){
            if(opp.IsClosed){
                salesforceToWCGT.sendWhenEnquiryCreated(opp.Id);
            }
            }
        
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<Id> oppId=new list<id>{trigger.new[0].Id};
                if(oppId.size()>0){
                    for(Id ids : oppId){
                        EnquiryTriggerHelper.callCreateEnquiryApi(ids);
                    }
                }
            EnquiryTriggerHelper.isAfterInsert(Trigger.new, Trigger.newMap);
        }
        if(Trigger.isUpdate){
            EnquiryTriggerHelper.isAfterUpdate(Trigger.new, Trigger.oldMap);
            
            
            
        }
        
    }
    //Gaurav Kumar
    //03/01/2023
    if(Trigger.isBefore && Trigger.isInsert){
        EnquiryTriggerHelper.isAfterInsertOnDuplicateRule(Trigger.new);
    }
}