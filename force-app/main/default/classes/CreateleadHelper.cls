/*
 Written By: Rohitash mourya
     Created Date: 22/02/2023
     Last Modified By : Rohitash mourya
     Last Modified Date : 16-03-23
     Description : This class is used to create new client from Lwc and check duplicate client name
     Variable Used in Method : -
       leadObject: Stringify object recevied from new client lwc page .
       accountName: Client name recieved from new client lwc page for duplicate check in new client records
*/

public with sharing class CreateleadHelper {
    @AuraEnabled
    Public static String Createlead(String leadObject) {
        string str=null;
        try {
        	Lead leadlist=(Lead)JSON.deserialize(leadObject,lead.class);
            if(leadlist!=null){
                insert leadlist;
                str=leadlist.Id;
            }
        
            
        } catch (Exception e) {
            system.debug('eeee'+e);
            return str;
        }
        return str;
    }

    @AuraEnabled
    Public static Boolean findDuplicateAccount(String companyName){
        Boolean leadMatched;
        try{
            List<Account> listOfAccount = new List<Account>();
            listOfAccount = [SELECT Id, Name FROM Account WHERE Name =: companyName];
           
            if(!listOfAccount.isEmpty()){
                leadMatched = true;
            }
            else{
                leadMatched = false;
            }
            return leadMatched;
        }
        catch(Exception ex){
            return leadMatched;
        }
    }

}