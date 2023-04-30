public without sharing class LookupController {

    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
        List < sObject > returnList = new List < sObject > ();
        string sWildCardText = '%' + searchKey + '%';
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText order by createdDate DESC LIMIT 5';
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    // Method to fetch lookup default value 
    @AuraEnabled
    public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
        string sRecId = recordId;    
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> lookUp(String recordTypeName, string myObject, String filter) {
        String myQuery = null;
        System.debug('recordTypeName : ' + recordTypeName + ' , myObject : ' + myObject + ' , ' + filter);
        if(String.isNotBlank(filter) && String.isNotBlank(recordTypeName)){
            if(myObject == 'Account'){
                myQuery = 'Select Id, Name, Account_Record_Type__c from '+myObject+' Where Account_Record_Type__c = \'' + recordTypeName + '\' AND '+filter+' LIMIT  5'; 
            }
            else if(myObject == 'Contact'){
                myQuery = 'Select Id, Name, Contact_Record_Type__c from '+myObject+' Where Contact_Record_Type__c = \'' + recordTypeName + '\' AND '+filter+' LIMIT  5'; 
            }
        }
        else {
            if(myObject == 'Account'){
                myQuery = 'Select Id, Name, Account_Record_Type__c from '+myObject+'  Where Account_Record_Type__c = \'' + recordTypeName +'\' ORDER BY LastViewedDate DESC LIMIT  5'; 
            }
            else if(myObject == 'Contact'){
                myQuery = 'Select Id, Name, Contact_Record_Type__c from '+myObject+' Where Contact_Record_Type__c = \'' + recordTypeName + '\' LIMIT  5'; 
                
            }
        }
        System.debug('myQuery : ' + myQuery);
        List<sObject> lookUpList = database.query(myQuery);
        
        if(!lookUpList.isEmpty()){
            System.debug('lookUpList : ' + lookUpList);
            return lookUpList; 
        }
        else{
            System.debug('null');
            return null;
        }
    }
}