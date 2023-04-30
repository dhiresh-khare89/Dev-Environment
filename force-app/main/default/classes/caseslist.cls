public with sharing class caseslist {

    @AuraEnabled(cacheable=true)
    public static List<Case> getCaseList() {
        return [SELECT Id, Reason,Subject ,	ContactEmail FROM Case];
    }
}