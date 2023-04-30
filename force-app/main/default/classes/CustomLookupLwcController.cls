/*
API : 50
Source : lwcFactory.com
*/
public class CustomLookupLwcController {
    // Method to fetch lookup search result   
     @AuraEnabled
     public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName,string RecordTypeName,string accountRecordId) {    
          system.debug('recordtypeId'+RecordTypeName);
          Id recordTypeId;
         if(RecordTypeName!='')
         recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(RecordTypeName).getRecordTypeId();
         List < sObject > returnList = new List < sObject > ();
         system.debug('hi'+recordTypeId);
         string active='Active';
         string sWildCardText = '%' + searchKey + '%';
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText ';
         if(string.isNotBlank(recordTypeId)){
             sQuery+=' and RecordTypeId = : recordTypeId';
         }
         if(string.isNotBlank(accountRecordId) && accountRecordId!='BOD'){
             
             sQuery+=' and AccountId=:accountRecordId and Contact_status__c=:active';
         }else IF(accountRecordId=='BOD'){
             string strr='Yes';
             sQuery+=' and BOD_Flag__c=:strr and Contact_status__c=:active';
         }
         sQuery+=' order by createdDate DESC LIMIT 5';
         for (sObject obj: database.query(sQuery)) {
             returnList.add(obj);
         }
         return returnList;
     }
     
     // Method to fetch lookup default value 
     @AuraEnabled
     public static sObject fetchDefaultRecord(string recordId , string sObjectApiName,string RecordTypeName) {
         string sRecId = recordId;    
         Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(RecordTypeName).getRecordTypeId();
         
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where RecordTypeId = : recordTypeId LIMIT 1';
         system.debug('sQuery'+sQuery);
         for (sObject obj: database.query(sQuery)) {
             return obj;
         }
         return null;
     }
     
 }