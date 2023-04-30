public with sharing class rCCFormHelper {
    @AuraEnabled(cacheable=true)
    public static List<RCC__c> getRCCs(String enquiryId){
        List<Opportunity> opp = [SELECT AccountId FROM Opportunity WHERE Id =: enquiryId LIMIT 1];
        if(opp.size() > 0){
            return [SELECT Id, Name, ClientName__r.Name, Enquiry__r.Name, Enquiry__r.RCCCurrentStatus__c, CreatedDate, Enquiry__r.PendingDaysToExpire__c FROM RCC__c WHERE ClientName__c =:opp[0].AccountId WITH SECURITY_ENFORCED];
        }else{
            return [SELECT Id, Name, ClientName__r.Name, Enquiry__r.Name, Enquiry__r.RCCCurrentStatus__c, CreatedDate, Enquiry__r.PendingDaysToExpire__c FROM RCC__c WHERE Enquiry__c =:enquiryId WITH SECURITY_ENFORCED];
        }
    }
}