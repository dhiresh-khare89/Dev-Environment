/**
* @author            : Ayush Joshi
* @group             : TechMatrix Consulting
* @description       : This batch will send Email and Notification to Opportunity Owner
* @created on        : 20-11-2022
* @last modified by  : Gaurav Kumar
* @last modified on  : 26/12/2022
* @Helper Class 	 : SendEmailToEOBatchHelper 
* @Scheduled Class   : ScheduledSendEmailToEOBatch
* @Test Class :
**/
global class SendEmailToEOBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(SendEmailToEOBatchHelper.getQuery());
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> oppoList){
        List<CustomNotificationType> typeList = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Opportunity_Stage_is_on_Closed_Won'];
        List<String> emailList = new List<String>();
        System.debug('Opportunity List'+oppoList);
        if(!oppoList.isEmpty()){  //if opportunity list is not Empty
            for(Opportunity oppoObj:oppoList){
                System.debug('Email :'+oppoObj.Nurture_Finalizing_Closure_Date__c);
                  System.debug('opportunity Name'+oppoObj.Name);
                Integer NoOfDays = oppoObj.Nurture_Finalizing_Closure_Date__c.daysBetween((System.today()));
                oppoObj.Calculate_Days_On_Nurture_Stage__c = String.valueOf(NoOfDays);
                //System.debug('On Nurture Stage Days'+NoOfDays+' and calculate field'+oppoObj.Calculate_Days_On_Nurture_Stage__c);
                if(NoOfDays>15){  //15 days activity done or not then send a notification
                    emailList.add(oppoObj.Owner.Email);
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setBody('Opportunity Stage is on Nurture & Finalizing Closure');
                    notification.setTitle(oppoObj.Name);
                    notification.setTargetId(oppoObj.id);
                    notification.setNotificationTypeId(typeList[0].id);
                    notification.send(new Set<String> {oppoObj.OwnerId});
                }
            }
            System.debug('Owner Emails'+emailList);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailList);
            mail.setSubject('Please Change Opportunity Stage');
            mail.plainTextBody='"You are now on the "Closed Won" Stage.Please collaborate and capture leader perspective on your'+
                '"Problem and Impact analysis document ". Also, generate and get approvals on Commercials'+
                'You can notify and collaborate with peers/leaders on Chatter.Once done, please submit request for pitch deck, if required."';
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(Exception e){
                System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
            }
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}