public class ContactTriggerHelper {
    public static void sendDSTeamApprovalRequest(List<Contact> conList){
        String userId = UserInfo.getUserId();
        try{
            for(Contact conObj:conList){
                conObj.Assigned_to_DS_Team_Member__c =userId;
                conObj.Assignment_Date__c = System.today();
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Approval Request for DS Team Member');
                req1.setObjectId(conObj.id);
                System.debug(userId);
                req1.setSubmitterId(userId); 
                req1.setProcessDefinitionNameOrId('DS_Team_Contact_Approval');
                req1.setSkipEntryCriteria(true);
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
    public static void updateDSTeamApprovalFields(List<Contact> conList){
        System.debug('Inside method');
        List<ProcessInstance> instancesList = [ SELECT Id,TargetObjectId,LastActor.Name,Status,SubmittedById,
                                               (select Comments,ProcessInstanceId from steps order by CreatedDate desc),CreatedDate
                                               FROM ProcessInstance where TargetObjectId IN: conList order by CreatedDate desc];
        Map<String,ProcessInstance> approvalHistoryMap= new Map<String,ProcessInstance>();
        try{
            for(ProcessInstance proInstObj: instancesList){
                if(!approvalHistoryMap.containsKey(proInstObj.TargetObjectId)){
                    approvalHistoryMap.put(proInstObj.TargetObjectId,proInstObj);
                }
            }
            for(Contact ccObj:conList){
                System.debug('map==>'+approvalHistoryMap);
                if(approvalHistoryMap.containsKey(ccObj.id)){
                    System.debug('Contact id '+ccObj.id);
                    ccObj.DS_Team_Approval_Rejection_Remarks__c = approvalHistoryMap.get(ccObj.id).steps[0].Comments;
                    ccObj.DS_Team_Approved_RejectedBy__c = approvalHistoryMap.get(ccObj.id).LastActor.Name;
                }
            }
        }
        catch(Exception e){
            System.debug('Error occured '+e.getMessage()+' '+e.getLineNumber());
        }
    }
}