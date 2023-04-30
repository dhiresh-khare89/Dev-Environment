public with sharing class FetchDataFromCapIQMCAController {
@AuraEnabled(cacheable=true)
public static List<Client_News__c> getEnquiryRelatedClientNews(String OpportunityId) {
try {
    List<Client_News__c> clientNewsList = new List<Client_News__c>();
Set<Id> accountIds = new Set<Id>();
List<Opportunity> opportunityList = [SELECT Id, Name, AccountId FROM Opportunity WHERE Id =:OpportunityId];
System.debug('opportunityList=='+opportunityList);
if(!opportunityList.isEmpty()) {
    for(Opportunity oppObj : opportunityList) {
        if(String.isNotBlank(oppObj.AccountId)){
            accountIds.add(oppObj.AccountId);
            System.debug('accountIds=='+accountIds);
            }
    }
}
if(!accountIds.isEmpty()) {
     clientNewsList = [SELECT Id,Name,IQ_KEY_DEV_HEADLINE__c,IQ_KEY_DEV_TYPE__c,Key_Development_Date__c,Alert__c,Case_Number__c,convictedDirectors__c,remarks_details__c,severity__c From Client_News__c Where Client__c =: AccountIds];
     System.debug('clientNewsList=='+clientNewsList);
}
return clientNewsList;

} catch (Exception e) {
throw new AuraHandledException(e.getMessage());
}
}

@AuraEnabled(cacheable=true)
    public static List<Client_News__c> getClientNews(String clientId){
        return [SELECT Id, Name , IQ_KEY_DEV_HEADLINE__c,IQ_KEY_DEV_TYPE__c,Key_Development_Date__c,Alert__c, Case_Number__c,convictedDirectors__c,remarks_details__c,severity__c From Client_News__c Where Client__c =:clientId];
    }
    
public FetchDataFromCapIQMCAController() {

}
}