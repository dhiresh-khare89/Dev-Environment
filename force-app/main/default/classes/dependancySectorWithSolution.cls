public with sharing class dependancySectorWithSolution {
    @AuraEnabled(cacheable=true)
       public static List<PiclistWrapperClass> PicklistValues(String Sector){
         List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
         sector_cordinator__mdt sectorSolution = [select Label,sector__c,sub_sector__c from sector_cordinator__mdt where sector__c=:Sector limit 1];
         List<String> ListOfSolution = new List<String>();
         if(sectorSolution.sub_sector__c!=null){
            ListOfSolution= sectorSolution.sub_sector__c.split(';');
        
           for(String res : ListOfSolution) {
                
                  PiclistWrapperClass pwc = new PiclistWrapperClass();
                   pwc.picklistvalue = res;
                   pwc.picklistlabel=  res;
                     wrapperList.add(pwc);
                 }
         } 
           System.debug('wrapperList'+wrapperList);

           return wrapperList;
        }
      
        @AuraEnabled(cacheable=true)
        public static List<PiclistWrapperClass> newClientSourcePicklistValues(){
          List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
          List<LeadSource_For_LWC__mdt> leadSource = [select New_Client_Source__c from LeadSource_For_LWC__mdt ORDER BY New_Client_Source__c asc];
          List<String> ListOfSolution = new List<String>();
        
            for(LeadSource_For_LWC__mdt res : leadSource) {
                 
                   PiclistWrapperClass pwc = new PiclistWrapperClass();
                    pwc.picklistvalue = res.New_Client_Source__c;
                    pwc.picklistlabel=  res.New_Client_Source__c;
                      wrapperList.add(pwc);
                  }
            System.debug('wrapperList'+wrapperList);
 
            return wrapperList;
         }
      
      
        public class PiclistWrapperClass{
           @AuraEnabled public String picklistvalue;
           @AuraEnabled public String picklistlabel;
        }
   }