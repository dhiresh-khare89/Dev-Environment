/*
*Author :Gaurav Kumar 
*Description : AutoConvertLeads 
*Date :13/12/2022 
* 
*/
@isTest
public class AutoConvertLeadsTest {
    @isTest
    public static void leadAssignTest(){
        List<Id> leadIdList = new List<Id>();
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
        
       /* 
        
        IntegratedEnquiry__c intEnqObj = new IntegratedEnquiry__c();
        intEnqObj.Company__c = 'Cloud Analogy';
        intEnqObj.Solution__c = 'ESOP';
        intEnqObj.Expertise__c = 'Human Capital Consulting';
        insert intEnqObj;
        
        Opportunity oppObj = new Opportunity();
        oppObj.IntegratedEnquiry__c = intEnqObj.Id;
        oppObj.AccountId = acc.Id;
        oppObj.Name = 'Test';
        oppObj.CloseDate = System.today();
        oppObj.StageName = 'New';
        insert oppObj;*/
        
        Lead obj1 = new Lead();
        obj1.LastName = 'Test Test';
        obj1.NSLApprovalStatus__c = 'Approved';
        obj1.Status = 'Accept Client';
        obj1.CCApprovalStatus__c = 'Approved';
        obj1.OnNewStage__c = 2323;
        obj1.Expertise__c = 'Human Capital Consulting';
        obj1.Solution__c = 'ESOP';
        obj1.SubExpertise__c = 'Cyber';
        obj1.Region__c = 'North';
        obj1.NSLApprovalRejectionRecommendation__c = 'fgnc';
        obj1.Company = 'Cloud Analogy';
        obj1.NSL__c = u.Id;
        obj1.OwnerId = u.Id;
        obj1.CCApprovalRejectionRecommendation__c= 'sdfsdf';
        obj1.ClientBackground__c = 'sdasd';
        obj1.GrowthPotential__c = 'fdsdf';
        obj1.TentativeFee__c =123;
        obj1.HowDidYouArriveAThisTentativeFee__c = 'dasd';
        obj1.ShortSummary__c = 'sdfsad';
        //obj1.CreatedDate = datetime.newInstance('2022', '12', '13');
        obj1.Sector__c = 'Automobile & Auto Components';
        obj1.Email = 'test@gmail.com';
        obj1.IsLead__c = True;
        obj1.MobilePhone = '1234567891';
        insert obj1;
        leadIdList.add(obj1.Id);
        
        Test.startTest();
        AutoConvertLeads.leadAssign(leadIdList);
        Test.stopTest();
        
        
        IntegratedEnquiry__c intEnqObj = new IntegratedEnquiry__c();
        intEnqObj.Company__c = 'Cloud Analogy';
        intEnqObj.Solution1__c = 'ESOP';
        intEnqObj.Expertise__c = 'Human Capital Consulting';
        insert intEnqObj;
        
        /*try{
            Test.startTest();
            AutoConvertLeads.leadAssign(leadIdList);
            Test.stopTest();
        }
        Catch(Exception ex){
            System.debug('Error :'+ex.getMessage());
            System.debug('In Line Number :'+ex.getLineNumber());
        }*/
    }
}