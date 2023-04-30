/*
*Author : Gaurav Kumar 
*Description :LeadTriggerHandler 
*Date :13/12/2022 
*/
@isTest
public class LeadTriggerHandlerTest {
    @isTest
    public static void test(){
        List<Lead> leadList = new List<Lead>();
        Map<Id ,Lead> oldLeadMap = new Map<Id ,Lead>();
        
        Account acc = new Account(Name = 'Test');
        
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
        
        
        
        Lead obj = new Lead();
        obj.LastName = 'Test';
        obj.Sector__c = 'Government';
        obj.NSL__c = u.Id;
        obj.Status = 'Client Take-On PreWork';
        obj.Company = 'TMC';
        obj.Email = 'test@gmail.com';
        obj.MobilePhone = '1234567891';
        insert obj;
        
        Lead obj1 = new Lead();
        obj1.LastName = 'Test';
        obj1.NSLApprovalStatus__c = 'Approved';
        obj1.Status = 'Internal / External Discussions';
        obj1.CCApprovalStatus__c = 'Approved';
        obj1.OnNewStage__c = 2323;
        obj1.Expertise__c = 'Forensic';
        obj1.SubExpertise__c = 'Cyber';
        obj1.Region__c = 'North';
        obj1.NSLApprovalRejectionRecommendation__c = 'fgnc';
        obj1.Company = 'TMC';
        obj1.NSL__c = u.Id;
        obj1.OwnerId = u.Id;
        obj1.Expertise__c = '';
        obj1.CCApprovalRejectionRecommendation__c= 'sdfsdf';
        obj1.ClientBackground__c = 'sdasd';
        obj1.GrowthPotential__c = 'fdsdf';
        obj1.TentativeFee__c =123;
        obj1.HowDidYouArriveAThisTentativeFee__c = 'dasd';
        obj1.ShortSummary__c = 'sdfsad';
        //obj1.CreatedDate = datetime.newInstance('2022', '12', '13');
        obj1.Sector__c = 'Government';
        obj1.Email = 'test@gmail.com';
        obj1.MobilePhone = '1234567891';
        insert obj1;
        leadList.add(obj1);
        obj1.CCApprovalRejectionRecommendation__c = 'Test';
        update obj1;
        oldLeadMap.put(obj1.Id ,obj1);
        obj1.NSLApprovalRejectionRecommendation__c = 'fgfsdfnc';
        update obj1;
        //insert leadList;
        List<Task> taskList = new List<Task>();
        Task objTask = new Task();
        objTask.Subject = 'Next steps & actions discussed with NSL';
        objTask.WhoId = obj1.Id;
        objTask.CurrencyIsoCode = '';
        objTask.OwnerId = u.Id;
        insert objTask;
        //ProcessInstance pi = [SELECT TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :acc.Id];
        
        Approval.ProcessSubmitRequest req1 =
            new Approval.ProcessSubmitRequest();
        req1.setComments('Approved.');
        req1.setNextApproverIds(new Id[]{UserInfo.getUserId()});
        
        req1.setObjectId(obj1.id);//Set the record Id
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(UserInfo.getUserId());
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('');//set the name of your approval process
        req1.setSkipEntryCriteria(true);
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        
        //Step for approving by user 1st
        Approval.ProcessWorkitemRequest req2 =  new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});//UserInfo.getUserId()
        system.debug('req2::'+req2);
        // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(result.getNewWorkitemIds().get(0));
        system.debug('req3::'+req2);
        // Submit the request for approval
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        Test.startTest();
        LeadTriggerHandler.isAfterUpdateMethod(leadList , oldLeadMap);
        //LeadTriggerHandler.AgingOfStage(leadList);
        LeadTriggerHandler.updateApprovalFieldsOfNSLOnEnquiry(leadList);
        LeadTriggerHandler.updateApprovalFieldsOfCCOnEnquiry(leadList);
        Test.stopTest(); 
        
    }
   
}