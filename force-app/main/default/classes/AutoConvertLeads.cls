public class AutoConvertLeads {
    @InvocableMethod
    public static void leadAssign(List<Id> leadIds){        
        LeadStatus cLeadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = True AND MasterLabel = 'Accept Client' LIMIT 1];
        List<Lead> leadList = [SELECT Id,Solution__c, TentativeFee__c, Region__c, ClientContact__c, Expertise__c, GTEmployee__c, Company, IsLead__c, CMSpoc__c, CCApprovalRejectionRecommendation__c, CCApprovalStatus__c, CCApprovedRejectedBy__c,
                               CCApprovedRejectedDate__c, Chamber_contacts__c, LeadSource, Client__c, ClientBackground__c, ClientName__c, COCSL__c, CompanyHQ__c, Competitor__c, CAGR__c, Corridor__c, CountryCode__c, CrossSell__c, CSL__c, CSP__c, Email, EstimatedRevenue__c,
                               FindingPartner__c, GrowthPotential__c, InboundReferral__c, HeadQuarters__c, HowDidYouArriveAThisTentativeFee__c, Industry, Investors_Private_Equity_Firms__c, InvestorsPrivateEquityFirms__c, KMP__c, LawFirm__c, LawFirmContacts__c, Market__c,
                               MobilePhone, Name, HowCanWeHelpYou__c, NewClientAge__c, OwnerId, Owner.Name, Channel__c, NumberOfEmployees, NSL__c, NSLApprovalRejectionRecommendation__c, NSLApprovalStatus__c, NSLApprovedRejectedBy__c, NSLApprovedRejectedDate__c, pi__campaign__c,
                               pi__comments__c, pi__conversion_date__c, pi__created_date__c, pi__first_activity__c, pi__grade__c, pi__last_activity__c, pi__Pardot_Last_Scored_At__c, pi__notes__c, pi__score__c, PEInvestors__c, Phone,Rating, Recovery__c,
                               Chamber__c, Remark__c, Sector__c, SectorCoordinator__c, Segment__c, ShortSummary__c, SMELeader__c, SubExpertise__c, SubSector__c, TotalIncome__c, TotalRevenue__c, Website, YearFounded__c, YoungCSL__c, CompanyHQ__City__s, CompanyHQ__CountryCode__s,
                               CompanyHQ__GeocodeAccuracy__s, CompanyHQ__Latitude__s, CompanyHQ__Longitude__s, CompanyHQ__PostalCode__s, CompanyHQ__StateCode__s, CompanyHQ__Street__s From Lead Where id IN :leadIds];
        System.debug('leadList : '+leadList);
        List<Database.LeadConvert> massLeadConvert = new List<Database.LeadConvert>();
        List<IntegratedEnquiry__c> integEnqList = new List<IntegratedEnquiry__c>(); 
        DateTime TodayDate = System.today();
        String dateWithoutTime = TodayDate.format('ddMMyy');
        for(Lead lead : leadList) { 
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(lead.id);
            leadConvert.setConvertedStatus(cLeadStatus.MasterLabel);
            leadConvert.setOwnerId(lead.OwnerId);
            leadConvert.setDoNotCreateOpportunity(TRUE);
            // Integrated Enquiry Object
            IntegratedEnquiry__c integEnqObj = new IntegratedEnquiry__c();
            integEnqObj.OwnerId = lead.OwnerId;
            integEnqObj.Name =  lead.Company+'-'+lead.Solution__c+'-'+lead.Region__c+'-'+dateWithoutTime;
            integEnqObj.Solution1__c = lead.Solution__c;
            System.debug('lead.Expertise : '+lead.Expertise__c);
            integEnqObj.Expertise__c = lead.Expertise__c;
            System.debug('lead.Expertise : '+lead.Expertise__c);
            integEnqObj.Company__c = lead.Company;
            integEnqObj.GTEmployee__c = lead.GTEmployee__c;
            integEnqObj.IsOriginatedFromLeadConversion__c = lead.IsLead__c;
            integEnqObj.ClientContact__c = lead.ClientContact__c;
            integEnqObj.TentativeFee__c = lead.TentativeFee__c;
          //  integEnqObj.Address__c = lead.Address;
            integEnqObj.CMSpoc__c = lead.CMSpoc__c;
            integEnqObj.CCApprovalRejectionRecommendation__c = lead.CCApprovalRejectionRecommendation__c;
            integEnqObj.CCApprovalStatus__c = lead.CCApprovalStatus__c;
            integEnqObj.CCApprovedRejectedBy__c = lead.CCApprovedRejectedBy__c;
            integEnqObj.CCApprovedRejectedDate__c = lead.CCApprovedRejectedDate__c;
            integEnqObj.Chamber_Contacts__c = lead.Chamber_contacts__c;
        //    integEnqObj.Channel__c = lead.Channel__c;
      //      integEnqObj.Client__c = lead.Client__c;
            integEnqObj.ClientBackground__c = lead.ClientBackground__c;
            integEnqObj.ClientName__c = lead.ClientName__c;
            integEnqObj.COCSL__c = lead.COCSL__c;
            
           /* integEnqObj.CompanyHQ__City__s = lead.CompanyHQ__City__s;
            integEnqObj.CompanyHQ__CountryCode__s = lead.CompanyHQ__CountryCode__s;
            integEnqObj.CompanyHQ__GeocodeAccuracy__s = lead.CompanyHQ__GeocodeAccuracy__s;
            integEnqObj.CompanyHQ__Latitude__s = lead.CompanyHQ__Latitude__s;
            integEnqObj.CompanyHQ__Longitude__s = lead.CompanyHQ__Longitude__s;
            integEnqObj.CompanyHQ__PostalCode__s = lead.CompanyHQ__PostalCode__s;
            integEnqObj.CompanyHQ__StateCode__s = lead.CompanyHQ__StateCode__s;
            integEnqObj.CompanyHQ__Street__s = lead.CompanyHQ__Street__s;*/
            
            integEnqObj.Competitor__c = lead.Competitor__c;
            integEnqObj.CAGR__c = lead.CAGR__c;
            integEnqObj.Corridor__c = lead.Corridor__c;
          //  integEnqObj.Country_Code__c = lead.CountryCode__c;
          // integEnqObj.CreatedById = lead.CreatedById;
         //   integEnqObj.CreatedByScanToSalesforce__c = lead.sansancard__CreatedByScanToSalesforce__c;
            integEnqObj.CrossSell__c = lead.CrossSell__c;
            integEnqObj.CSL__c = lead.CSL__c;
            integEnqObj.CSP__c = lead.CSP__c;
            integEnqObj.Email__c = lead.Email;
            integEnqObj.EstimatedRevenue__c = lead.EstimatedRevenue__c;
            //integEnqObj.Fee_INR_Lacs__c = lead.Fee_INR_Lacs__c;
            integEnqObj.FindingPartner__c = lead.FindingPartner__c;
            integEnqObj.GrowthPotential__c = lead.GrowthPotential__c;
            integEnqObj.GTMemberFirms__c = lead.InboundReferral__c;
            integEnqObj.HeadQuarters__c = lead.HeadQuarters__c;
            integEnqObj.HowDidYouArriveAThisTentativeFee__c = lead.HowDidYouArriveAThisTentativeFee__c;
            /* We comment industry because value is not matching with global industry value */
           // integEnqObj.Industry__c = lead.Industry;
            integEnqObj.Investors_Private_Equity_Firms__c = lead.Investors_Private_Equity_Firms__c;
            integEnqObj.InvestorsPrivateEquityFirms__c = lead.InvestorsPrivateEquityFirms__c;
            integEnqObj.KMP__c = lead.KMP__c;
          //  integEnqObj.LastModifiedById = lead.LastModifiedById;
            integEnqObj.Law_Firm__c = lead.LawFirm__c;
            integEnqObj.Law_Firm_Contact__c = lead.LawFirmContacts__c;
            integEnqObj.Market__c = lead.Market__c;
            integEnqObj.Mobile__c = lead.MobilePhone;
            integEnqObj.NewClientName__c = lead.Name;
            integEnqObj.HowCanWeHelpYou__c = lead.HowCanWeHelpYou__c;
          //  integEnqObj.NewClientAge__c = lead.NewClientAge__c;
            integEnqObj.NewClientOwner__c = lead.Owner.Name;
            if(String.isNotBlank(lead.Channel__c)){
            integEnqObj.Channel__c = lead.Channel__c;
            }
            if(String.isNotBlank(lead.LeadSource)){
                integEnqObj.LeadSource__c = lead.LeadSource;
            }
            integEnqObj.NumberOEmployees__c = lead.NumberOfEmployees;
            integEnqObj.NSL__c = lead.NSL__c;
            integEnqObj.NSLApprovalRejectionRecommendation__c = lead.NSLApprovalRejectionRecommendation__c;
            integEnqObj.NSLApprovalStatus__c = lead.NSLApprovalStatus__c;
            integEnqObj.NSLApprovedRejectedBy__c = lead.NSLApprovedRejectedBy__c;
            integEnqObj.NSLApprovedRejectedDate__c = lead.NSLApprovedRejectedDate__c;
            integEnqObj.PardotCampaign__c = lead.pi__campaign__c;
            integEnqObj.PardotComments__c = lead.pi__comments__c;
            integEnqObj.PardotConversionDate__c = lead.pi__conversion_date__c;
            integEnqObj.PardotCreatedDate__c = lead.pi__created_date__c;
            integEnqObj.Pardot_First_Activity__c = lead.pi__first_activity__c;
            integEnqObj.PardotGrade__c = lead.pi__grade__c;
            integEnqObj.PardotLastActivity__c = lead.pi__last_activity__c;
            integEnqObj.PardotLastScoredAt__c = lead.pi__Pardot_Last_Scored_At__c;
            integEnqObj.PardotNotes__c = lead.pi__notes__c;
            integEnqObj.PardotScore__c = lead.pi__score__c;
            integEnqObj.PEInvestors__c = lead.PEInvestors__c;
            integEnqObj.Phone__c = lead.Phone;
            //integEnqObj.ProbabilityOfWinning__c = lead.ProbabilityOfWinning__c;
            integEnqObj.Rating__c = lead.Rating;
            integEnqObj.Recovery__c = lead.Recovery__c;
            integEnqObj.Chamber__c = lead.Chamber__c;
            integEnqObj.Region__c = lead.Region__c;
            integEnqObj.Remark__c = lead.Remark__c;
            integEnqObj.Sector__c = lead.Sector__c;
            integEnqObj.SectorCoordinator__c = lead.SectorCoordinator__c;
            integEnqObj.Segment__c = lead.Segment__c;
            integEnqObj.ShortSummary__c = lead.ShortSummary__c;
            integEnqObj.SMELeader__c = lead.SMELeader__c;
            if(String.isNotBlank(lead.SubExpertise__c)){
            integEnqObj.SubExpertise__c = lead.SubExpertise__c;
            }
            if(String.isNotBlank(lead.SubSector__c)){
            integEnqObj.SubSector__c = lead.SubSector__c;
            }
            integEnqList.add(integEnqObj);
            System.debug('integEnqList : '+integEnqList);
            massLeadConvert.add(leadConvert);
        }
        if(!massLeadConvert.isEmpty()){
            System.debug('massLeadConvert : '+massLeadConvert);
            List<Database.LeadConvertResult> lCR = Database.convertLead(massLeadConvert);
            insert integEnqList;
        }
    }
    
}