/*
* Author : Gaurav Kumar
* Description :
* class : SendEmailAccountOwnerBatch
* Helper Class : SendEmailAccountOwnerBatchHelper
* Scheduler class : ScheduledSendEmailAccountOwnerBatch
* Date :
*/
@isTest
public class ScheduledSendEmailAccountOwnerBatchTest{
    @isTest
    public static void testschedule() {
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
        insert acc;
        SendEmailAccountOwnerBatch accbatch = new SendEmailAccountOwnerBatch();
        
        //accbatch.accList = 'select Id,name,Status_DS_Team_Remark_Status__c from Account';
        Test.StartTest();
        Database.executebatch(accbatch);
        ScheduledSendEmailAccountOwnerBatch testsche = new ScheduledSendEmailAccountOwnerBatch();
        String sch = '0 0 * * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}