public class clientLookupIntEnquiry {
    @AuraEnabled(cacheable=true)
    public static List<Account> getClientList(Id name) {
        System.debug(name);
        return [SELECT Name,Sector__c FROM Account WHERE Id =:name];
    }
}