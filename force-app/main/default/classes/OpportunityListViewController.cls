public with sharing class OpportunityListViewController {
    // Method to get the products with opportunity
@AuraEnabled(cacheable=true)
public static List<OpportunityLineItem> getProduct(String leadId){
    try {
        List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem>();
        Set<Id> accIdSet = new Set<Id>();
        List<Lead> leadList = [SELECT Id, Client__c FROM Lead WHERE Id =:leadId];
        if(!leadList.isEmpty()){
        for(Lead lead: leadList){
          if(String.isNotBlank(lead.Client__c)){
            accIdSet.add(lead.Client__c);
          }
        }
    }
    if(accIdSet.size() > 0){
        oppProductList = [SELECT Opportunity.CreatedBy.CreatedDate, Opportunity.Name, Opportunity.StageName, Name FROM OpportunityLineItem WHERE Opportunity.AccountId IN:accIdSet];
    }
    return oppProductList;  
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
}