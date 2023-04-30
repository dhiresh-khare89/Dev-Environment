public class EnquiryTriggerHelper {
    
    //Method for handle before insert event 
    public static void isBeforeInsert(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOppMap) {
        handleOpportunityStage(opportunityList);
        noNewEnquiryCanBeCreatedInSystemIfClientStatusIsInactive(opportunityList);
        // Even if 1 enquiry amongst the integrated enquiry is closed Won then it will not be possible to add another enquiry within the integrated enquiry
        PreventEnquiryIfAnyClosedWonEnquiryExistOnIntegEnq(opportunityList, Null);
    }
    
    //Method for handle before update event 
    public static void isBeforeUpdate(List<Opportunity> opportunityList,Map<Id,opportunity>oldOpportunityMap) {
        captureValidateBenefitValueStageDate(opportunityList,oldOpportunityMap);
        
        // If RCC expire , Enquiry Cannot be changed to Closed Won/Closed Lost
        ErrorIfRccExpired(opportunityList, oldOpportunityMap);
        // Even if 1 enquiry amongst the integrated enquiry is closed Won then it will not be possible to add another enquiry within the integrated enquiry
        PreventEnquiryIfAnyClosedWonEnquiryExistOnIntegEnq(opportunityList, oldOpportunityMap);
    }
    
    
    
    // Even if 1 enquiry amongst the integrated enquiry is closed Won then it will not be possible to add another enquiry within the integrated enquiry
    public static void PreventEnquiryIfAnyClosedWonEnquiryExistOnIntegEnq(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        Set<Id> integEnqIdSet = new Set<Id>();
       
        for(Opportunity opp: newOppList){
            if(String.isNotBlank(opp.IntegratedEnquiry__c)){
                integEnqIdSet.add(opp.IntegratedEnquiry__c);
            }
        }
      
        if(!integEnqIdSet.isEmpty()){
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT Id, StageName, IntegratedEnquiry__c FROM Opportunity WHERE StageName = 'Closed Won' AND IntegratedEnquiry__c =:integEnqIdSet]);
            Set<Id> integEnqId = new Set<Id>();
            if(!oppMap.isEmpty()){
            for(Opportunity opp: oppMap.values()){
                integEnqId.add(opp.IntegratedEnquiry__c);
            }
            }
            if(oppMap.Size() > 0){
                for(Opportunity opp: newOppList){
                    if(String.isNotBlank(opp.IntegratedEnquiry__c) && integEnqId.contains(opp.IntegratedEnquiry__c) && opp.StageName == 'Closed Won'){
                        opp.addError('Cannot create new Enquiry, there already exist a Closed Won Enquiry for this Integrated Enquiry');
                    }
                }
            }
        }
    }
    
    
    
    // Method to handle after insert event
    public static void isAfterInsert(List<Opportunity> newOppList, Map<Id, Opportunity> newOppMap){
        //  EnquiryTriggerHelper.createOppTeamMemberOnOppInsert(newOppList);
        List<Id> OppListId=new List<ID>();
        for(Opportunity opp:newOppList){
            if(opp.NSL__C!=Null){
                OppListId.add(opp.id);
            }
            
        }
        if(OppListId.size()>0){
            EnquirySharingForEA.NSLSharingRule(OppListId); 
        }
        
    }
    
    // Method to handle after update event
    public static void isAfterUpdate(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        // Method to send email to all T1 designation user, if Enagement Team Approval request status is Approved
        // EmailToT1DesigUsrIfEngTeamApprv(newOppList, oldOppMap);
        
        List<Id> OppListId=new List<ID>();
        for(Opportunity opp:newOppList){
            if(opp.Executive_Assistant__c!=Null && opp.Executive_Assistant__c!=oldOppMap.get(opp.id).Executive_Assistant__c){
                OppListId.add(opp.id);
            }
            
        }
        if(OppListId.size()>0){
            EnquirySharingForEA.EASharingRule(OppListId);  
        }
    }
    
    @future(callout=true)
    public static void callCreateEnquiryApi(Id oppId){
        Opportunity opp=[Select Id, Name, IsClosed, IsWon, WonReasonComments__c ,AccountId, OwnerId from Opportunity where id =: oppId];
        User u = [SELECT Id,CR_USER_ID__c From User Where Id =: opp.OwnerId];
        String body = '{'+
                '"P_PIP_ID": "'+opp.Id+'",'+
                '"P_NAME": "'+opp.Name+'",' +
                '"P_CLIENTID": "'+opp.AccountId+'",' +
                '"P_SERVICELINEID": "S00002",' +
                '"P_MARKETID": "M0001",' +
                '"P_CR_USERID": "'+u.CR_USER_ID__c+'",' +
                '"P_WONREASONDESCRIPTION" : " ",' +
                '"P_COMPLETEFLAG":"1",' +
                '"P_PITCHSTATUS":"0"}';
        
        HttpRequest apiRequest = HttpUtility.getHttpRequest('https://uat360.wcgt.in/GTSF/api/PipelineEnqiry/Insert','POST','Accept','*/*',body,'application/json', null);
        
        HttpResponse apiResponse = HttpUtility.makeCallout(apiRequest);
        system.debug('apiResponse'+apiResponse);
        system.debug('apiResponse'+apiResponse.getBody());
        
    }
    //Enquiry record visible at Stage "Qualify Enquiry"
    public static void handleOpportunityStage(List<Opportunity> opportunityList){
        for(Opportunity oppObj: opportunityList){
            oppObj.StageName = 'Identify/Create Enquiry';
        }
    }
    //If any Client is marked inactive, no new enquiry can be created in system.
    public static void noNewEnquiryCanBeCreatedInSystemIfClientStatusIsInactive(List<Opportunity> opportunityList) {
        //Set of ids for storing account id 
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity oppObj : opportunityList) {
            if(!String.isBlank(oppObj.AccountId)) {
                accountIds.add(oppObj.AccountId);
                System.debug('accountIds=='+accountIds);
            }
        }
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Name,ClientStatus__c FROM Account Where Id =:accountIds]);
        System.debug('accountMap=='+accountMap);
        
        for(Opportunity opp : opportunityList) {
            if(accountMap.containsKey(opp.AccountId) && accountMap.get(opp.AccountId).ClientStatus__c == 'Inactive') {
                opp.addError('You can not create new enquiry because related client status is Inactive'); 
            }
        }
    }
    
    public static void updateDSTeamApprovalFields(List<Opportunity> oppList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: oppList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Opportunity oppoObj:oppList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(oppoObj.id)){
                    System.debug('opportunity id '+oppoObj.id);
                    oppoObj.DSTeamApprovalRejectionRemarks__c = approvalHistoryMap.get(oppoObj.id).steps[0].Comments;
                    oppoObj.DSTeamApprovedRejectedBy__c = approvalHistoryMap.get(oppoObj.id).LastActor.Name;
                }
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
        
    }
    
    // Method to create opportunity team member on opportunity insert
    public static void createOppTeamMemberOnOppInsert(List<Opportunity> newOppList){
        /*   List<OpportunityTeamMember> oppTeamMembrList = new List<OpportunityTeamMember>();
for(Opportunity opp: newOppList){
if(String.isNotBlank(opp.GTEmployee__c)){
OpportunityTeamMember oppTeamMembrObj = new OpportunityTeamMember();
oppTeamMembrObj.OpportunityId = opp.Id;
oppTeamMembrObj.TeamMemberRole = 'Other';
oppTeamMembrObj.UserId = opp.GTEmployee__c;
oppTeamMembrList.add(oppTeamMembrObj);
}

OpportunityTeamMember oppTeamMembrObj1 = new OpportunityTeamMember();
oppTeamMembrObj1.OpportunityId = opp.Id;
oppTeamMembrObj1.TeamMemberRole = 'Generated the Lead';
oppTeamMembrObj1.UserId = opp.OwnerId;
oppTeamMembrList.add(oppTeamMembrObj1);
}
if(!oppTeamMembrList.isEmpty()){
insert oppTeamMembrList;
}
*/
    }    
    public static void captureNurtureStageDate(List<Opportunity> oppoList){
        if(!oppoList.isEmpty()){
            for(Opportunity oppoObj: oppoList){
                oppoObj.Nurture_Finalizing_Closure_Date__c = oppoObj.LastModifiedDate.date();
            }
        }
    }
    //Method for caculating ValidateBenefitsValueDate__c Date 
    public static void captureValidateBenefitValueStageDate(List<Opportunity> oppoList,Map<Id,opportunity>oldOpportunityMap){
        if(!oppoList.isEmpty()){
            for(Opportunity opportunityObj: oppoList){
                if(opportunityObj.StageName!=oldOpportunityMap.get(opportunityObj.Id).StageName && opportunityObj.StageName=='Validate Benefits & Value') {
                    opportunityObj.ValidateBenefitsValueDate__c = opportunityObj.LastModifiedDate.date();
                    System.debug('opportunityObj.ValidateBenefitsValueDate__c='+opportunityObj.ValidateBenefitsValueDate__c);
                }
            }
        }
    }
    
    
    // If RCC expire , Enquiry Cannot be changed to Closed Won/Closed Lost
    public static void ErrorIfRccExpired(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        for(Opportunity opp: newOppList){
            if(opp.DueDateTillExpiry__c < Date.today()){
                if(opp.StageName != oldOppMap.get(opp.Id).StageName && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost')){
                    opp.addError('RCC Expired, Cannot Change Status To Closed Won OR Closed Lost');
                }
            }
        }
    }
    
    // Method to send email to all T1 designation user, if Enagement Team Approval request status is Approved
    public static void EmailToT1DesigUsrIfEngTeamApprv(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        List<Messaging.Email> emailList = new List<Messaging.Email>();
        // get custom notification
        CustomNotificationType t1DesigUsr = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Notify_T1_Designation_Users'];
        // get list of all T1 designation users
        List<User> usersList = [SELECT Id, Email, Designation__c FROM User WHERE IsActive = True AND Designation__c = 'T1'];
        // set to store users id
        Set<String> usersIdList = new Set<String>();
        // list to store users email
        List<String> usersEmailList = new List<String>();
        if(!usersList.isEmpty()){
            for(User u: usersList){
                usersIdList.add(u.Id);
                usersEmailList.add(u.Email);
            }
        }
        if(!usersIdList.isEmpty() && !usersEmailList.isEmpty()){
            for(Opportunity opp: newOppList){
                if(opp.EngagementTeamApprovalStatus__c != oldOppMap.get(opp.Id).EngagementTeamApprovalStatus__c && opp.EngagementTeamApprovalStatus__c == 'Approved'){
                    // Send Email To Enquiry Owner As RCC is About To Expire
                    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                    emailMsg.setToAddresses(usersEmailList);
                    emailMsg.setSubject('Engagement Team Approved The Approval Request');
                    emailMsg.plaintextbody = 'Request for Engagement Team Approval has been Approved';
                    emailList.add(emailMsg);
                    
                    // Notification To Enquiry Owner As RCC Is About To Expire
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setBody('Request for Engagement Team Approval has been Approved');
                    notification.setTitle('Engagement Team Approved The Approval Request');
                    notification.setTargetId(opp.Id);
                    notification.setNotificationTypeId(t1DesigUsr.Id);
                    try {
                        notification.send(usersIdList);        }
                    catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                    }
                    
                }
            }
        }
        try{
            Messaging.sendEmail(emailList);
        }catch(Exception e){
            System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
        } 
    }
    //By:- Suresh Gupta
    //Date:- 13 Dec 2022
    //Method to update Current Step and Completed Steps in Guidance for Success
    
    public static void updateCurrAndCompSteps (List<Opportunity> oppList){
        //Map<String,List<String>> dependentPicklistValuesMap = getDependentPicklistValues(Opportunity.Current_Steps__c);
        Set<Id> oppIds = New Set<Id>();
        //Map of Opportunity Id and Number of Commercials Associated with it
        Map<Id, Integer> mapOfOppIdsAndQuoteSize = New Map<Id, Integer>();
        //Map of Opportunity Id and Number of Commercials Associated with it
        Map<Id, Integer> mapOfOppIdsAndOpportunityContactRolesSize = New Map<Id, Integer>();
        //Map of Opportunity Id and Number of Meeting(Event) Associated with it
        Map<Id, Integer> mapOfOppIdsAndMeetingSize = New Map<Id, Integer>();
        //Map of Opportunity Id and Number of Minutes Of Meetings Associated with it
        Map<Id, Integer> mapOfOppIdsAndTaskSize = New Map<Id, Integer>();
        //map of opportunity id and number of Debrief Template for Closed Won Enquiry
        Map<Id, Integer> mapOfOppIdAndNumberOfDebriefTemplate = New Map<Id, Integer>();
        //Set of Opportunity Ids
        for(Opportunity opp:oppList){
            oppIds.add(opp.id);
        }
        //Count Number of Commercials
        for(Opportunity opp: [SELECT Id, (SELECT Id FROM Quotes),
                              (SELECT Id FROM OpportunityContactRoles),
                              (SELECT id,Subject, WhatId FROM Tasks),
                              (SELECT id,Subject, WhatId FROM Events WHERE Subject = 'Meeting')
                              FROM Opportunity 
                              WHERE Id IN:oppIds])
        {
            mapOfOppIdsAndQuoteSize.put(opp.Id, opp.Quotes.Size());
            mapOfOppIdsAndOpportunityContactRolesSize.put(opp.Id, opp.OpportunityContactRoles.Size());
            mapOfOppIdsAndMeetingSize.put(opp.Id, opp.Events.Size());
            mapOfOppIdsAndTaskSize.put(opp.Id, opp.Tasks.Size());
            
        }
        for (Opportunity opp: [SELECT id, (SELECT id , Subject FROM Tasks WHERE Subject='rationale for Closed won in de-brief form') FROM Opportunity WHERE Id IN:oppIds]){
            mapOfOppIdAndNumberOfDebriefTemplate.put(opp.id, opp.Tasks.Size());
        }
        
        for(Opportunity oppoObj:oppList){
            system.debug('Stage name--->'+oppoObj.StageName);
            oppoObj.Current_Steps__c='';
            oppoObj.Completed_Steps__c='';
            
            //updating guidance path if stage if is Identify/Create Enquiry
            if(oppoObj.StageName=='Identify/Create Enquiry'){
                oppoObj.Current_Steps__c='Add Finding Partner'+' -->'+' DS Team Review'+' -->'+' Conflict Check'+' -->'+' Execute NSL, Client Council Recommendations';
                system.debug('Check-1: Stage Identify');
                //check if GT employee is Empty
                if(oppoObj.GTEmployee__c == NULL ){
                    //if team count is more than equal to 1, then Remove 'Add Finding Partner' from current step add to Completed Steps
                    if(oppoObj.CountTeam__c>= 1){
                        oppoObj.Current_Steps__c='DS Team Review'+' -->'+' Conflict Check'+' -->'+' Execute NSL, Client Council Recommendations';
                        oppoObj.Completed_Steps__c +='Add Finding Partner';
                        //If Ds Team review field is Approved then, remove 'DS Team Review' from current steps and add to Completed Step
                        if(oppoObj.StatusDSTeamRemarkStatus__c=='Approved'){
                            oppoObj.Current_Steps__c='Conflict Check'+' -->'+' Execute NSL, Client Council Recommendations';
                            oppoObj.Completed_Steps__c +=' -->'+' DS Team Review';
                            //If RCC status field is Approved then, remove 'Conflict Check' from current steps and add to Completed Step
                            if(oppoObj.RCCStatus__c=='Approved'){
                                oppoObj.Current_Steps__c='Execute NSL, Client Council Recommendations';
                                oppoObj.Completed_Steps__c +=' -->'+' Conflict Check';
                            }
                        }
                    }
                }
                //check if GT employee is not empty
                else if(oppoObj.GTEmployee__c != NULL ){
                    //if team count is more than equal to 2, then Remove 'Add Finding Partner' from current step add to Completed Steps
                    if(oppoObj.CountTeam__c>= 2){
                        oppoObj.Current_Steps__c='DS Team Review'+' -->'+' Conflict Check'+' -->'+' Execute NSL, Client Council Recommendations';
                        oppoObj.Completed_Steps__c +='Add Finding Partner';
                        //If Ds Team review field is Approved then, remove 'DS Team Review' from current steps and add to Completed Step
                        if(oppoObj.StatusDSTeamRemarkStatus__c=='Approved'){
                            oppoObj.Current_Steps__c ='Conflict Check'+' -->'+' Execute NSL, Client Council Recommendations';
                            oppoObj.Completed_Steps__c +=' -->'+' DS Team Review';
                            //If RCC status field is Approved then, remove 'Conflict Check' from current steps and add to Completed Step
                            if(oppoObj.RCCStatus__c=='Approved'){
                                oppoObj.Current_Steps__c ='Execute NSL, Client Council Recommendations';
                                oppoObj.Completed_Steps__c +=' -->'+' Conflict Check';
                            }
                        }
                    }
                }
            }
            else if(oppoObj.StageName == 'Determine Problem & Impact'){
                oppoObj.Current_Steps__c='Identification of Client Contact Roles'+' -->'+' Create Contacts	'+' -->'+' Execute NSL, Client Council Recommendation'+' -->'+' Fill all fields of Problem and Impact Quip Template';
                System.debug('Check--.2 Determine Problem');
                //Checking if Client Contact Role is greater than equal to 2
                if(mapOfOppIdsAndOpportunityContactRolesSize.get(oppoObj.id)>=1){
                    oppoObj.Current_Steps__c=' Create Contacts	'+' -->'+' Execute NSL, Client Council Recommendation'+' -->'+ ' Fill all fields of Problem and Impact Quip Template';
                    oppoObj.Completed_Steps__c +='Identification of Client Contact Roles';
                    if(oppoObj.ScopeOfWork__c!= NULL && oppoObj.MarketRisk__c!= NULL && oppoObj.AnyPotentialCrisis__c!= NULL && oppoObj.Problem_Statement__c != NULL && oppoObj.AnyEventsYouForesee__c != NULL && oppoObj.GTValueDifferentiators__c!= NULL && oppoObj.ExecutiveAsks__c != NULL && oppoObj.GTPricingOptions__c!= NULL  && oppoObj.C_level_Priorities__c!= NULL ){
                        oppoObj.Current_Steps__c='Identification of Client Contact Roles'+' -->'+' Create Contacts	'+' -->'+' Execute NSL, Client Council Recommendation';
                        oppoObj.Completed_Steps__c +=' -->'+' Fill all fields of Problem and Impact Quip Template';
                    }
                } 
            }
            else if(oppoObj.StageName=='Validate Benefits & Value'){
                oppoObj.Current_Steps__c='Create Pitch Deck'+' -->'+' Create Initial'+' -->'+' Execute NSL, Client Council Recommendation';
                //Checking if any Commercial is Created or Not
                if(mapOfOppIdsAndQuoteSize.get(oppoObj.id)>0){
                    oppoObj.Current_Steps__c='Create Pitch Deck'+' -->'+' Execute NSL, Client Council Recommendation';
                    oppoObj.Completed_Steps__c +='Create Initial Commercials';
                }
            }
            else if(oppoObj.StageName=='Confirm Value With Client'){
                oppoObj.Current_Steps__c='Create Proposal'+' -->'+' Iterate Client Connect'+' -->'+' Capture Minutes of Meetings';
                //Checking if any meeting is scheduled or not
                if(mapOfOppIdsAndMeetingSize.get(oppoObj.id)>0){
                    oppoObj.Current_Steps__c='Create Proposal'+' -->'+' Capture Minutes of Meetings';
                    oppoObj.Completed_Steps__c +='Iterate Client Connect';
                    //Checking if any Minutes of Meeting is created or not
                    if(mapOfOppIdsAndTaskSize.get(oppoObj.id)>0){
                        oppoObj.Current_Steps__c='Create Proposal';
                        oppoObj.Completed_Steps__c +=' -->'+' Capture Minutes of Meetings';
                    }
                }
            }
            else if(oppoObj.StageName=='Negotiation & Mutual Plan'){
                oppoObj.Current_Steps__c='Refine Commercials'+' -->'+' Nurture via Campaign'+' -->'+' Refine Proposal'+' -->'+' Iterate Client Connect';
                //Checking if any Meeting is Scheduled or not 
                if(mapOfOppIdsAndMeetingSize.get(oppoObj.id)>0){
                    oppoObj.Current_Steps__c='Refine Commercials'+' -->'+' Nurture via Campaign'+' -->'+' Refine Proposal';
                    oppoObj.Completed_Steps__c +='Iterate Client Connect';
                }
            }
            else if(oppoObj.StageName=='Nurture & Finalizing Closure'){
                oppoObj.Current_Steps__c='Engagement Letter Creation/Acceptance'+' -->'+' QRMG Checklist & Approval';
                if(oppoObj.Engagement_letter__c == 'Uploaded'){
                    oppoObj.Current_Steps__c=' QRMG Checklist & Approval';
                    oppoObj.Completed_Steps__c +='Engagement Letter Creation/Acceptance';
                    if(oppoObj.QRMG_checklist__c == 'Approved'){
                        oppoObj.Current_Steps__c='Engagement Letter Creation/Acceptance'+' -->'+' QRMG Checklist & Approval';
                        oppoObj.Completed_Steps__c +=' -->'+' QRMG Checklist & Approval';
                    }
                }
            }
            else if(oppoObj.StageName=='Closed Won' || oppoObj.StageName=='Closed Lost'){
                system.debug('Closed Won Stage--->');
                oppoObj.Current_Steps__c='Fill Closed Won/Lost Debrief Template'+' -->'+' Appreciate your Peers';
                if(mapOfOppIdAndNumberOfDebriefTemplate.get(oppoObj.id)>0){
                    oppoObj.Current_Steps__c='Appreciate your Peers';
                    oppoObj.Completed_Steps__c +='Fill Closed Won/Lost Debrief Template';
                }
            }
        }
    }
    
    public static void updateEnquiryFields(List<Opportunity> oppoList){
        String userId = UserInfo.getUserId();
        try{
            for(Opportunity oppoObj:oppoList){
                oppoObj.Assigned_to_DS_Team_Member__c =userId;
                oppoObj.Assignment_Date__c = System.today();
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Approval Request for DS Team Member');
                req1.setObjectId(oppoObj.id);
                System.debug(userId);
                req1.setSubmitterId(userId); 
                req1.setProcessDefinitionNameOrId('DS_Team_Approval');
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    public static void updateApprovalFieldsOfCCOnEnquiry(List<Opportunity> oppoList){
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: oppoList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        for(ProcessInstance proInstObj: instancesList){
            if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
            }
        }
        for(Opportunity oppoObj:oppoList){
            System.debug('map==>'+approvalHistoryMap);
            if(approvalHistoryMap.containsKey(oppoObj.id)){
                System.debug('lead id '+oppoObj.id);
                oppoObj.CCApprovalRejectionRecommendation__c = approvalHistoryMap.get(oppoObj.id).steps[0].Comments;
                oppoObj.CCApprovedRejectedBy__c = approvalHistoryMap.get(oppoObj.id).LastActor.Name;
            }
        }
        try{
            //insert taskList;  
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
        
    }
    
    public static void isAfterInsertOnDuplicateRule(List<Opportunity> opportunityList){
        List<String> ListOfExperty= new List<String>();
        List<String> ListOfSubExperty= new List<String>();
        
        for(Opportunity oppObj : opportunityList ){
            if(oppObj.Expertise__c <> null)
                ListOfExperty= oppObj.Expertise__c.split(';');
            ListOfExperty.sort();
            String expertyStr= string.join(ListOfExperty,'');
            oppObj.Expertice_for_Duplicate_Rule__c = expertyStr;
            if(oppObj.SubExpertise__c <> null)
                ListOfSubExperty= oppObj.SubExpertise__c.split(';');
            ListOfSubExperty.sort();
            String subexpertyStr=string.join(ListOfSubExperty,'');
            oppObj.Sub_Expertice_for_Duplicate_Rule__c = subexpertyStr;
        }
        //system.debug('str'+ListOfExperty);
        ListOfExperty.sort();
        ListOfSubExperty.sort();
        
        String expertyStr= string.join(ListOfExperty,'');
        String subexpertyStr=string.join(ListOfSubExperty,'');
        system.debug('str'+expertyStr);
    }
}