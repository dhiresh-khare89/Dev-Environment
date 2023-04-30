/*
 * Author : Ayush Joshi
 * Date : 04-01-2023
 * Description : Batch class to send Email to Contact Owner
 * Helper Class : SendMailEnquiryBatchHelper
*/

global class SendMailClientContactBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SendMailEnquiryBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> conList){
        List<Contact> updateConList = new List<Contact>();
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            for(Contact cc : conList) {
                cc.Pick_Record__c = false;
                cc.DS_Team_Verification_date__c = null;
                cc.Assignment_Date__c=null;
                cc.DS_Team_Approved_RejectedBy__c='';
                updateConList.add(cc);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {cc.Owner.Email});
                email.setSubject(' Batch executed ');
                String body = ' Hi ' + cc.Owner.Name + ', <br>';
                body += 'Your Client Contact is older than 6 months <br> ';
                body += 'Thanks & Regards</br>';
                email.setHtmlBody(body);
                System.debug('Email : ' + email);
                mailsList.add(email);
            }
            if(!updateConList.isEmpty()){
                update updateConList;
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