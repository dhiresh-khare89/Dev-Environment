/*
* Author :Gaurav Kumar 
* Trigger :SSCardTrigger
* Date :09/01/2023
*/

public class SSCardTriggerHelper {
    public static void insertLeadFromVisitingCard(List<sansancard__SSCard__c> newListSSCard){
        //System.debug('newListSSCard :'+newListSSCard);
        List<Lead> leadList = new List<Lead>();
        if(!newListSSCard.isEmpty()){
            for(sansancard__SSCard__c ssCard : newListSSCard){
                 
                   if(ssCard.sansancard__MobilePhone__c == null
                   || ssCard.sansancard__MobilePhone__c.length()<10
                   || ssCard.sansancard__MobilePhone__c.length()>15
                   || !Pattern.matches('[0-9(),./\\-\\+]+', ssCard.sansancard__MobilePhone__c) 
                     ){
                       ssCard.addError('Please Enter mobile Number');
                   }
                else{
                    Lead obj = createLeadMapping(ssCard);
                    if(obj!=null){
                        leadList.add(obj);
                        System.debug('Lead List :'+leadList);
                    }
                }
            }
        }
        if(!leadList.isEmpty()){
            insert leadList;
        }
    }
    private Static lead createLeadMapping(sansancard__SSCard__c ssCard){
        Lead obj ;
        if(ssCard != null){
            obj = new Lead();
            obj.FirstName = ssCard.sansancard__FirstName__c;
            obj.LastName = ssCard.sansancard__LastName__c;
            obj.Company = ssCard.sansancard__Company__c;
            obj.Title = ssCard.sansancard__Title__c;
            obj.LeadSource = 'Visiting Card';
            //obj.LeadSource = 'Manual';
            //obj.Channel__c = 'Visiting card';// Comments on Behalf OF Swarna Sir Comment on UAT
            obj.Category__c = 'Cold';
            obj.Street = ssCard.sansancard__AdsStreet__c;
            obj.City = ssCard.sansancard__AdsCity__c;
            obj.PostalCode = ssCard.sansancard__AdsZip__c;
            obj.State = ssCard.sansancard__AdsState__c;
            obj.Country = ssCard.sansancard__AdsCountry__c;
            //obj.Address = ssCard.sansancard__Address__c;
            obj.Phone = ssCard.sansancard__Phone__c;
            obj.MobilePhone = ssCard.sansancard__MobilePhone__c;
            obj.Fax = ssCard.sansancard__Fax__c;
            obj.Email =ssCard.sansancard__Email__c;
            obj.Website = ssCard.sansancard__Website__c;
            obj.Description = ssCard.sansancard__Description__c;
            System.debug('obj : ' +obj);
        }
        return obj!=null?obj:null;
    }
}