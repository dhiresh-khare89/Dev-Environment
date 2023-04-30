//By Rohitash Mourya

public without sharing class leadSharingForNSL {
    public static void leadRecordSharingToNSL(List<ID> leadRecordIDs,Map<Id,Lead> oldLeadMap){
        System.debug('oldLeadMap=='+oldLeadMap);
        List<LeadShare> listLeadShareRecord =new List<LeadShare>();
        List<Lead> leadRecordList=[Select NSL__c,Id from Lead where Id in:leadRecordIDs]; 
        UserRecordAccess userAccess = new UserRecordAccess();
        IF(leadRecordList[0].NSL__c!=null){
         userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: leadRecordList[0].NSL__c AND RecordId =: leadRecordList[0].Id LIMIT 1];
        }
        List<LeadShare> leadShareList=new List<LeadShare>();
        Id shareId=leadRecordList[0].id;
        Id nslIdd;
        if(oldLeadMap.get(leadRecordList[0].id).NSL__c!=leadRecordList[0].Nsl__c){
           nslIdd=oldLeadMap.get(leadRecordList[0].id).NSL__c;
        }
        for(Lead LeadRecord:leadRecordList){
            if(LeadRecord.NSL__c!=null){
            LeadShare leadSharing=new leadShare();
            system.debug('LeadRecord.Id'+LeadRecord.Id);  
            leadSharing.LeadId=LeadRecord.Id;
            leadSharing.LeadAccessLevel='Edit';
            //leadSharing.LeadAccessLevel='All';
            system.debug('NSL'+LeadRecord.NSL__c);  
            leadSharing.UserOrGroupId=  LeadRecord.NSL__c;
            leadSharing.RowCause=Schema.LeadShare.RowCause.Manual;
            if(shareId!=NULL && nslIdd!=NULL){ 
                     system.Debug('shareId'+shareId);
                      system.Debug('nslIdd'+nslIdd);
                      system.Debug('nslIddnew'+LeadRecord.NSL__c);
                      
                     leadShareList=[select id,UserOrGroupId,RowCause,LeadId from LeadShare where RowCause ='manual' and LeadId = :shareId and UserOrGroupId= :nslIdd];
                }
             system.debug('Deleted List Size'+ leadShareList.size());
             if(leadShareList.size()>0){
               
                delete leadShareList;
        }  
      
            listLeadShareRecord.add(leadSharing);
              
        }
        }
        if(listLeadShareRecord.size()>0 && userAccess.HasEditAccess == False){
        List<Database.SaveResult> sr = Database.insert(listLeadShareRecord,true); 
         system.debug('created sharing for NSl');
        }
    }
    public static void leadRecordSharingToSectorCordinator(List<ID> leadRecordIDs,Map<Id,Lead> oldLeadMap){
        List<LeadShare> listLeadShareRecord =new List<LeadShare>();
        List<Lead> leadRecordList=[Select SectorCoordinator__c,Id from Lead where Id in:leadRecordIDs];
        UserRecordAccess userAccess = new UserRecordAccess();
        IF(leadRecordList[0].SectorCoordinator__c!=null){
            userAccess = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: leadRecordList[0].SectorCoordinator__c AND RecordId =: leadRecordList[0].Id LIMIT 1];
        }
        List<LeadShare> leadShareList=new List<LeadShare>();
        Id shareId=leadRecordList[0].id;
        Id sectorIdd;
        if(oldLeadMap.get(leadRecordList[0].id).SectorCoordinator__c!=leadRecordList[0].SectorCoordinator__c){
           sectorIdd=oldLeadMap.get(leadRecordList[0].id).SectorCoordinator__c;
        }
        for(Lead LeadRecord:leadRecordList){
            if(LeadRecord.SectorCoordinator__c!=null){
            LeadShare leadSharing=new leadShare();
            system.debug('LeadRecord.Id'+LeadRecord.Id);  
            leadSharing.LeadId=LeadRecord.Id;
            leadSharing.LeadAccessLevel='Edit';
            system.debug('SectorCoordinator__c'+LeadRecord.SectorCoordinator__c);  
            leadSharing.UserOrGroupId=  LeadRecord.SectorCoordinator__c;
            leadSharing.RowCause=Schema.LeadShare.RowCause.Manual;
            listLeadShareRecord.add(leadSharing);
                
        }
             if(shareId!=NULL && sectorIdd!=NULL){ 
                     system.Debug('shareId'+shareId);
                      system.Debug('sectorIdd'+sectorIdd);
                      system.Debug('sectorIddNew'+LeadRecord.SectorCoordinator__c);
                      
                     leadShareList=[select id,UserOrGroupId,RowCause,LeadId from LeadShare where RowCause ='manual' and LeadId = :shareId and UserOrGroupId= :sectorIdd];
                }
            system.debug('Deleted List Size'+ leadShareList.size());
             if(leadShareList.size()>0){
               
                delete leadShareList;
        }  
      
        }
        if(listLeadShareRecord.size()>0 && userAccess.HasEditAccess == False){
     
        List<Database.SaveResult> sr = Database.insert(listLeadShareRecord,true); 
        system.debug('created sharing Sector bussiness Partner');
                   
        }
    }
    
}