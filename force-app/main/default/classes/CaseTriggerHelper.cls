public without sharing class CaseTriggerHelper {
    public static void updateStatusOnCase(List<Case> caseList){
        try{
            for(Case caseObj:caseList){
                caseObj.Status = 'In Progress';
            }
        }
        catch(Exception e){
            System.debug('Error##'+e.getLineNumber());
        }
        
    }
    /*By :-Suresh gupta
	*Date:- 23 Feb 2023
	*Purpose:- Created New Client When Case Status is "Convert to New Client"
	*/
    /*------------------------------------------------------*/   
    
    public static void afterUpdateMethod(List<Case> caseList){
        try{
            List<Lead> leadListToBeInserted = New List<Lead>();
            
            Group sectorAssignmentTeamQueue= [SELECT Id from Group WHERE Type = 'Queue' AND DeveloperName = 'SectorAssignmentTeam'];
            Id readRecordTypeIdOfCase =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Record_Type_For_Read_Only_cases').getRecordTypeId();
            List<Case> caseListToBeUpdated = new List<Case>();
            for(Case caseObj:caseList){
                system.debug('afterInsertMethod Method has been Called');
                if(String.isNotBlank(caseObj.Sectors__c) && 
                   String.isNotBlank(caseObj.SuppliedName) && 
                   String.isNotBlank(caseObj.SuppliedEmail) && 
                   String.isNotBlank(caseObj.Website__c) && 
                   String.isNotBlank(caseObj.Client_Name__c) && 
                   caseObj.SuppliedPhone != null){
                       system.debug('Inside Loop');
                       Lead leadObj = new Lead();
                       if(caseObj.Country_Code__c!=null){
                           leadObj.CountryCode__c = caseObj.Country_Code__c;
                       }
                       leadObj.LastName = caseObj.SuppliedName!=null?caseObj.SuppliedName:caseObj.CaseNumber;//case number
                       System.debug('check sector'+caseObj.Sectors__c);
                       leadObj.Sector__c= caseObj.Sectors__c;
                       leadObj.Status = 'Internal / External Discussions';
                       //leadObj.Expertise__c = caseObj.Expertise__c;
                       //leadObj.Solution__c = caseObj.Solution__c;
                       leadObj.LeadSource = 'Email';
                       leadObj.Channel__c = 'Digital';
                       leadObj.CountryCode__c = caseObj.Country_Code__c;
                       leadObj.MobilePhone = caseObj.SuppliedPhone !=null ? caseObj.SuppliedPhone : '';
                       leadObj.Email = caseObj.SuppliedEmail !=null ? caseObj.SuppliedEmail : 'noemail@test.com';
                       leadObj.Company = caseObj.Client_Name__c;//email to case//new client source
                       //leadObj.OwnerId = sectorAssignmentTeamQueue.id;
                       leadObj.Website = caseObj.Website__c;
                       leadObj.Preliminary_New_Clients__c = caseObj.id;
                       leadListToBeInserted.add(leadObj);
                       //updating record type of Preliminary New Client
                   }
            }
            if(leadListToBeInserted.size()>0){
                insert leadListToBeInserted;
                
                system.debug('New Clients Created Successfully');
                
            }
            if(caseList.size()>0){
                
                for(Case caseObj:[select id,RecordTypeId from Case where id IN:caseList]){
                    caseObj.RecordTypeId = readRecordTypeIdOfCase;
                    caseListToBeUpdated.add(caseObj);
                }


                //update caseListToBeUpdated;
                system.debug('Case Updated Successfully');
            }
        }
        catch(exception e){
            system.debug('Exception---.'+e.getMessage());
            system.debug('Exception---.'+e.getLineNumber());
        }
        
    }
}