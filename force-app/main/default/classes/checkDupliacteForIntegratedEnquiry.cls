public class checkDupliacteForIntegratedEnquiry {
    @AuraEnabled(cacheable=true)
    public static Boolean checkDuplicate(string experty,string subexperty, string Company,string solution) {
        boolean isIntegratedEnquiryDuplicate=false;
        try{
        List<integratedEnquiry__c> listIntegratedEnq=[Select id,SubexpertiesForDuplicateRule__c ,ExpertiesForDuplicateRule__c,Solution1__c,Company__c from IntegratedEnquiry__c];
        for(integratedEnquiry__c integratedEnq : listIntegratedEnq){
            if(integratedEnq.SubexpertiesForDuplicateRule__c==subexperty && integratedEnq.ExpertiesForDuplicateRule__c==experty && integratedEnq.Solution1__c==solution && integratedEnq.Company__c==Company ){
                if(!isIntegratedEnquiryDuplicate){
                    isIntegratedEnquiryDuplicate=true;
                }
            }
        }

      }catch(Exception e){
        
      }
     
     return isIntegratedEnquiryDuplicate;
    }
}