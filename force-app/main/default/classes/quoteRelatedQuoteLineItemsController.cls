public with sharing class quoteRelatedQuoteLineItemsController {
    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> EnquiryRelatedCommercialAndCommercialLineItem(String IntegratedEnquiryId) {
        System.debug('getEnquiryRelatedCommercialAndCommercialLineItem ==');
        System.debug('IntegratedEnquiryId =='+IntegratedEnquiryId);
        
        List<QuoteLineItem> quoteLineItemList = [SELECT Id, Quote.Opportunity.Name, Quote.Name FROM QuoteLineItem WHERE QuoteId IN (SELECT Id FROM Quote WHERE Opportunity.IntegratedEnquiry__c =: IntegratedEnquiryId)];
        System.debug('quoteLineItemList=='+quoteLineItemList);
        
        return quoteLineItemList;
    }
    
    @AuraEnabled 
    public static String getPdfFileAsBase64String() {
       // PageReference pdfPage = Page.envelope;
        //Blob pdfBlob = pdfPage.getContent();
       // String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
       // return base64Pdf;
       return null;
    }
    
}