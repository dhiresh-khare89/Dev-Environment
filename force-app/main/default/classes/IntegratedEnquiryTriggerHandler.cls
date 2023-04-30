public class IntegratedEnquiryTriggerHandler {
    public static void isAfterInsert(List<IntegratedEnquiry__c> newIntegEnqList, Map<Id, IntegratedEnquiry__c> newIntegEnqMap){
       IntegratedEnquiryTriggerHandler.createMultiEnquiry(newIntegEnqList);  
    }
    
    
    public static void createMultiEnquiry(List<IntegratedEnquiry__c> newIntegEnqList){
        Set<String> companyNameSet = new Set<String>();
        List<IntegratedEnquiry__c> integEnqList = new List<IntegratedEnquiry__c>(); 
        List<String> strList = new List<String>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(IntegratedEnquiry__c integEnq: newIntegEnqList){
            if(String.isNotBlank(integEnq.Company__c)){
                companyNameSet.add(integEnq.Company__c);
                System.debug('companyNameSet : '+companyNameSet);
            }
        }
        if(!companyNameSet.isEmpty()){
            List<Account> accList = [SELECT Id, Name FROM Account WHERE Name =: companyNameSet LIMIT 1];
            System.debug('accList : '+accList);
            for(Account acc: accList){
                IntegratedEnquiry__c integEnqObj = new IntegratedEnquiry__c();
                integEnqObj.Client__c = acc.Id;
                integEnqObj.Id = newIntegEnqList[0].Id;
                integEnqList.add(integEnqObj);
                System.debug('integEnqList : '+integEnqList);
            }
            if(!integEnqList.isEmpty()){
                System.debug('integEnqList Not Empty : '+integEnqList);
                update integEnqList;
            }
            // To create multiple opportunity from multi expertise
            strList = newIntegEnqList[0].Expertise__c.split(';');
            DateTime TodayDate = System.today();
            String dateWithoutTime = TodayDate.format('ddMMyy');
         
                for(String str : strList){
                    Opportunity oppObj = new Opportunity();
                    oppObj.AccountId = accList[0].Id;
                    oppObj.OwnerId = newIntegEnqList[0].OwnerId;
                    oppObj.Name = accList[0].Name+'-'+newIntegEnqList[0].Solution1__c+'-'+str+'-'+dateWithoutTime;
                    oppObj.CloseDate = System.today()+4;
                    oppObj.StageName = 'Identify/Create Enquiry';
                  //  oppObj.ClientName__c = accList[0].Id;
                    oppObj.IntegratedEnquiry__c = newIntegEnqList[0].Id;
                    oppObj.GTEmployee__c = newIntegEnqList[0].GTEmployee__c;
                    oppObj.IsOriginatedFromLeadConversion__c = newIntegEnqList[0].IsOriginatedFromLeadConversion__c;
                    oppObj.ClientContact__c = newIntegEnqList[0].ClientContact__c;
                    oppObj.TentativeFee__c = newIntegEnqList[0].TentativeFee__c;
                  //  oppObj.Address__c = newIntegEnqList[0].Address__c;
                    oppObj.CMSPoc__c = newIntegEnqList[0].CMSpoc__c;
                    oppObj.CCApprovalRejectionRecommendation__c = newIntegEnqList[0].CCApprovalRejectionRecommendation__c;
                    oppObj.CCApprovalStatus__c = newIntegEnqList[0].CCApprovalStatus__c;
                    oppObj.CCApprovedRejectedBy__c = newIntegEnqList[0].CCApprovedRejectedBy__c;
                    oppObj.CCApprovedRejectedDate__c = newIntegEnqList[0].CCApprovedRejectedDate__c;
                    oppObj.Chamber_contacts__c = newIntegEnqList[0].Chamber_Contacts__c;
                    /*
                    if(String.isNotBlank(newIntegEnqList[0].Channel__c)){
                    oppObj.Channel__c = newIntegEnqList[0].Channel__c;
                    }
*/
                    if(String.isNotBlank(newIntegEnqList[0].LeadSource__c)){
                        oppObj.LeadSource = newIntegEnqList[0].LeadSource__c;
                    }
                    oppObj.Client__c = newIntegEnqList[0].Client__c;
                    oppObj.ClientBackground__c = newIntegEnqList[0].ClientBackground__c;
                    oppObj.ClientName__c = newIntegEnqList[0].ClientName__c;
                    oppObj.CoCSL__c = newIntegEnqList[0].COCSL__c;
                    oppObj.CompanyHQ__City__s = newIntegEnqList[0].CompanyHQ__City__s;
                    oppObj.CompanyHQ__CountryCode__s = newIntegEnqList[0].CompanyHQ__CountryCode__s;
                    oppObj.CompanyHQ__GeocodeAccuracy__s = newIntegEnqList[0].CompanyHQ__GeocodeAccuracy__s;
                    oppObj.CompanyHQ__Latitude__s = newIntegEnqList[0].CompanyHQ__Latitude__s;
                    oppObj.CompanyHQ__Longitude__s = newIntegEnqList[0].CompanyHQ__Longitude__s;
                    oppObj.CompanyHQ__PostalCode__s = newIntegEnqList[0].CompanyHQ__PostalCode__s;
                    oppObj.CompanyHQ__StateCode__s = newIntegEnqList[0].CompanyHQ__StateCode__s;
                    oppObj.CompanyHQ__Street__s = newIntegEnqList[0].CompanyHQ__Street__s;
                    oppObj.GTCompetitors__c = newIntegEnqList[0].Competitor__c;
                    oppObj.CAGR__c = newIntegEnqList[0].CAGR__c;
                    oppObj.Corridor__c = newIntegEnqList[0].Corridor__c;
                //    oppObj.Country_Code__c = newIntegEnqList[0].Country_Code__c;
                    oppObj.CreatedByScanToSalesforce__c = newIntegEnqList[0].CreatedByScanToSalesforce__c;
                    oppObj.CrossSell__c = newIntegEnqList[0].CrossSell__c;
                    oppObj.CSL__c = newIntegEnqList[0].CSL__c;
                    oppObj.CSP__c = newIntegEnqList[0].CSP__c;
                    oppObj.Email__c = newIntegEnqList[0].Email__c;
                    oppObj.EstimatedRevenue__c = newIntegEnqList[0].EstimatedRevenue__c;
                    oppObj.Fee_INR_Lacs__c = newIntegEnqList[0].Fee_INR_Lacs__c;
                    oppObj.FindingPartner__c = newIntegEnqList[0].FindingPartner__c;
                    oppObj.GrowthPotential__c = newIntegEnqList[0].GrowthPotential__c;
                    oppObj.GTMemberFirms__c = newIntegEnqList[0].GTMemberFirms__c;
                    oppObj.HeadQuarters__c = newIntegEnqList[0].HeadQuarters__c;
                    oppObj.HowDidYouArriveAtThisTentativeFee__c = newIntegEnqList[0].HowDidYouArriveAThisTentativeFee__c;
                   /* We comment industry because value is not matching with global industry value */
                    //  oppObj.Industry__c = newIntegEnqList[0].Industry__c;
                    oppObj.Investors_Private_Equity_Firms__c = newIntegEnqList[0].Investors_Private_Equity_Firms__c;
                    oppObj.InvestorsPrivateEquityFirms__c = newIntegEnqList[0].InvestorsPrivateEquityFirms__c;
                    oppObj.KMP__c = newIntegEnqList[0].KMP__c;
                 // oppObj.LastModifiedById = newIntegEnqList[0].LastModifiedById;
                    oppObj.LawFirm__c = newIntegEnqList[0].Law_Firm__c;
                    oppObj.LawFirmContacts__c = newIntegEnqList[0].Law_Firm_Contact__c;
                    oppObj.Market__c = newIntegEnqList[0].Market__c;
                    oppObj.Mobile__c = newIntegEnqList[0].Mobile__c;
                    oppObj.NewClientName__c = newIntegEnqList[0].NewClientName__c;
                    oppObj.HowCanWeHelpYou__c = newIntegEnqList[0].HowCanWeHelpYou__c;
                 // oppObj.NewClientAge__c = newIntegEnqList[0].NewClientAge__c;
                    oppObj.NewClientOwner__c = newIntegEnqList[0].NewClientOwner__c;
                    oppObj.NumberOEmployees__c = newIntegEnqList[0].NumberOEmployees__c;
                    oppObj.NSL__c = newIntegEnqList[0].NSL__c;
                    oppObj.NSLApprovalRejectionRecommendation__c = newIntegEnqList[0].NSLApprovalRejectionRecommendation__C;
                    oppObj.NSLApprovalStatus__c = newIntegEnqList[0].NSLApprovalStatus__c;
                    oppObj.NSLApprovedRejectedBy__c = newIntegEnqList[0].NSLApprovedRejectedBy__c;
                    oppObj.NSLApprovedRejectedDate__c = newIntegEnqList[0].NSLApprovedRejectedDate__c;
                    oppObj.PardotCampaign__c = newIntegEnqList[0].PardotCampaign__c;
                    oppObj.PardotComments__c = newIntegEnqList[0].PardotComments__c;
                    oppObj.PardotConversionDate__c = newIntegEnqList[0].PardotConversionDate__c;
                    oppObj.PardotCreatedDate__c = newIntegEnqList[0].PardotCreatedDate__c;
                    oppObj.PardotFirstActivity__c = newIntegEnqList[0].Pardot_First_Activity__c;
                    oppObj.PardotGrade__c = newIntegEnqList[0].PardotGrade__c;
                    oppObj.PardotLastActivity__c = newIntegEnqList[0].PardotLastActivity__c;
                    oppObj.PardotLastScoredAt__c = newIntegEnqList[0].PardotLastScoredAt__c;
                    oppObj.PardotNotes__c = newIntegEnqList[0].PardotNotes__c;
                    oppObj.PardotScore__c = newIntegEnqList[0].PardotScore__c;
                    oppObj.PEInvestors__c = newIntegEnqList[0].PEInvestors__c;
                    oppObj.Phone__c = newIntegEnqList[0].Phone__c;
                    oppObj.ProbabilityOfWinning__c = newIntegEnqList[0].ProbabilityOfWinning__c;
                    oppObj.Rating__c = newIntegEnqList[0].Rating__c;
                    oppObj.Recovery__c = newIntegEnqList[0].Recovery__c;
                    oppObj.Chamber__c = newIntegEnqList[0].Chamber__c;
                    oppObj.Region__c = newIntegEnqList[0].Region__c;
                    oppObj.Remark__c = newIntegEnqList[0].Remark__c;
                    oppObj.Sector__c = newIntegEnqList[0].Sector__c;
                    oppObj.SectorCoordinator__c = newIntegEnqList[0].SectorCoordinator__c;
                    oppObj.Segment__c = newIntegEnqList[0].Segment__c;
                    oppObj.ShortSummary__c = newIntegEnqList[0].ShortSummary__c;
                    oppObj.SMELeader__c = newIntegEnqList[0].SMELeader__c;
                    oppObj.Expertise__c = str;
                    if(String.isNotBlank(newIntegEnqList[0].SubExpertise__c)){
                       oppObj.SubExpertise__c = newIntegEnqList[0].SubExpertise__c; 
                    }
                    if(String.isNotBlank(newIntegEnqList[0].SubSector__c)){
                    oppObj.SubSector__c = newIntegEnqList[0].SubSector__c;
                    }
                    oppList.add(oppObj);
                    System.debug('oppList if : '+oppList);
                }
          
            if(!oppList.isEmpty()){
                System.debug('oppList : '+oppList);
                insert oppList;
            }
            
        }
    }
    
    public static void isBeforeInsert(List<IntegratedEnquiry__c> newIntegEnqList){
        for(IntegratedEnquiry__c integEnq : newIntegEnqList ){
            if(integEnq.Expertise__c <> null)
                integEnq.ExpertiesForDuplicateRule__c = integEnq.Expertise__c;
            if(integEnq.SubExpertise__c <> null)
                integEnq.SubexpertiesForDuplicateRule__c = integEnq.SubExpertise__c;
        }
        
        // Even if 1 enquiry amongst the integrated enquiry is closed Won then it will not be possible to add another enquiry within the integrated enquiry
        PreventEnquiryIfAnyClosedWonEnquiryExistOnIntegEnq(newIntegEnqList);
    }
    
    public static void PreventEnquiryIfAnyClosedWonEnquiryExistOnIntegEnq(List<IntegratedEnquiry__c> newIntegEnqList){
        Set<Id> integEnqIdSet = new Set<Id>();
    }
    
}