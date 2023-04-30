/*
* Author : Gaurav Kumar
* Description :
* class : SendEmailToEOBatch
* Helper Class : SendEmailToEOBatchHelper
* Scheduler class : ScheduledSendEmailToEOBatch
* Date :
*/
@isTest
public class ScheduledSendEmailToEOBatchTest {
    
    @isTest
    public static void testScheduler(){
        Profile pro = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new user();
        u.LastName = 'Testclassra Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'testclasshhhy@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileId = pro.Id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        Account acc = new Account();
        acc.Name = 'Test';
        acc.OwnerId=u.Id;
        acc.Status_DS_Team_Remark_Status__c ='Approved';
        //insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'TestName ';
        opp.StageName = 'Closed Won';
        opp.CloseDate = System.today();
        opp.Nurture_Finalizing_Closure_Date__c = System.today()-40;
        //opp.AccountId = acc.Id;
        insert opp;
        opp.Nurture_Finalizing_Closure_Date__c = System.today()-50;
        update opp;
        SendEmailToEOBatch obj = new SendEmailToEOBatch();
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new EnquiryTriggerMock());
        Database.executebatch(obj);
        ScheduledSendEmailToEOBatch testsche = new ScheduledSendEmailToEOBatch();
        String sch = '0 0 * * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}