public with sharing class getIndustriesForDigitalChannels {
       @invocableMethod
       public static List<string> picklistValues(List<String> str){
         List<PiclistWrapperClass> wrapperList = new List<PiclistWrapperClass>();
         String fieldname='Industry_for_Digital_Channels__c';
         String objectname='Lead';
         List<String> industrylist=new list<String>();
          String[] types = new String[]{objectname};
           Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
           for(Schema.DescribeSobjectResult res : results) {
              for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldname).getDescribe().getPicklistValues()) {
                 if (entry.isActive()) {
                 // PiclistWrapperClass pwc = new PiclistWrapperClass();
                 industrylist.add(entry.getValue());
                
                 }
              }
           }
           return industrylist;
        }
   
        public class PiclistWrapperClass{
           @AuraEnabled public id id;
           @AuraEnabled public String Value;
        }
   }