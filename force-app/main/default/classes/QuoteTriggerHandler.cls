public class QuoteTriggerHandler {
    public static void isBeforeInsert(List<Quote>QuoteList) {
        setNSLOnQuote(QuoteList); 
    }
    
    public static void setNSLOnQuote(List<Quote>QuoteList) {
        Set<Id>opportunityIds = new Set<Id>();
        for(Quote qt : QuoteList) {
            if(!String.isBlank(qt.opportunityId)) {
                opportunityIds.add(qt.opportunityId); 
                System.debug('opportunityIds=='+opportunityIds);
            }
        }
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([SELECT Name,NSL__c,CSL__c,CoCSL__c,RELBUL__c,RMP__c,Expertise__c,SubExpertise__c FROM Opportunity Where Id =:opportunityIds]);
        System.debug('opportunityMap==='+opportunityMap);
        
        for(Quote quote : QuoteList) {
            if(quote.NSL__c == null && quote.CSL__c == null && quote.CoCSL__c == null && quote.RELBUL__c == null && quote.RMP__c == null) {
                if(opportunityMap.containsKey(quote.OpportunityId)) {
                    quote.NSL__c = opportunityMap.get(quote.OpportunityId).NSL__c;
                    System.debug('quote.NSL__c==='+quote.NSL__c);
                    quote.CSL__c = opportunityMap.get(quote.OpportunityId).CSL__c;
                    System.debug('quote.CSL__c==='+quote.CSL__c);
                    quote.CoCSL__c = opportunityMap.get(quote.OpportunityId).CoCSL__c;
                    System.debug('quote.CoCSL__c==='+quote.CoCSL__c);
                    quote.RELBUL__c = opportunityMap.get(quote.OpportunityId).RELBUL__c;
                    System.debug('quote.RELBUL__c==='+quote.RELBUL__c);
                    quote.RMP__c = opportunityMap.get(quote.OpportunityId).RMP__c;
                    System.debug('quote.RMP__c==='+quote.RMP__c);
                }
            }
        }
        System.debug('QuoteList==='+QuoteList); 
    }
}