/*
 * Author : Suraj Kumar
 * Date : 20-01-2023
 * Description : Controller class for Key development and Alerts LWC
 * Last Updated By :- Bhanwar 
 * Last Update Discription :- Added for Enquiry so we can get all the news related to that client
*/
public With Sharing class KeyDevAndAlertsController {
    
    @AuraEnabled
    public static List<Client_News__c> getNewClient(String recordId, String objectName){
        if(objectName == 'Lead'){
            Lead lead = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r ) FROM Lead WHERE Id =: recordId With Security_Enforced];
            
            if(!lead.Client_Newss__r.isEmpty() && lead.capIQId__c != Null){
                return lead.Client_Newss__r;
            }
            else{
                return null;
            }
        }
        else if(objectName == 'Account'){
            Account acc = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Account WHERE Id =: recordId With Security_Enforced];
            
            if(!acc.Client_Newss__r.isEmpty() && acc.capIQId__c != Null){
                return acc.Client_Newss__r;
            }
            else{
                return null;
            }
        }
        /*else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Opportunity WHERE Id =: recordId];
            System.debug('Opportunity : ' + opp.Client_Newss__r);
            
            if(!opp.Client_Newss__r.isEmpty() && opp.capIQId__c != Null){
                return opp.Client_Newss__r;
            }
            else{
                return null;
            }
        }*/
        // By Bhanwar 24/04/23
        else if(objectName == 'Opportunity'){
            Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: recordId With Security_Enforced];
            Account acc = [SELECT Id, Name, capIQId__c, (SELECT Id, Name, IQ_KEY_DEV_HEADLINE__c FROM Client_Newss__r) FROM Account WHERE Id =: opp.AccountId With Security_Enforced];
            
            if(!acc.Client_Newss__r.isEmpty() && acc.capIQId__c != Null){
                return acc.Client_Newss__r;
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
        
    }
    
    
}