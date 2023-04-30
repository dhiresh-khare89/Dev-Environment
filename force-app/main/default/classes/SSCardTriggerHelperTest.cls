/*
* Author : Gaurav Kumar
* Description :
* class : SSCardTriggerHelper
* Trigger : SSCardTrigger
* Date : 10-01-2023
*/
@isTest
public class SSCardTriggerHelperTest {
    
    @IsTest
    public static void test(){
        sansancard__SSCard__c ssCard = new sansancard__SSCard__c();
        ssCard.sansancard__FirstName__c = 'Test';
        ssCard.sansancard__LastName__c = 'Test';
        ssCard.sansancard__Company__c = 'TMC';
        ssCard.sansancard__Title__c ='Visiting';
        ssCard.sansancard__AdsStreet__c = 'gamma1';
        ssCard.sansancard__AdsCity__c = 'Noida';
        ssCard.sansancard__AdsZip__c ='201308';
        ssCard.sansancard__AdsState__c ='UP';
        ssCard.sansancard__AdsCountry__c ='India';
        ssCard.sansancard__Phone__c='1234567891';
        ssCard.sansancard__MobilePhone__c = '12345678123';
        ssCard.sansancard__Fax__c = 'Test';
        ssCard.sansancard__Email__c = 'abc@gmail.com';
        ssCard.sansancard__Website__c = 'abc.com';
        ssCard.sansancard__Description__c = 'Test';
        insert ssCard;
    }
}