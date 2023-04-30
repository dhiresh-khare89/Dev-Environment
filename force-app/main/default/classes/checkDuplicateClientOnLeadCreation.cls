/*
Written By: Rohitash mourya
Created Date:  10/10/2022
Last Modified By : Rohitash mourya
Last Modified Date : 23-03-23
Description : This class is used to Assigned Sector bussines partner and NSL in case of manual new lead creation
*/
public with sharing class checkDuplicateClientOnLeadCreation {
    public static void checkDuplicateClient(list<Lead> leadRecord){
      /*  List<Account> clientrecord=[Select Name From Account Where name=:leadRecord[0].Company];
       // Map<String,sector_cordinator__mdt> sector = [select id,label,sector_cordinator_id__c,NSL__C,Sector__c from sector_cordinator__mdt];
       Map<string,sector_cordinator__mdt> sector=sector_cordinator__mdt.getAll();
        
        system.debug('Sector metadata'+sector);
        String sectorFedId;
        String nslFedId;
        User nslUser;
        user sectorBUser;
        system.debug('Lead Record 18'+leadRecord);
       
        for(lead lrecord:leadRecord){
            system.Debug('Sector Name'+lrecord.Sector__c);
            system.debug('Sector metadata'+sector.get(lrecord.Sector__c));
            if(lrecord.Sector__c != NULL && lrecord.Sector__c != '' && sector.get(lrecord.Sector__c)!=Null)
            {
                sectorFedId=sector.get(lrecord.Sector__c).sector_cordinator_id__c;
                nslFedId=sector.get(lrecord.Sector__c).NSL__C;
                
            }
            
        }
        nslUser=[select name,FederationIdentifier,Id from user where FederationIdentifier =:nslFedId Limit 1];
        sectorBUser=[select name,FederationIdentifier,Id from user where FederationIdentifier =:sectorFedId Limit 1];
        
        for(lead lrecord:leadRecord){
            if(lrecord.Sector__c != NULL && lrecord.Sector__c != '')
            {
                lrecord.SectorCoordinator__c= nslUser.Id;
                lrecord.NSL__c=sectorBUser.Id ;
            }
            
        }
        
        
        system.debug('clientrecord'+clientrecord);
        /* if(clientrecord.size()!=0){
for(lead lrecord:leadRecord){
system.debug('error');
lrecord.adderror('Client Already Exist With Similar Name');   
}

}*/
        
    }
    
    
}