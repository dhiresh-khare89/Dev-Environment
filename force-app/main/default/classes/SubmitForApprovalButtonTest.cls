/*
*Author : Suraj Kumar 
*Description : Test class of SubmitForApprovalButtonController 
*Date :13/12/2022 
*/

@isTest
public class SubmitForApprovalButtonTest {
    
    @testSetup
    public static void testSetup(){
        
        Lead l = new Lead();
        l.LastName = 'TestLastttName';
        l.Company = 'TestCompany';
        l.NSL__c = UserInfo.getUserId();
        insert l;
        
        Account acc = new Account(Name='Test Account', AccountType__c = 'Key Client');
        insert acc;
        
        Contact con = new Contact(LastName='testName');
        insert con;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TestName ';
        opp.StageName = 'Identify/Create Enquiry';
        opp.CloseDate = System.today();
        opp.AccountId = acc.Id;
        opp.ClientContact__c = con.Id;
        Test.setMock(HttpCalloutMock.class, new EnquiryTriggerMock());
        insert opp;
        
        Quote q = new Quote();
        q.Name = 'Test Quote';
        q.Status = 'Internal Review';
        q.OpportunityId = opp.Id;
        insert q;
        
        
    }
    
    @isTest
    public static void sendEnquiryApprovalRequestTest1(){
        List<User> userList = [select Id FROM User];
        List<Lead> leadList = [Select Id FROM Lead];
        List<Opportunity> oppList = [SELECT id, AccountId, OwnerId, ClientContact__c FROM Opportunity];
        List<Quote> quoteList = [select id,Opportunity.Account.AccountType__c,Opportunity.CSL__c, OpportunityId, Status, Opportunity.Account.Recovery__c
                                 from Quote];
        
        
        Test.startTest();
        
        SubmitForApprovalButtonController.sendEnquiryApprovalRequest(leadList[0].id, 'NSL_Approval' , 'Test');
        SubmitForApprovalButtonController.sendOpportunityApprovalRequest(oppList[0].id, 'DS_Team_Approval' , 'Test');
        SubmitForApprovalButtonController.sendQuoteApprovalRequest(quoteList[0].id);
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void sendEnquiryApprovalRequestTest2(){
        List<User> userList = [select Id FROM User];
        List<Lead> leadList = [Select Id FROM Lead];
        List<Opportunity> oppList = [SELECT id, AccountId, OwnerId, ClientContact__c FROM Opportunity];
        
        Test.startTest();
        
        SubmitForApprovalButtonController.sendEnquiryApprovalRequest(leadList[0].id, 'ClientCouncilApproval' , 'Test');
        SubmitForApprovalButtonController.sendOpportunityApprovalRequest(oppList[0].id, 'ClientCouncilApproval' , 'Test');
        
        Test.stopTest();
        
    }
    

}