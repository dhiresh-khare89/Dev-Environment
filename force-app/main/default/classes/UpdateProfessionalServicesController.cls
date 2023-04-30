public class UpdateProfessionalServicesController {
   @AuraEnabled
   public static List<String> apexSubExpertise(Id leadId , String expertisePick){
       System.debug('leadId===>' + leadId);
       System.debug('expertisePick===>' + expertisePick);
       List<String> listToReturn = new List<String>();
    try {     
        for(Expertise_mapping_with_Sub_Expertise__mdt expertiMetaData : [SELECT Experties__c,Sub_Expertise__c FROM Expertise_mapping_with_Sub_Expertise__mdt WHERE Experties__c =: expertisePick.split(';')]){
            listToReturn.add(expertiMetaData.Sub_Expertise__c);
        System.debug('expertiMetaData====>' + expertiMetaData);
        }
        
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
       System.debug('listToReturn ' + listToReturn);
    return listToReturn;
   }
}