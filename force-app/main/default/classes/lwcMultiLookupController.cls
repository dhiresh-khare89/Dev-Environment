/*  Suraj Kumar
Date : 04-03-2023
Description : Used in multiLookup LWC Component
*/

public with sharing class lwcMultiLookupController {
    
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String value, List<String> selectedRecId) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();
        
        if(String.isNotEmpty(value)) {
            String query = 'Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
            }
        }
        return sObjectResultList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<User> getSelectedAttendees(Id eventId){
        List<EventRelation> evRelationList = [SELECT Id, RelationId, EventId FROM EventRelation WHERE RelationId != null AND EventId =: eventId];
        Event event = [SELECT Id, OwnerId, Actual_Attendees__c FROM Event WHERE Id=: eventId];
        System.debug('Actual_Attendees__c : ' + event.Actual_Attendees__c);
        
        List<String> attendeesNames;
        if(event.Actual_Attendees__c != null){
            attendeesNames = event.Actual_Attendees__c.split(',');
        }
        else{
           attendeesNames = new List<String>();
        }
        
        System.debug('attendeesNames : ' + attendeesNames);
        System.debug('usersYUpdated : ' + [SELECT Id, Name FROM User where Name In : attendeesNames]);
        Set<Id> userIds = new Set<Id>();
        
        for(EventRelation evRelation : evRelationList){
            userIds.add(evRelation.RelationId);
        }
        
        List<User> userList = [SELECT Id, Name FROM User where Id IN : userIds OR Id =: event.OwnerId OR Name In : attendeesNames];
        System.debug('userList : ' + userList);
        if(!userList.isEmpty()){
            return userList;
        }
        else{
            return null;
        }
        
    }
    
    @AuraEnabled
    public static void updateAttendees(Id eventId, String attendeesIds){
        Event event = [SELECT Id, AttendeesId__c,Actual_Attendees__c, Subject,OwnerId  FROM Event WHERE Id =: eventId];
        String employeeIds = '';
       
        List<String> idList = attendeesIds.split(',');
        String attendeeNames = '';
        
        for(User user : [SELECT Id, Name, EMP_ID__c FROM User WHERE Id IN : idList ]){
            System.debug('empId : ' + user.EMP_ID__c);
            
            if(attendeeNames == ''){
                attendeeNames += user.Name;
                
            }
            else{
                attendeeNames += ',' + user.Name;
            }
            if(String.isNotBlank(user.EMP_ID__c) && user.Id != event.OwnerId){
                if(employeeIds == ''){
                    employeeIds += user.EMP_ID__c;
                }
                else{
                    employeeIds += ', ' + user.EMP_ID__c;
                }
            }
            
            System.debug('employeeIds : ' + employeeIds);
            
        }
        event.AttendeesId__c = employeeIds;
        event.Actual_Attendees__c = attendeeNames;
        System.debug('event : ' + event);
        update event;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        
        public SObJectResult(String recNameTemp, Id recIdTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
        }
        public SObJectResult() {
            
        }
    }
}