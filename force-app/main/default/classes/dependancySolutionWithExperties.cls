public with sharing class dependancySolutionWithExperties {
    @AuraEnabled(cacheable=true)
       public static List<PiclistWrapperClass> PicklistValues(String Solution){
         List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
         Solution_Mapping_With_Expertice__mdt SolutionExperties = [select Label, Expertice__c from Solution_Mapping_With_Expertice__mdt where Label=:Solution];
         List<String> ListOfExperties = new List<String>();
         ListOfExperties= SolutionExperties.Expertice__c.split(';');
           for(String res : ListOfExperties) {
                
                  PiclistWrapperClass pwc = new PiclistWrapperClass();
                   pwc.picklistvalue = res;
                   pwc.picklistlabel=  res;
                     wrapperList.add(pwc);
                 }
              
           
           return wrapperList;
        }
   
        public class PiclistWrapperClass{
           @AuraEnabled public String picklistvalue;
           @AuraEnabled public String picklistlabel;
        }
   }