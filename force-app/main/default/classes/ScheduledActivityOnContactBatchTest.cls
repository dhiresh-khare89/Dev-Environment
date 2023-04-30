/*
* Author : Gaurav Kumar
* Description :
* class : ActivityOnContactBatch
* Helper Class : ActivityOnContactBatchHelper
* Scheduler class : ScheduledActivityOnContactBatch
* Date :
*/
@isTest
public class ScheduledActivityOnContactBatchTest {
    
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
        insert acc;
        Datetime pastDate = Datetime.now().addDays(-20);
        Test.setCreatedDate(acc.Id, pastDate);
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        //con.LastModifiedDate=System.today()-20;
        //con.LastActivityDate = System.today()-20;
        insert con;
        //Test.setLastActivityDate(con.Id, pastDate);
        Contact conDataList = [SELECT Id,Name,LastActivityDate FROM Contact WHERE LastActivityDate < Last_N_Days : 15 LIMIT 1];
        ActivityOnContactBatch accClassObj = new ActivityOnContactBatch();
        Test.StartTest();
        Database.executebatch(accClassObj);
        ScheduledActivityOnContactBatch testsche = new ScheduledActivityOnContactBatch();
        String sch = '0 0 * * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}