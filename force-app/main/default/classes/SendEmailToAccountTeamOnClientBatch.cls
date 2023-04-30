global class SendEmailToAccountTeamOnClientBatch implements Database.Batchable<sObject> {
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Inside Start Method==');
        String query = 'Select id,Name,ClientStatus__c from Account where ClientStatus__c != null';   
        return Database.getQueryLocator(query);
    }
    //Execute Method
    global void execute(Database.BatchableContext BC, List<Account> accountList) {
        System.debug('Inside execute Method==');
        System.debug('accountList List'+accountList);
        
        //Set of Account Ids for storing Account record
        Set<Id> accountIds = new Set<Id>();
        //List of emails 
        List<String> emailList = new List<String>();
        //email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<CustomNotificationType> typeList = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'SendEmailToAccountTeamOnAccountStatusChangedAndNoTransactionInLast5Years'];
        System.debug('typeList'+typeList);
        
        if(!accountList.isEmpty()){
            for(Account accObj : accountList) {
                accountIds.add(accObj.Id);
                System.debug('accountIds'+accountIds);
            }
            //List<Opportunity> opportunityList = [SELECT Id,Name,AccountId From Opportunity Where AccountId =: accountIds AND LastModifiedDate > NEXT_N_YEARS:5];
            //System.debug('opportunityList=='+opportunityList);
            List<Opportunity> opportunityList = [SELECT Id,Name,AccountId From Opportunity Where AccountId =: accountIds AND LastModifiedDate = LAST_N_DAYS:5];
            System.debug('opportunityList=='+opportunityList);
            
            List<Opportunity> noOpportunityRelatedWithClientList = [SELECT Id,Name,AccountId From Opportunity Where AccountId =: accountIds];
            System.debug('noOpportunityRelatedWithClientList=='+noOpportunityRelatedWithClientList);
            
            If(!opportunityList.isEmpty() || noOpportunityRelatedWithClientList.size()==0) {
                List<AccountTeamMember> accountTeamMembrList = [SELECT Id,User.Email,UserId From AccountTeamMember WHERE AccountId =:accountIds];
                System.debug('accountTeamMembrList=='+accountTeamMembrList);
                
                for(AccountTeamMember accTeamMember : accountTeamMembrList) {
                    if(!String.isBlank(accTeamMember.UserId)) {
                        emailList.add(accTeamMember.User.Email);
                        System.debug('emailList=='+emailList);
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        notification.setBody('No Transaction has been observed since last 5 years');
                        notification.setTitle('No Transaction on Client');
                        notification.setTargetId(accTeamMember.id);
                        notification.setNotificationTypeId(typeList[0].id);
                        notification.send(new Set<String> {accTeamMember.UserId}); 
                    }
                }
            }
            for(Account acc : accountList) {
                acc.ClientStatus__c = 'Inactive';
                acc.Remark__c = 'Dormant';
                
                mail.setToAddresses(emailList);
                mail.setSubject('No Transaction on Client');
                mail.plainTextBody='Dear Team'+'\n'+'\n'+
                    'The client '+ acc.name +'has been changed to Dormant as no transaction has been observed since last 5 years. If you find any new lead, please create a New Client.'+'\n'+'\n'+ 
                    'Regards'+'\n'+'LinKreta Team';
            }
            try{
                if(!accountList.isEmpty()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                    update accountList;
                }
            }catch(Exception e){
                System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
            }
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext BC) {
        System.debug('Inside finish Method==');
    }
}