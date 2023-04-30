public class JobTriggerHelper {

    public static void updateEnquiry(map<string,string> mapOfEnquiryIdAndWCGTJobId){
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Opportunity opp:[select Id,WCGT_Job_ID__c from Opportunity where Id in:mapOfEnquiryIdAndWCGTJobId.keySet() ]){
            if(mapOfEnquiryIdAndWCGTJobId.ContainsKey(opp.Id)){
                Opportunity oppObj = new Opportunity();
                oppObj.Id=opp.Id;
                oppObj.WCGT_Job_ID__c = mapOfEnquiryIdAndWCGTJobId.get(opp.Id);
                oppList.add(oppObj);
            }	            
        }
        
        if(oppList.size()>0){
            update oppList;
        }
		        
    }
}