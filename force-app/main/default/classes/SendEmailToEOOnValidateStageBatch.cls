/**
* @author            : Ankita Pathak
* @group             : TechMatrix Consulting
* @description       : if enquiry is still on the same stage "Validate Benefits & Value" for more than 14 days, then reminder email will be triggered to EO.
* @created on        : 24-11-2022
* @last modified on  : 25-11-2022/26-11-2022
* @last modified by  : Ankita Pathak
**/

global class SendEmailToEOOnValidateStageBatch implements Database.Batchable<sObject> {
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Inside Start Method==');
        String query = 'Select id,Owner.Email,Calculate_Days_On_Validate_Benefit_Stage__c,ValidateBenefitsValueDate__c from'+
            'Opportunity where StageName =\'Validate Benefits & Value\' AND Owner.Email!=null';   
        return Database.getQueryLocator(query);
    }
    //Execute Method
    global void execute(Database.BatchableContext BC, List<Opportunity> oppoList) {
        System.debug('Inside execute Method==');
        List<CustomNotificationType> typeList = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'Opportunity_Stage_is_on_Validate_Benefits_Value_Stage'];
        List<String> emailList = new List<String>();
        System.debug('Opportunity List'+oppoList);
        if(!oppoList.isEmpty()){
            for(Opportunity oppoObj:oppoList){
                Integer NoOfDays = oppoObj.ValidateBenefitsValueDate__c.daysBetween((System.today()));
                oppoObj.Calculate_Days_On_Validate_Benefit_Stage__c = String.valueOf(NoOfDays);
                System.debug('On Validate Benefits & Value Stage Days'+NoOfDays+' and calculate field'+oppoObj.Calculate_Days_On_Validate_Benefit_Stage__c);
                if(NoOfDays>15){
                    emailList.add(oppoObj.Owner.Email);
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    notification.setBody('Opportunity Stage is on Validate Benefits & Value Stage');
                    notification.setTitle(oppoObj.Name);
                    notification.setTargetId(oppoObj.id);
                    notification.setNotificationTypeId(typeList[0].id);
                    notification.send(new Set<String> {oppoObj.OwnerId});
                }
            }
            System.debug('Owner Emails'+emailList);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailList);
            mail.setSubject('Validate Benefits & Value Stage');
            mail.plainTextBody='"You are now on the "Validate Benefits & Value" Stage.Please collaborate and capture leader perspective on your'+
                '"Problem and Impact analysis document ". Also, generate and get approvals on Commercials'+
                'You can notify and collaborate with peers/leaders on Chatter.Once done, please submit request for pitch deck, if required."';
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
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