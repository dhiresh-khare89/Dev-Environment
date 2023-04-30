/*
 * Author : Suraj Kumar
 * Date : 12-12-2022
 * Description : Batch class to send Email to opportunity Owner
 * Helper Class : SendMailEnquiryBatchHelper
*/

global class SendMailEnquiryBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SendMailEnquiryBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        List<Opportunity> updateOppoList = new List<Opportunity>();
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            for(Opportunity opp : oppList) {
                opp.Pick_Record__c = false;
                opp.DS_Team_Verification_date__c = null;
                opp.Assignment_Date__c=null;
                opp.DSTeamApprovedRejectedBy__c='';
                updateOppoList.add(opp);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {opp.Owner.Email});
                email.setSubject(' Batch executed ');
                String body = ' Hi ' + opp.Owner.Name + ', <br>';
                body += 'Your enquiry is older than 6 months <br> ';
                body += 'Thanks & Regards</br>';
                email.setHtmlBody(body);
                System.debug('Email : ' + email);
                mailsList.add(email);
            }
            if(!updateOppoList.isEmpty()){
                update updateOppoList;
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