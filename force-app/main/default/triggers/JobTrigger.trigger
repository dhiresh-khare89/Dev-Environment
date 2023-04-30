trigger JobTrigger on Job__c (after insert) {

    if(Trigger.isAfter && Trigger.isInsert){
         map<string,string> mapOfEnquiryIdAndWCGTJobId= new  map<string,string>();
        for(Job__c j:Trigger.new){
            if(string.isNotBlank(j.WCGTProjectID__c)){
                mapOfEnquiryIdAndWCGTJobId.put(j.Enquiry__c,j.WCGTProjectID__c);
            }
        }
        if(mapOfEnquiryIdAndWCGTJobId != null){
            JobTriggerHelper.updateEnquiry(mapOfEnquiryIdAndWCGTJobId);
        }   
    }
}