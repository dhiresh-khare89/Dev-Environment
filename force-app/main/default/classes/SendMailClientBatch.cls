/*
 * Author : Ayush Joshi
 * Date : 04-01-2023
 * Description : Batch class to send Email to Account Owner
 * Helper Class : SendMailEnquiryBatchHelper
*/

global class SendMailClientBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SendMailClientBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        List<Account> updateAcctList = new List<Account>();
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            for(Account acc : accList) {
                acc.Pick_Record__c = false;
                acc.DS_Team_Verification_date__c = null;
                acc.Assignment_Date__c=null;
                acc.DS_Team_Approved_RejectedBy__c='';
                updateAcctList.add(acc);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {acc.Owner.Email});
                email.setSubject(' Batch executed ');
                String body = ' Hi ' + acc.Owner.Name + ', <br>';
                body += 'Your Client is older than 6 months <br> ';
                body += 'Thanks & Regards</br>';
                email.setHtmlBody(body);
                System.debug('Email : ' + email);
                mailsList.add(email);
            }
            if(!updateAcctList.isEmpty()){
                update updateAcctList;
            }
            if(!mailsList.isEmpty()){
                Messaging.sendEmail(mailsList);
            }
        }
        catch(Exception e){
            System.debug('Exception : ' + e.getMessage() + ' in Line : ' + e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext bc){
       
    }
}