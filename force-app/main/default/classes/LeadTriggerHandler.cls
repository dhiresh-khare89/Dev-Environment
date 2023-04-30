public class LeadTriggerHandler {
    
    public static void isBeforeUpdate(List<Lead> newLeadList, Map<Id, Lead> oldLeadMap, Map<Id, Lead> newLeadMap){
        CannotConvertLeadIfAnyTaskOpen(newLeadList, oldLeadMap, newLeadMap);
    }
    
    public static void CannotConvertLeadIfAnyTaskOpen(List<Lead> newLeadList, Map<Id, Lead> oldLeadMap, Map<Id, Lead> newLeadMap){
    }
    
    public static void isAfterUpdateMethod(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        onNSlApprovalCloseTaskMoveToNextStage(leadList,oldLeadMap);
        updateNewClientInformationTaskStatusToCompleted(leadList,oldLeadMap);
        updateSubmitWithNSLDiscussionTaskStatusToCompleted(leadList,oldLeadMap);
        updateAssigntNewClientRecordTaskStatusToCompleted(leadList,oldLeadMap);
        updateHaveClientMeetTaskStatusToCompleted(leadList,oldLeadMap);
        updatePrepareClientCouncilDeckTaskStatusToCompleted(leadList,oldLeadMap);
        
        
        //********New Client Sharing for NSL************//by Rohitash Mourya
        
        List<ID> nslLeadList=new List<Id>();
        for(Lead leadObj: leadList){
            System.debug('leadObj.NSL__c!=Null'+leadObj.NSL__c);
            System.debug('oldLeadMap.get(leadObj.Id).NSL__c'+oldLeadMap.get(leadObj.Id).NSL__c);
            if(leadObj.NSL__c!=Null){
                
                nslLeadList.add(leadObj.Id);
            }
        }
        if(nslLeadList.size()>0){
            System.debug('test--> 30'); //Suresh Gupta 16 Feb 2023
            leadSharingForNSL.leadRecordSharingToNSL(nslLeadList,oldLeadMap);
        }
        //********New Client Sharing for Sector Bussines Partner************//by Rohitash Mourya
        List<ID> sectorLeadList=new List<Id>();
        for(Lead leadObj: leadList){
            // system.debug('------------>>>>'+ leadObj.SubmitterID__c);
            System.debug('leadObj.NSL__c!=Null'+leadObj.SectorCoordinator__c);
            System.debug('oldLeadMap.get(leadObj.Id).NSL__c'+oldLeadMap.get(leadObj.Id).SectorCoordinator__c);
            if(leadObj.SectorCoordinator__c!=Null){
                
                sectorLeadList.add(leadObj.Id);
            }
        }
        if(sectorLeadList.size()>0){
            System.debug('test--> 30'); //Suresh Gupta 16 Feb 2023
            leadSharingForNSL.leadRecordSharingToSectorCordinator(sectorLeadList,oldLeadMap);
        }
        
    }
    
    /*By :-Suresh gupta
*Date:- 22 Feb 2023
*last modified by  : Gaurav Kumar
*last modified on  : 28/02/2023
*Purpose:- to send acknowledgement mail to Prospect
*/
    /*------------------------------------------------------*/
    public static void sendEmailToProspect(List<Lead> leadList) {
        
        
        List<Messaging.SingleEmailMessage> mailsToProspect = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();
        for(Lead myLead:leadList){
            //System.debug('Source : ' + myLead.LeadSource);
            if(myLead.LeadSource =='Website' || myLead.LeadSource =='Email' || myLead.LeadSource =='Chat Bot'){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                sendTo.add(myLead.Email);
                mail.setToAddresses(sendTo);
                mail.setSubject('Thankyou email');
                String body='';
                if(myLead.FirstName != NULL){
                    body+= 'Dear ' + myLead.FirstName +' '+myLead.LastName+','  ;
                }
                else{
                    body+= 'Dear '+myLead.LastName+','  ;
                }
                body += '<br> </br>' ;
                body += '<br> Thank you for contacting Grant Thornton Bharat. We are delighted to hear from you and appreciate your interest in our services. </br></br>';
                body += '<br> </br>' ;
                body += '<br> One of our representatives will get in touch with you shortly to discuss your needs and requirements. In the interim, please feel free to browse our website to learn more about our firm and the range of services we offer.</br></br>';
                body += '<br> </br>' ;
                body += '<br> If you have any questions or concerns in the meantime, please do not hesitate to reach out to us at contact@in.gt.com.</br> </br>' ;
                body += '<br> </br>' ;
                body += '<br> Thank you again for considering Grant Thornton Bharat for your professional needs.</br>' ;
                body += '<br>' ;
                body += '<br> Best regards, </br>';
                body += '<br> The Grant Thornton Bharat Team </br>';
                body += '<br> </br>' ;
                body += '<br> Note:- This is a system generated email. Please do not reply to this mail. </br>';
                mail.setHtmlBody(body);
                mailsToProspect.add(mail);
            }    
        }
        try{
            if(!mailsToProspect.isEmpty()){
                //system.debug('Email Sent Today'+mailsToProspect);
                Messaging.sendEmail(mailsToProspect);
            }
        }catch(Exception e){
            System.debug('Error :'+e.getMessage());
            System.debug('In Line Number'+e.getLineNumber());
        }
        
        
        /*------------------------------------------------------*/
        
        /* List<Lead> newLeadList =[SELECT Name,Status From Lead Where Id IN:leadList];
newLeadList[0].Status = 'Internal / External Discussions';
update newLeadList;
// autoUpdateTheStageInCaseOfWebsite(leadList);*/
    }
    
    
    /////Ankita
    //-------------------On NSl Approval Close the task and move to next stage-------------------------------------------------
    public static void onNSlApprovalCloseTaskMoveToNextStage(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        System.debug('onNSlApprovalCloseTaskMoveToNextStage===');
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            System.debug('Status : ' + lead.Status);
            if(lead.Status == 'Internal / External Discussions' || lead.Status == 'Client Take-On PreWork') {
                if(!String.isBlank(lead.NSLApprovalStatus__c) && lead.NSLApprovalStatus__c == 'Approved') {
                    leadIds.add(lead.Id);
                    System.debug('leadIds =='+leadIds);
                }
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'Next steps & actions discussed with NSL'];
        System.debug('relatedTasks =='+relatedTasks + ' , subject : ');
        for(Task task : relatedTasks) {
            task.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    /////Ankita
    //-------------------------Close task "update new Client information" to completed-------------------------------------------
    public static void updateNewClientInformationTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            System.debug('lead.Region__c=='+lead.Region__c);
            if(!String.isBlank(lead.Expertise__c) && !String.isBlank(lead.SubExpertise__c) && !String.isBlank(lead.Company)) {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'Enrichment of Segmentation Details of New Client'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    /////Ankita
    //---------------------------Close task "Submit with NSL Discussion" to completed----------------------------------------------
    public static void updateSubmitWithNSLDiscussionTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            if(!String.isBlank(lead.NSLApprovalRejectionRecommendation__c) || lead.NSLApprovalRejectionRecommendation__c !=oldLeadMap.get(lead.Id).NSLApprovalRejectionRecommendation__c ) {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'NSL Discussion Pending'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    /////Ankita
    //---------------------------Close task "Assign New Enquiry Record" to completed----------------------------------------------
    public static void updateAssigntNewClientRecordTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            if(!String.isBlank(lead.ClientBackground__c) && !String.isBlank(lead.GrowthPotential__c) && lead.TentativeFee__c != null  && !String.isBlank(lead.HowDidYouArriveAThisTentativeFee__c) && !String.isBlank(lead.ShortSummary__c)) {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'New Client Owner based on NSL discussion'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    /////Ankita
    //-------------------------Close task "Meet the Client" to completed-------------------------------------------
    public static void updateHaveClientMeetTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            if(!String.isBlank(lead.ClientBackground__c) && !String.isBlank(lead.GrowthPotential__c) && lead.TentativeFee__c != null  && !String.isBlank(lead.HowDidYouArriveAThisTentativeFee__c)) {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'Client Engagement'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
        
    }
    /////Ankita
    //---------------------------Close task "Prepare Client Copuncil Deck" to completed----------------------------------------------
    public static void updatePrepareClientCouncilDeckTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            if(!String.isBlank(lead.CCApprovalRejectionRecommendation__c) || lead.CCApprovalRejectionRecommendation__c != oldLeadMap.get(lead.Id).CCApprovalRejectionRecommendation__c) {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'Client Take-On Preparation Deck'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    /////Ankita
    //---------------------------Close task "Execute Client Council Recommendation" to completed----------------------------------------------
    public static void updateExecuteClientCouncilRecommendationTaskStatusToCompleted(List<Lead> leadList, Map<Id,Lead> oldLeadMap) {
        
        //Set for storing lead Ids
        Set<Id> leadIds = new Set<Id>();
        
        for(Lead lead : leadList) {
            if(!String.isBlank(lead.CCApprovalStatus__c) && lead.CCApprovalStatus__c != oldLeadMap.get(lead.Id).CCApprovalStatus__c && lead.CCApprovalStatus__c =='Approved') {
                leadIds.add(lead.Id);
            }
        }
        LIST<Task> relatedTasks = [SELECT ID, Status
                                   FROM Task 
                                   WHERE WhoId IN :leadIds 
                                   AND Subject = 'Client Council Takeaways'];
        System.debug('relatedTasks =='+relatedTasks);
        for(Task t : relatedTasks){
            t.status = 'Completed';
        }
        if(!relatedTasks.isEmpty()) {
            update relatedTasks;
        }
    }
    
    //update Approval Fields Of CC On Enquiry
    public static void updateApprovalFieldsOfCCOnEnquiry(List<Lead> leadList){
        System.debug('inside cc approval');
        //List<Lead> updateLeadList = new List<Lead>();
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: leadList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        List<Task> taskList = new List<Task>();
        for(ProcessInstance proInstObj: instancesList){
            if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
            }
        }
        for(Lead leadObj:leadList){
            System.debug('map==>'+approvalHistoryMap);
            if(approvalHistoryMap.containsKey(leadObj.id)){
                System.debug('lead id '+leadObj.id);
                leadObj.CCApprovalRejectionRecommendation__c = approvalHistoryMap.get(leadObj.id).steps[0].Comments;
                leadObj.CCApprovedRejectedBy__c = approvalHistoryMap.get(leadObj.id).LastActor.Name;
                //updateLeadList.add(leadObj);
            }
            /*if(leadObj.CCApprovalStatus__c=='Approved' || leadObj.CCApprovalStatus__c=='Rejected'){
Task objTask = new Task(); 
objTask.OwnerId = approvalHistoryMap.get(leadObj.id).SubmittedById;
objTask.Subject = 'Approved and Rejected Remarks';
objTask.Priority = 'Normal';
objTask.Status = 'Open';
objTask.ActivityDate= date.today().addDays(1);
objTask.WhoID = leadObj.id;
taskList.add(objTask);
}*/
        }
        try{
            //insert taskList;
            //update updateLeadList;  
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
        
    }
    public static void updateApprovalFieldsOfNSLOnEnquiry(List<Lead> leadList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: leadList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        List<Task> taskList = new List<Task>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Lead leadObj:leadList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(leadObj.id)){
                    System.debug('lead id '+leadObj.id);
                    leadObj.NSLApprovalRejectionRecommendation__c = approvalHistoryMap.get(leadObj.id).steps[0].Comments;
                    leadObj.NSLApprovedRejectedBy__c = approvalHistoryMap.get(leadObj.id).LastActor.Name;
                }
                if(leadObj.NSLApprovalStatus__c=='Approved' || leadObj.NSLApprovalStatus__c=='Rejected'){
                    Task objTask = new Task(); 
                    objTask.OwnerId = approvalHistoryMap.get(leadObj.id).SubmittedById;
                    objTask.Subject = 'Approved and Rejected Remarks';
                    objTask.Priority = 'Normal';
                    objTask.Status = 'Open';
                    objTask.ActivityDate= date.today().addDays(1);
                    objTask.WhoID = leadObj.id;
                    taskList.add(objTask);
                }
            }
            
            //insert taskList;  
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    
    public static void AgingOfStage(List<Lead> leadList){
        System.debug('lead Record'+leadList);
        for(Lead leadObj: leadList){
            if(leadObj.Status=='Internal / External Discussions'){
                System.debug('inside if'+leadObj.OnNewStage__c);
                leadObj.OnNewStage__c = leadObj.OnNewStage__c + leadObj.CreatedDate.Date().daysBetween(system.today());
                System.debug('inside if'+leadObj.OnNewStage__c);
                leadObj.ComputeNewStageDate__c = system.today();
            }
            else if(leadObj.Status=='Client Take-On PreWork'){
                System.debug('inside if'+leadObj.OnInternalExternalDiscussionsStage__c);
                leadObj.OnInternalExternalDiscussionsStage__c =leadObj.OnInternalExternalDiscussionsStage__c + leadObj.ComputeNewStageDate__c.daysBetween(leadObj.LastModifiedDate.Date());
                leadObj.ComputeInternalExternalStageDate__c = system.today();
            }
            else if(leadObj.Status=='Client Take On	'){
                System.debug('inside if'+leadObj.OnNewStage__c);
                leadObj.OnClientTakeOnPreWorkStage__c = leadObj.OnClientTakeOnPreWorkStage__c + leadObj.ComputeInternalExternalStageDate__c.daysBetween(leadObj.LastModifiedDate.Date());
                leadObj.ComputeClientPreWorkStageDate__c = system.today();
            }
            else if(leadObj.Status=='NotAccept'){
                leadObj.OnClientTakeOnStage__c	 =leadObj.OnClientTakeOnStage__c + leadObj.ComputeClientPreWorkStageDate__c.daysBetween(leadObj.LastModifiedDate.Date());
                leadObj.ComputeClientTakeOnStageDate__c = system.today();
            }
            else if(leadObj.Status=='Accept Client'){
                //leadObj.ComputeNotAcceptedClientStageDate__c	 = leadObj.ComputeFeasibilityAnalysisStageDate__c.daysBetween(leadObj.LastModifiedDate.Date());
                //leadObj.ComputeClientCouncilStageDate__c = system.today();
                //leadObj.AgingAsOnCreatedDateInDays__c =  system.today().daysBetween(leadObj.CreatedDate.Date());
            }
        }
    }
    
    public static void isBeforeInsert(List<Lead> leadList){
        List<String> ListOfExperty = new List<String>();
        List<String> ListOfSubExperty= new List<String>();
        
        for(lead leadObj : leadList ){
            if(leadObj.Expertise__c <> null)
                ListOfExperty= leadObj.Expertise__c.split(';');
            ListOfExperty.sort();
            String expertyStr= string.join(ListOfExperty,'');
            leadObj.ExpertiesForDuplicateRule__c = expertyStr;
            if(leadObj.SubExpertise__c <> null)
                ListOfSubExperty= leadObj.SubExpertise__c.split(';');
            ListOfSubExperty.sort();
            String subexpertyStr=string.join(ListOfSubExperty,'');
            leadObj.SubexpertiesForDuplicateRule__c = subexpertyStr;
        }
        checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated(leadList);
    }
    
    public static void checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated(List<Lead> leadList){
        System.debug('checkHownCanWeHelpYouShouldBeServiocesOnlyThenLeadShouldBeCreated==');
        for(Lead leadRecord :leadList){
            if(leadRecord.Industry!= null) { 
                if(leadRecord.Channel__c=='Digital' && (leadRecord.LeadSource == 'Website' ||leadRecord.LeadSource == 'Chat Bot')){
                    system.debug('Sector Assigenment queue');
                    Industry_Mapping_With_Sector__mdt sector = [select id,label,Sector__c from Industry_Mapping_With_Sector__mdt where label = :leadRecord.Industry limit 1];
                    leadRecord.Sector__c=sector.Sector__c;
                }
            }
            
        }
        for(Lead leadObj : leadList) {
            if(leadObj.LeadSource == 'Website') {
                if(leadObj.HowCanWeHelpYou__c != 'Services') {
                    leadObj.addError('Laed can not be created');
                }
            }
        }
    }
    
    public static void isBeforeUpdateMethod(List<Lead> newLeadList ,Map<Id,Lead> oldLeadMap){
        List<String> ListOfExperty = new List<String>();
        List<String> ListOfSubExperty= new List<String>();
        
        for(lead leadObj : newLeadList ){
            if(leadObj.Expertise__c <> null)
                ListOfExperty= leadObj.Expertise__c.split(';');
            ListOfExperty.sort();
            String expertyStr= string.join(ListOfExperty,'');
            leadObj.ExpertiesForDuplicateRule__c = expertyStr;
            if(leadObj.SubExpertise__c <> null)
                ListOfSubExperty= leadObj.SubExpertise__c.split(';');
            ListOfSubExperty.sort();
            String subexpertyStr=string.join(ListOfSubExperty,'');
            leadObj.SubexpertiesForDuplicateRule__c = subexpertyStr;
        }
        updateLeadStatusOnInternalExternal(newLeadList,oldLeadMap);
        updateLeadStatusOnClienTakeOn(newLeadList,oldLeadMap);
        if(newLeadList[0].LeadSource=='Manual' && oldLeadMap.get(newLeadList[0].Id).Sector__c != newLeadList[0].Sector__c  ){
            checkDuplicateClientOnLeadCreation.checkDuplicateClient(newLeadList);
        } 
        
    }
    
    
    // Suraj kumar
    public static void updateLeadStatusOnInternalExternal(List<Lead> newLeadList ,Map<Id,Lead> oldLeadMap){
        Set<Id> leadIds = new Set<Id>();
        Map<Id,Event> IdToEventMap = new Map<Id,Event>();
        
        for(Lead lead : newLeadList){
            if((lead.Status == 'Client Take-On PreWork' || lead.Status == 'Client Take On	' || lead.Status == 'Accept Client' || lead.Status == 'NotAccept') && oldLeadMap.get(lead.Id).Status == 'Internal / External Discussions'){
                leadIds.add(lead.Id);
            }
        }
        
        for(Event event : [SELECT Id, WhoId, Subject FROM Event WHERE WhoId IN : leadIds]){
            IdToEventMap.put(event.WhoId,event);
        }
        
        for(Lead lead : newLeadList){
            if(leadIds.contains(lead.Id)){
                if(IdToEventMap.containsKey(lead.Id) || IdToEventMap.isEmpty()){
                    if(IdToEventMap.get(lead.Id) == Null && lead.ByPassValidation__c == False){
                        lead.Status.addError('Please create a meeting first to move on to next step');
                    }
                }
                if((String.isBlank(lead.ClientBackground__c) || String.isBlank(lead.GrowthPotential__c) || lead.TentativeFee__c == Null || String.isBlank(lead.HowDidYouArriveAThisTentativeFee__c)) && lead.ByPassValidation__c == False){
                    System.debug('SOmething is not filled ' + lead.ClientBackground__c + ',' + lead.GrowthPotential__c + ',' + lead.TentativeFee__c + ',' + lead.HowDidYouArriveAThisTentativeFee__c);
                    lead.ClientBackground__c.addError('Please fill Client Background , Growth Potential ,Tentative fee , how did you arrive at this tentative fee before moving to the next status');
                }
                else if( (lead.Expertise__c == Null || lead.SubExpertise__c == Null) && lead.ByPassValidation__c == False){
                    lead.Expertise__c.addError('Please fill Expertise,SMEG before moving further.');
                }
                else if(lead.NSLApprovalStatus__c != 'Approved' && lead.ByPassValidation__c == False){
                    lead.NSLApprovalStatus__c.addError('New Client Status cannot be marked as \'Client Take-On PreWork\' until NSL Approval Status not \'Approved\'.');
                    
                }
                else if(String.isBlank(lead.ShortSummary__c) && lead.ByPassValidation__c == False){
                    lead.ShortSummary__c.addError('Please fill remark');
                }
            }
            
        }
        
    }
    
    
    // Suraj Kumar
    public static void updateLeadStatusOnClienTakeOn(List<Lead> newLeadList ,Map<Id,Lead> oldLeadMap){
        System.debug('updateLeadStatusOnClienTakeOn method called!!');
        Set<Id> leadIds = new Set<Id>();
        Map<Id,Task> IdToTaskMap = new Map<Id,Task>();
        for(Lead lead : newLeadList){
            System.debug('STage 1');
            if((lead.Status == 'Client Take On' || lead.Status == 'Accept Client' || lead.Status == 'NotAccept') && oldLeadMap.get(lead.Id).Status == 'Client Take On'){
                System.debug('STage 2');
                leadIds.add(lead.Id); 
            }
        }
        
        for(Task task : [SELECT Id, Subject, WhoId, Status FROM Task WHERE WhoId IN : leadIds AND Status = 'Open']){
            IdToTaskMap.put(task.WhoId, Task);
        }
        
        for(Lead lead : newLeadList){
            if(!IdToTaskMap.isEmpty() && IdToTaskMap.containsKey(lead.Id)){
                System.debug('IdToTaskMap : ' + IdToTaskMap.get(lead.Id));
                //System.debug('leadstatus :'+lead.status);
                if(lead.Status == 'Accept Client' && leadIds.contains(lead.Id)){
                    System.debug('Accept Client');
                    lead.Status.addError('There are still open Tasks for this New Client, Please complete all open tasks before moving further.');
                } 
            }if(lead.Status == 'NotAccept' && String.isBlank(lead.Reject_Reason__c) ){
                
                lead.Reject_Reason__c.addError('Please provide the Reject Reason to proceed further.');
            }
            /*By:- Suresh Gupta
              Date:- 05-04-2023
			  Purpose:- If Reject Reason is filled, then New Client Status can only be changed to 'Not Accept Client.'
			*/
                if(!(String.isBlank(lead.Reject_Reason__c)) && oldLeadMap.get(lead.Id).Status != 'NotAccept'){
                    lead.Status='NotAccept';
                    lead.ByPassValidation__c=true;
                }               
        }
    }
    
    // Suraj Kumar
    public static void makeCommentMandatory(){
        System.debug('Comment mandate method called!');
        Set<Id> leadIds = new Set<Id>();
        for(Lead lead : (List<Lead>)Trigger.new){
            System.debug('CCApprovalStatus__c : ' + lead.CCApprovalStatus__c + ' and NSLApprovalStatus__c : ' + lead.NSLApprovalStatus__c);
            if(lead.CCApprovalStatus__c == 'Approved' || lead.CCApprovalStatus__c == 'Rejected' || lead.NSLApprovalStatus__c == 'Approved' || lead.NSLApprovalStatus__c == 'Rejected'){
                System.debug('Lead added');
                leadIds.add(lead.Id);
            }
        }
        
        if(leadIds.size() > 0){
            List<ProcessInstance> pList = [SELECT Id, (SELECT Id, Comments FROM Steps order by CreatedDate desc limit 1) FROM ProcessInstance WHERE TargetObjectId IN  : leadIds order by CreatedDate desc limit 1];
            for(Lead lead : (List<Lead>)Trigger.new){
                for(ProcessInstance pi : pList){
                    for(ProcessInstanceStep pStep : pi.steps){
                        System.debug('Comment : ' + pStep.Comments);
                        if(pStep.Comments == null || pStep.Comments == ''){
                            System.debug('Error shown on comment');
                            lead.addError('Comments are Mandatory to Approve/Reject request');
                        }
                    }
                }
            }
            
        }
    }
    //Gaurav Kumar
    //Date : 29/03/2023
    //Purpose :If Prospect Categaory is Cold, then user can't update record
    public static void notUpdateRecordIfProspectCategoryCold(List<Lead> newLeadList ,Map<Id,Lead> oldLeadMap){
        for(Lead leadObj : newLeadList){
            //System.debug('Status :'+leadObj.Status);
            if((leadObj.Category__c=='Cold' && oldLeadMap.get(leadObj.Id).Category__c == leadObj.Category__c) && leadObj.ByPassValidation__c == False){
                leadObj.addError('Please change prospect category Cold to Hot');
            }
        }
    }
    //End    
}