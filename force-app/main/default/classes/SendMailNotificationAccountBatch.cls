/*
* Author : Suraj Kumar
* Date : 21-12-2022
* Description : Batch class to send Email and custom notification to Account Team members
* Helper Class : SendMailNotificationAccountBatchHelper
* Schedule class : ScheduleSendMailNotificationAccountBatch
*/

global class SendMailNotificationAccountBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(SendMailNotificationAccountBatchHelper.getQuery());
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList){
        try{
            List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
            
            CustomNotificationType quarterlyNotification = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Client_Quarterly_Notification'];
            
            List<AccountTeamMember> accTeamList = [SELECT User.Email, AccountId, Id FROM AccountTeamMember WHERE AccountId IN : accList];
            
            for(AccountTeamMember teamMember : accTeamList) {
                
                // For Email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {teamMember.User.Email});
                email.setSubject('Quarterly email for upgradation account to CX/GX');
                String body = 'Dear Account Team <br> <br>';
                body += 'It is a time for having a discussion with NSL on the previous quarter. During this meeting, please provide rationale for converting your Account into a Key Account, if you seem necessary. <br> ';
                body += 'In Preparation for the meeting, please update the rationale as well as CSL/Co-CSL. <br> <br>';
                body += 'Regards <br> C&M Team </br>';
                email.setHtmlBody(body);
                System.debug('Email : ' + email);
                mailsList.add(email);
                
                // For Notification 
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setBody('Dear Account Team \n \n It is a time for having a discussion with NSL on the previous quarter. During this meeting, please provide rationale for converting your Account into a Key Account, if you deem necessary. \n In Preparation for the meeting, please update the rationale as well as CSL/Co-CSL.\n \n Regards \n C&M Team');
                notification.setTitle('Quarterly email for upgradation account to CX/GX');
                notification.setTargetId(teamMember.Id);
                notification.setNotificationTypeId(quarterlyNotification.Id);
                notification.send(new Set<String> {teamMember.User.Id});
                
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