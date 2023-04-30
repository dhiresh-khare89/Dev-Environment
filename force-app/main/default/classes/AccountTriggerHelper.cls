public class AccountTriggerHelper {
    public static void sendDSTeamApprovalRequest(List<Account> accountList){
        String userId = UserInfo.getUserId();
        try{
            for(Account accObj:accountList){
                accObj.Assigned_to_DS_Team_Member__c =userId;
                accObj.Assignment_Date__c = System.today();
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Approval Request for DS Team Member');
                req1.setObjectId(accObj.id);
                System.debug(userId);
                req1.setSubmitterId(userId); 
                req1.setProcessDefinitionNameOrId('DS_Team_Account_Approval');
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    public static void updateDSTeamApprovalFields(List<Account> acctList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: acctList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Account accObj:acctList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(accObj.id)){
                    System.debug('Account id '+accObj.id);
                    accObj.DS_Team_Approval_Rejection_Remarks__c = approvalHistoryMap.get(accObj.id).steps[0].Comments;
                    accObj.DS_Team_Approved_RejectedBy__c = approvalHistoryMap.get(accObj.id).LastActor.Name;
                }
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    public static void sendEmailToProposedOwner(List<Account> acctList){
        Set<Id> accountIds = new Set<Id>();
        List<String> clientTeamMemberEmailList = new List<String>();
        List<String> cmGroupTeamMemberEmailList = new List<String>();
        List<Group> getCMTeamMember = [Select Id,Name,(select userOrGroupId from groupMembers) From Group where DeveloperName='C_M_Team'];
        List<User> usersEmails = [SELECT Email FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember
                                                                      WHERE GroupId =:getCMTeamMember[0].id)];
        for(User userObj:usersEmails){
            cmGroupTeamMemberEmailList.add(userObj.Email);
        }
        System.debug('USer Email List'+cmGroupTeamMemberEmailList);
        for(Account acc:acctList){
            accountIds.add(acc.Id); 
        }
        List<AccountTeamMember> accountTeamMemberList = [select Id,User.Email,UserId from AccountTeamMember where AccountId IN:accountIds];
        if(!accountTeamMemberList.isEmpty()){
            for(AccountTeamMember accTeamObj:accountTeamMemberList){
                clientTeamMemberEmailList.add(accTeamObj.User.Email);
            } 
        }
        for(Account accObj:acctList){
            if(!clientTeamMemberEmailList.isEmpty()){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(clientTeamMemberEmailList);
                mail.setCcAddresses(cmGroupTeamMemberEmailList);
                mail.setSubject('Owner Change for Client');
                mail.plainTextBody='Dear Account Owner Congrats! you are now the new Account Owner of this Client. Please setup a meeting with Client team to'
                       +'Regards'+
                    'LinKreta';
                try{
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }catch(Exception e){
                    System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
                }
            }   
        }
    }
}