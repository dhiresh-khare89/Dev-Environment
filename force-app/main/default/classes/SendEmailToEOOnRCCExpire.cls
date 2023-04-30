global class SendEmailToEOOnRCCExpire implements Database.Batchable<sObject>{
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Owner.Email FROM Opportunity WHERE Id IN (SELECT Enquiry__c FROM RCC__c WHERE Enquiry__c != Null)';
        return Database.getQueryLocator(query);
    }
    // Execute Method
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList){
        CustomNotificationType rccExpire = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'RCC_Expire'];
        List<Opportunity> updatedOppList = new List<Opportunity>();
        List<Messaging.Email> emailList = new List<Messaging.Email>();
        if(!oppList.isEmpty()){
            for(Opportunity opp: oppList){
                if(opp.DueDateTillExpiry__c != Null && opp.PendingDaysToExpire__c != Null){
                    if(Date.Today() > opp.DueDateTillExpiry__c){
                        if(opp.StageName != 'Closed Won' || opp.StageName != 'Closed Lost'){
                            opp.RCCStatus__c = 'Expired';
                            updatedOppList.add(opp);
                            // Send Email To Enquiry Owner As Previous RCC Expired, Please Complete New RCC
                            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                            String[] toAddress = new String[]{opp.Owner.Email};
                            emailMsg.setToAddresses(toAddress);
                            emailMsg.setSubject('Please Complete RCC');
                            emailMsg.plaintextbody = 'Previous RCC Expired';
                            emailList.add(emailMsg);
                            
                            // Notification To Enquiry Owner As RCC Is About To Expire
                            Messaging.CustomNotification notification = new Messaging.CustomNotification();
                            notification.setBody('Previous RCC Expired, Please Complete RCC Again');
                            notification.setTitle(opp.Name);
                            notification.setTargetId(opp.Id);
                            notification.setNotificationTypeId(rccExpire.Id);
                            try {
                                notification.send(new Set<String> {opp.OwnerId});
                            }
                            catch (Exception e) {
                                System.debug('Problem sending notification: ' + e.getMessage());
                            }
                        }else if(opp.PendingDaysToExpire__c == 15 || opp.PendingDaysToExpire__c == 7){
                            Integer daysToExpire = 90 - Integer.valueOf(opp.PendingDaysToExpire__c);
                            // Send Email To Enquiry Owner As RCC is About To Expire
                            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
                            String[] toAddress = new String[]{opp.Owner.Email};
                            emailMsg.setToAddresses(toAddress);
                            emailMsg.setSubject('Days Left Till RCC Expire');
                            emailMsg.plaintextbody = 'Only' + daysToExpire + 'Days Left Till RCC Expire';
                            emailList.add(emailMsg);
                            
                            // Notification To Enquiry Owner As RCC Is About To Expire
                            Messaging.CustomNotification notification = new Messaging.CustomNotification();
                            notification.setBody('Only' + daysToExpire + 'Days Left Till RCC Expire');
                            notification.setTitle(opp.Name);
                            notification.setTargetId(opp.Id);
                            notification.setNotificationTypeId(rccExpire.Id);
                            try {
                                notification.send(new Set<String> {opp.OwnerId});
                            }
                            catch (Exception e) {
                                System.debug('Problem sending notification: ' + e.getMessage());
                            }
                        }else{
                            
                        }
                    }
                }
            }
            try{
                Messaging.sendEmail(emailList);
            }catch(Exception e){
                System.debug('getmessage'+e.getMessage()+'getline number'+e.getLineNumber());
            }
            if(!updatedOppList.isEmpty()){
                update updatedOppList;
            }          
        }
    }
    
    // Finish Method
    global void finish(Database.BatchableContext BC){
        
    }
    
}