public class BillingInformationOnEnquiry {

    @AURAENABLED(CACHEABLE=TRUE)
    public static List<wrpInvoiceData> getInvoiceListforJob(string enquiryId){
        set<String> wcgtJobId = new set<String>();
        List<Opportunity> oppList = [select Id,AccountId,Account.Name,WCGT_Job_ID__c 
                                     from Opportunity where AccountId =:enquiryId];
        List<wrpInvoiceData> wrpInvList = new List<wrpInvoiceData>();
        for(Opportunity opp:oppList){
            wcgtJobId.add(opp.WCGT_Job_ID__c);
        }
        if(wcgtJobId != null){
            for(PM_ACCT_INVOICE_HD__x inv:[SELECT Id,INVOICE_DATE__c,NET_AMT__c,INVOICE_TYPE__c,PROJECT_ID__c 
                                           FROM PM_ACCT_INVOICE_HD__x where PROJECT_ID__c in:wcgtJobId]){
               wrpInvoiceData wrpInv = new wrpInvoiceData();
                wrpInv.InvoiceType=inv.INVOICE_TYPE__c;
                wrpInv.InvoiceDate=inv.INVOICE_DATE__c;
                wrpInv.InvoiceAMount=inv.NET_AMT__c;
                wrpInvList.add(wrpInv);
            } 
        }
        if(wrpInvList.size()>0){
            return wrpInvList;
        }else{
            return null;
        }
        /*set<Id> jobId = new set<Id>();
        for(Job__c j:[select Id from Job__c where Enquiry__c =:enquiryId]){
         		jobId.add(j.Id);   
        }
        
        if(jobId != null){
         	return [SELECT Id,INVOICE_DATE__c,NET_AMT__c FROM PM_ACCT_INVOICE_HD__x limit 5/*where PROJECT_ID__c in:jobId*//*];   
        }else{
            return null;
        }*/
    } 
    
    public class wrpInvoiceData{
        @auraEnabled
        public string InvoiceType{get;set;}
        @AuraEnabled    
        public Decimal InvoiceAMount{get;set;}
        @AuraEnabled
        public DateTime InvoiceDate{get;set;}
    }
}