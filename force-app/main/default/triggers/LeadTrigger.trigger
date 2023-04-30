trigger LeadTrigger on Lead (before insert,before update,after update,after insert) {
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            LeadTriggerHandler.updateLeadStatusOnClienTakeOn(Trigger.new,Trigger.oldMap);
            LeadTriggerHandler.makeCommentMandatory();
            LeadTriggerHandler.isBeforeUpdateMethod(Trigger.new,Trigger.oldMap);
            //LeadTriggerHandler.updateLeadStatusOnInternalExternal(Trigger.new,Trigger.oldMap); //Suraj kumar
            //LeadTriggerHandler.updateLeadStatusOnClienTakeOn(Trigger.new,Trigger.oldMap);  // Suraj Kumar
            //LeadTriggerHandler.validationOnSubmit(Trigger.new, Trigger.oldMap);// Suraj Kumar
            
           // List<ID> nslLeadList=new List<Id>();
            for(Lead leadObj: Trigger.new){
                if(leadObj.NSLApprovalStatus__c=='Approved' && leadObj.WCGTStatus__c == Null){
                    salesforceToWCGT.sendWhenNSLApprovedNewClient(leadObj.Id);
                }
                if(leadObj.Status=='Accept Client' && leadObj.WCGTStatus__c == 0){
                    salesforceToWCGT.sendWhenNSLApprovedNewClient(leadObj.Id);
                }
                if(leadObj.Status=='NotAccept' && leadObj.WCGTStatus__c == 0){
                    salesforceToWCGT.sendWhenNSLApprovedNewClient(leadObj.Id);
                }
                //Gaurav Kumar
                if(leadObj.Category__c=='Cold'){
                    LeadTriggerHandler.notUpdateRecordIfProspectCategoryCold(Trigger.new,Trigger.oldMap);
                }
                
              /*  String mobiletest = leadObj.MobilePhone;                
                if(leadObj.CountryCode__c == 'India (+91)' && mobiletest.startsWith('0') ){
                    leadObj.addError('Number can not start with Zero');
                }*/
            }
         
            List<Lead> leadList = new List<Lead>();
            List<Lead> leadList1 = new List<Lead>();
            for(Lead leadObj: Trigger.new){
                if(leadObj.CCApprovalStatus__c!=Trigger.oldMap.get(leadObj.Id).CCApprovalStatus__c){
                    leadList.add(leadObj);
                }
                if(leadObj.NSLApprovalStatus__c!=Trigger.oldMap.get(leadObj.Id).NSLApprovalStatus__c){
                    leadList1.add(leadObj);
                }
            }
            System.debug('lead list cc approval'+leadList);
            if(leadList.size()>0){
                LeadTriggerHandler.updateApprovalFieldsOfCCOnEnquiry(leadList); 
            }
            if(leadList1.size()>0){
                LeadTriggerHandler.updateApprovalFieldsOfNSLOnEnquiry(leadList1);
            }
            List<Lead> leadUpdateList = new List<Lead>();
            for(Lead leadObj: Trigger.new){
                if(leadObj.Status!=Trigger.oldMap.get(leadObj.Id).Status){
                    leadUpdateList.add(leadObj);
                }
            }
            System.debug('lead id'+leadUpdateList);
            //  LeadTriggerHandler.AgingOfStage(leadUpdateList);
            LeadTriggerhandler.isBeforeUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
        if(Trigger.isInsert){
            //System.debug('Lead Source :'+trigger.new[0].LeadSource);
            //System.debug('Channel :'+trigger.new[0].Channel__c);
            if(trigger.new[0].LeadSource=='Manual' && trigger.new[0].LeadSource!=null && trigger.new[0].Channel__c != 'Visiting card'){
                checkDuplicateClientOnLeadCreation.checkDuplicateClient(Trigger.new);
            }
            LeadTriggerHandler.isBeforeInsert(Trigger.new); 
            
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            LeadTriggerHandler.isAfterUpdateMethod(Trigger.new,Trigger.oldMap);
            if(Trigger.new[0].LeadSource =='Website' && Trigger.new[0].status =='New' && Trigger.new[0].NSL__c !=null && Trigger.new[0].Sector__c !=null){
                // LeadTriggerHandler.isAfterInsertMethod(Trigger.new);
                // LeadTriggerHandler.isAfterUpdateMethod(Trigger.new,Trigger.oldMap);
                
            } 
            //By Bhanwar
            for(Lead lead: Trigger.New){
                Lead oldLead = Trigger.oldMap.get(lead.ID);
                if(lead.capIQId__c != oldLead.capIQId__c && oldLead.capIQId__c != '' && lead.External_Database_Source__c != 'None'){
                    String obj = 'Lead';
                    createCompetitor.deleteOldCompetitor(lead.Id, lead.capIQId__c, obj );
                    createInvestors.deleteOldInv(lead.Id, lead.capIQId__c, obj);
                    createClientNews.deleteOldClientNews(lead.Id, lead.capIQId__c, obj);
                    createSubsidiarys.deleteOldSubsidiarys(lead.Id, lead.capIQId__c, obj);
                    createJointVenture.deleteOldJV(lead.Id, lead.capIQId__c, obj);
                }
            }
        
        }
        if(Trigger.isInsert){
            //Suresh Gupta: 
            //Sending mail to prospect
            //last modified by  : Gaurav Kumar
	        //last modified on  : 28/02/2023
            for(Lead leadObj: Trigger.new){
                if(leadObj.Email != NULL){
                    LeadTriggerHandler.sendEmailToProspect(Trigger.new);
                }
            }
            //LeadTriggerHandler.isAfterInsertMethod(Trigger.new);
            for(Lead lead: Trigger.new)
            {
                if(lead.capIQId__c != '' && lead.capIQId__c != 'Data Unavailable' &&  lead.capIQId__c != NULL){
                    String obj = 'Lead';
                createCompetitor.createCompetitorFromCAPIQ(lead.Id, lead.capIQId__c, obj );
                createInvestors.createInvestorsFromCAPIQ(lead.Id, lead.capIQId__c, obj);
                createClientNews.createClientNewsFromCAPIQ(lead.Id, lead.capIQId__c, obj);
                createSubsidiarys.createSubsidiarysFromCAPIQ(lead.Id, lead.capIQId__c, obj);
                createJointVenture.createJointVentureFromCAPIQ(lead.Id, lead.capIQId__c, obj);
                }
            }
        }
    }
}