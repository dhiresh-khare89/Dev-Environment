public Without Sharing class EnquirySharingForEA {
    
    Public Static void EASharingRule(List<ID> enquiryIdList){
        List<Opportunity> EnquiryRecordList=[Select Executive_Assistant__c,Id from Opportunity where Id in:enquiryIdList]; 
        
        List<OpportunityShare>  opprtunitySharingList=new List<OpportunityShare>();
        For(opportunity opp:EnquiryRecordList){
            
            OpportunityShare OpportunitySharing=new OpportunityShare();
            system.debug('leadRecordList[0].Id'+opp.Id);  
            OpportunitySharing.OpportunityId=opp.Id;
            OpportunitySharing.OpportunityAccessLevel='Edit';
            system.debug('NSL'+opp.Executive_Assistant__c);  
            OpportunitySharing.UserOrGroupId=  opp.Executive_Assistant__c;
            OpportunitySharing.RowCause=Schema.OpportunityShare.RowCause.Manual;
            
            opprtunitySharingList.add(OpportunitySharing);
            
        }
        
        List<Database.SaveResult> sr = Database.insert(opprtunitySharingList,false); 
        
    }
    Public Static void NSLSharingRule(List<ID> enquiryIdList){
        List<Opportunity> EnquiryRecordList=[Select NSL__C,Id from Opportunity where Id in:enquiryIdList]; 
        
        List<OpportunityShare>  opprtunitySharingList=new List<OpportunityShare>();
        For(opportunity opp:EnquiryRecordList){
            
            OpportunityShare OpportunitySharing=new OpportunityShare();
            system.debug('leadRecordList[0].Id'+opp.Id);  
            OpportunitySharing.OpportunityId=opp.Id;
            OpportunitySharing.OpportunityAccessLevel='Edit';
            system.debug('NSL'+opp.NSL__C);  
            OpportunitySharing.UserOrGroupId=  opp.NSL__C;
            OpportunitySharing.RowCause=Schema.OpportunityShare.RowCause.Manual;
            
            opprtunitySharingList.add(OpportunitySharing);
            
        }
        
        List<Database.SaveResult> sr = Database.insert(opprtunitySharingList,false); 
        
    }
    
}