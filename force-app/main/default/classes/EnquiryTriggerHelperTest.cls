/*
* Author :Gaurav Kumar 
* Date :27/12/2022
* class :EnquiryTriggerHelper
* Trigger :enquiryTrigger
*/
@isTest
public class EnquiryTriggerHelperTest {
    @isTest
    public static void test(){
        List<Opportunity> oppList = new List<Opportunity>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        Opportunity oppObj = new Opportunity();
        //oppObj.IntegratedEnquiry__c = intEnqObj.Id;
        //oppObj.AccountId = acc.Id;
        oppObj.Name = 'Test';
        oppObj.CloseDate = System.today();
        oppObj.StageName = 'New';
        insert oppObj ;
        oppList.add(oppObj);
        oppMap.put(oppObj.Id ,oppObj);
        try{
            EnquiryTriggerHelper.isBeforeInsert(oppList);
            EnquiryTriggerHelper.isAfterUpdate(oppList,oppMap);
        }
        Catch(Exception ex){
            System.debug('Error :'+ex.getMessage());
            System.debug('In Line Number :'+ex.getLineNumber());
        }
        
    }
}