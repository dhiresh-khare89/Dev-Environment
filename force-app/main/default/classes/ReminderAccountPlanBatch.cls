/*
* Author : Suraj Kumar
* Date : 22-12-2022
* Description : Batch class to send reminder to CSL/Co-CSL/NSL
* Helper Class : ReminderAccountPlanBatchHelper
*/

global class ReminderAccountPlanBatch implements Database.Batchable<SObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(ReminderAccountPlanBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            
            for(Account acc : accList){
                Integer days = Date.valueOf(acc.CreatedDate).daysBetween(System.today());
                if(acc.CSL__c!= Null || acc.CoCSL__c != Null || acc.NSL__c != Null ){
                    if(days > 30 || days > 45 || days > 60  || days > 60){
                        // For Email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        
                        if(acc.CSL__c != Null && acc.CoCSL__c == Null && acc.NSL__c == Null ){
                            email.setToAddresses(new String[] {acc.CSL__r.Email});
                        }
                        else if(acc.CoCSL__c != Null && acc.CSL__c == Null && acc.NSL__c == Null){
                            email.setToAddresses(new String[] {acc.CoCSL__r.Email});
                        }
                        else if(acc.NSL__c != Null && acc.CoCSL__c == Null && acc.CSL__c == Null){
                            email.setToAddresses(new String[] {acc.NSL__r.Email});
                        }
                        else if(acc.CSL__c != Null && acc.CoCSL__c != Null && acc.NSL__c == Null){
                            email.setToAddresses(new String[] {acc.CSL__r.Email, acc.CoCSL__r.Email});
                        }
                        else if(acc.NSL__c != Null && acc.CoCSL__c != Null && acc.CSL__c == Null){
                            email.setToAddresses(new String[] {acc.NSL__r.Email, acc.CoCSL__r.Email});
                        }
                        else if(acc.NSL__c != Null && acc.CSL__c != Null && acc.CoCSL__c == Null){
                            email.setToAddresses(new String[] {acc.CSL__r.Email, acc.NSL__r.Email});
                        }
                        else if(acc.CSL__c != Null && acc.CoCSL__c != Null && acc.NSL__c != Null){
                            email.setToAddresses(new String[] {acc.CSL__r.Email, acc.CoCSL__r.Email, acc.NSL__r.Email});
                        }
                        
                        
                        email.setSubject('Reminder Email to make Account Plan document');
                        String body = 'Hi Team <br> <br>';
                        body += 'Congrats! a new Client is emerged into the system and now you are required to create an Account Plan for the Client ' + acc.Name + ' which includes the 30-60-90 days plan. <br> ';
                        body += 'Once created, Please schedule a discussion with NSL to discuss on Account Plan. <br> <br>';
                        body += 'Regards <br> GT Team </br>';
                        email.setHtmlBody(body);
                        mailsList.add(email);
                    }
                }
            }
            
            if(!mailsList.isEmpty()){              
                Messaging.sendEmail(mailsList);
            }
            else{
                System.debug('Mail List is empty');
            }
        }
        catch(Exception e){
            System.debug('Exception : ' + e.getMessage() + ' in Line : ' + e.getLineNumber());
        }
        
    }
    global void finish(Database.BatchableContext bc){
        
    }
}