public class CreateCommercialReportVFController {
    public Map<String, List<DataInformationWrapper>> wrapperList { get; set; }
    public CreateCommercialReportVFController(ApexPages.StandardController controller){
    wrapperList = EnquiryRelatedCommercialAndCommercialLineItem(ApexPages.currentPage().getParameters().get('id'));
    }
   @AuraEnabled
    public static Map<String, List<DataInformationWrapper>> EnquiryRelatedCommercialAndCommercialLineItem(String IntegratedEnquiryId) {
        System.debug('getEnquiryRelatedCommercialAndCommercialLineItem ==');
        System.debug('IntegratedEnquiryId =='+IntegratedEnquiryId);
        Map<String, List<DataInformationWrapper>> enquiryNameAndQuoteLineItemMap = New Map<String, List<DataInformationWrapper>>();
        List<QuoteLineItem> quoteLineItemList = [SELECT Id,Product2.Name,Quantity,UnitPrice,Quote.Opportunity.Name,Quote.Opportunity.Id,Commercial_Amount__c,Quote.Name, Quote.GrandTotal,
                                                 Discount,Net_Amount__c FROM QuoteLineItem
                                                 WHERE QuoteId IN (SELECT Id FROM Quote WHERE Opportunity.IntegratedEnquiry__c =: IntegratedEnquiryId AND IsSyncing=true)];
        System.debug('quoteLineItemList=='+quoteLineItemList);
          List<DataInformationWrapper> wrapperList = new List<DataInformationWrapper>();
            for(QuoteLineItem quoteObj:quoteLineItemList){
                if(enquiryNameAndQuoteLineItemMap.containsKey(quoteObj.Quote.Opportunity.Name)){
                    DataInformationWrapper wrapObj = new DataInformationWrapper();
                    wrapObj.ProductName = quoteObj.Product2.Name;
                    wrapObj.enquiryName = quoteObj.Quote.Opportunity.Name;
                    wrapObj.quoteName = quoteObj.Quote.Name;
                    wrapObj.grandTotal = quoteObj.Quote.GrandTotal;
                    wrapObj.quantity = quoteObj.Quantity;
                    wrapObj.salesPrice = quoteObj.UnitPrice;
                    wrapObj.commercialAmount = quoteObj.Commercial_Amount__c;
                    wrapObj.discount = quoteObj.Discount;
                    wrapObj.netAmount = quoteObj.Net_Amount__c;
                    wrapObj.Id = quoteObj.Quote.Opportunity.Id;
                    enquiryNameAndQuoteLineItemMap.get(quoteObj.Quote.Opportunity.Name).add(wrapObj);
                }
                else{
                    enquiryNameAndQuoteLineItemMap.put(quoteObj.Quote.Opportunity.Name, new list<DataInformationWrapper>());
                    DataInformationWrapper wrapObj = new DataInformationWrapper();
                    wrapObj.ProductName = quoteObj.Product2.Name;
                    wrapObj.enquiryName = quoteObj.Quote.Opportunity.Name;
                    wrapObj.quoteName = quoteObj.Quote.Name;
                    wrapObj.grandTotal = quoteObj.Quote.GrandTotal;
                    wrapObj.quantity = quoteObj.Quantity;
                    wrapObj.salesPrice = quoteObj.UnitPrice;
                    wrapObj.commercialAmount = quoteObj.Commercial_Amount__c;
                    wrapObj.discount = quoteObj.Discount;
                    wrapObj.netAmount = quoteObj.Net_Amount__c;
                    wrapObj.Id = quoteObj.Quote.Opportunity.Id;
                    
                    enquiryNameAndQuoteLineItemMap.get(quoteObj.Quote.Opportunity.Name).add(wrapObj);
                }
                /*DataInformationWrapper wrapObj = new DataInformationWrapper();
                wrapObj.ProductName = quoteObj.Product2.Name;
                wrapObj.enquiryName = quoteObj.Quote.Opportunity.Name;
                wrapObj.quoteName = quoteObj.Quote.Name;
                wrapObj.quantity = quoteObj.Quantity;
                wrapObj.salesPrice = quoteObj.UnitPrice;
                wrapObj.commercialAmount = quoteObj.Commercial_Amount__c;
                wrapObj.discount = quoteObj.Discount;
                wrapObj.netAmount = quoteObj.Net_Amount__c;
                wrapObj.Id = quoteObj.Quote.Opportunity.Id;
                wrapperList.add(wrapObj);*/
            }
        return enquiryNameAndQuoteLineItemMap;
	}
   public class DataInformationWrapper{
        @AuraEnabled
        public String ProductName{get; set;}
        @AuraEnabled
        public String enquiryName{get; set;}
        @AuraEnabled
        public String quoteName{get; set;}
       @AuraEnabled
        public Decimal quantity{get; set;}
       @AuraEnabled
        public Decimal salesPrice{get; set;}
       @AuraEnabled
        public Decimal commercialAmount{get; set;}
       @AuraEnabled
        public Decimal discount{get; set;}
       @AuraEnabled
        public Decimal netAmount{get; set;}
       @AuraEnabled
        public Decimal grandTotal{get; set;}
       @AuraEnabled
        public String Id{get; set;}
       
    }
    
    //Method for getting integrated enquiry Name 
    @AuraEnabled
    public static String getIntegratedEnquiryName(String IntegratedEnquiryId) {
        System.debug('getIntegratedEnquiryName ==');
        
        IntegratedEnquiry__c IntegratedEnquiryName = [SELECT Name From IntegratedEnquiry__c Where Id =: IntegratedEnquiryId];
        System.debug('IntegratedEnquiryName =='+IntegratedEnquiryName);
        System.debug('IntegratedEnquiryName.name =='+IntegratedEnquiryName.name);
        return IntegratedEnquiryName.name;
        
    }
    
}