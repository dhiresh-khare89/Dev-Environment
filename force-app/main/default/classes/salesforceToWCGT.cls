/* 
     Written By: Bhanwar Singh
     Created Date: 12/20/2022
     Last Modified By : 
     Last Modified Date : 30-03-23
     Description : This class is used to send data from Salesforce to WCGT.
*/

public class salesforceToWCGT {
    //Send When NSL Approved 
    
        @Future(callout=true)
        public static Void sendWhenNSLApprovedNewClient(id NewClientid)
        {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://uat360.wcgt.in/GTSF/api/PipelineEnqiry/Insert');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            Lead leads = [SELECT Id,FirstName,LastName,Phone,Status,NSLApprovalStatus__c,Email,Company FROM Lead WHERE id =:  NewClientid];
            String statuss;
            if(leads.Status == 'Accept Client' ){
                statuss = 'New Client Won';
            }else if(leads.Status == 'NotAccept' ){
                statuss = 'New Client Lost';
            }else{
                statuss = 'NSL Approved';
            }
            
            String reqBody = '{"sFirstName": "'+leads.FirstName+'","sLastName": "'+leads.LastName+'","sClientId": "'+leads.Id+'","sMobileNo": "'+leads.Phone+'","sCompanyName": "'+leads.Company+'","sStatus": "2","sStatusReason": "'+statuss+'","sUserId": "US00012","sEmail": "'+leads.Email+'"}';
            system.debug('reqBody'+reqBody);
            req.setTimeout(3000);
            req.setBody(reqBody);
            HttpResponse resp;
            try{
                resp = http.send(req);
            }
            catch(Exception e){
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'updateEventAfterCallout' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        	}
            System.debug('resp -->'+resp);
            String resp1;
              
        }
    //When New CLient Not Accepted
    @future
        public static Void sendWhenNewClientNotAccepted(id NewClientid)
        {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://uat360.wcgt.in/gtuat_newui/Shortlisted.svc/Insert_crmpiplelinemaster_SF');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            Lead leads = [SELECT Id,FirstName,LastName,Client__c,Phone,Remark__c,Expertise__c ,Sector__c,Email ,Description FROM Lead WHERE id =:  NewClientid];
            String reqBody = '{"sFirstName": "'+leads.FirstName+'","sLastName": "'+leads.LastName+'","sClientId": "'+leads.Client__c+'","sMobileNo": "'+leads.Phone+'","sExperties": "'+leads.Expertise__c+'","sDesignation": "IT","sEmail":"'+leads.Email+'","sSector": "'+leads.Sector__c+'","sEnqDesc": "'+leads.Description+'","sRemarks": "IT"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp);
            String resp1;
              
        }
    //On Client Creation, record data will be pushed to WCGT - 28
    //On Lead Conversion, Client Record will be created and pushed to WCGT - 29
    @Future(callout=true)
        public static Void sendWhenClientCreation(id clientId)
        {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://uat360.wcgt.in/gtuat_newui/Shortlisted.svc/Insert_GM_CLIENTS_SF');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            Account acc = [SELECT Id,Name,CreatedById  FROM Account WHERE id =:  clientId];
            String reqBody = '{"P_CLIENT_MID": "CL00001","P_CLIENT_NAME": "'+acc.Name+'","P_CLIENT_ID": "'+acc.Id+'","P_CR_USER_ID": "'+acc.CreatedById+'"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp);
            String resp1;
            
        }
    //On Lead Conversion, Client Contact Record will be created and pushed to WCGT
    //On Client Contact Creation, record data will be pushed to WCGT.
        public static String sendWhenNewClienttoContact(id clientContactId)
        {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://uat360.wcgt.in/gtuat_newui/Shortlisted.svc/Insert_CLIENTADDR_SF');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            Contact con = [SELECT Id,Name,Email,Phone,MailingAddress,AccountId,Designation__c    FROM Contact WHERE id =:  clientContactId];
            String reqBody = '{"P_MOBILE_NO": "'+con.Phone+'","P_ADDRESS": "'+con.MailingAddress+'","P_CLIENT_ID": "'+con.AccountId+'","P_LOCATION_ID": "L00002","P_CONT_PERSON": "'+con.Name+'","P_DESIGN": "'+con.Designation__c+'","P_EMAIL_ID":"'+con.Email+'"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp);
            String resp1;
            return resp1;
        }
    //
        @Future(callout=true)
        public static Void sendWhenEnquiryCreated(id OpportunityId)
        {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://uat360.wcgt.in/GTSF/api/PipelineEnqiry/Insert');
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json'); 
            Opportunity opp = [SELECT Id, Name,Account.Phone,AccountId,OwnerId  FROM Opportunity WHERE id =: OpportunityId];
            String reqBody = '{'+
                '"P_PIP_ID": "'+opp.Id+'",'+
                '"P_NAME": "'+opp.Name+'",' +
                '"P_CLIENTID": "'+opp.Id+'",' +
                '"P_SERVICELINEID": "S00002",' +
                '"P_MARKETID": "M0001",' +
                '"P_CR_USERID": "'+opp.OwnerId+'",' +
                '"P_WONREASONDESCRIPTION" : "For Billing",' +
                '"P_COMPLETEFLAG":"1",' +
                '"P_PITCHSTATUS":"0"}';
            system.debug('reqBody'+reqBody);
            req.setBody(reqBody);
            HttpResponse resp = http.send(req);
            System.debug('resp -->'+resp);
            String resp1;
            
        }
    //@future (callout=true)
     // Changed by Suraj Kumar on 19th Jan 
   @InvocableMethod(label='Call BD Activity')
    public static void sendWhenBDActivity(List<Id> eventsId)
    {
        System.debug('Id :' + eventsId[0]);
        System.debug('Ids :' + eventsId);
        
        
        
        String attendees;
        String company;
        String leadId;
        Event events = [Select Id,End_Date_Time__c,WCGTStatus__c, Start_Date_Time__c, Actual_Attendees__c, Actual_Duration__c,WhoId,Type,OwnerId,Subject,AttendeesId__c FROM Event Where Id =: eventsId[0] Limit 1];
        List<EventRelation> listevRel = new List<EventRelation> ([SELECT Id, RelationId FROM EventRelation Where EventId =: eventsId[0] Limit 1]);
        User userRecord = [SELECT Id, USER_ID__c FROM User Where Id =: events.OwnerId Limit 1];
        for( EventRelation evRel : listevRel){
            Id userId = evRel.RelationId;
            
            
            try{
                Lead useratt = [Select Id, Name, Company From Lead Where Id =: events.WhoId Limit 1];
                
                company =  useratt.Company ;
                leadId = useratt.Id;
                
            }
            catch(Exception e){
                ErrorLogCreater_cls.apexDebugLogger(e, 'salesforceToWCGT' , 'sendWhenBDActivity' , eventsId[0]);
            }
            
        }
        
        Integer startYear = events.Start_Date_Time__c.year();
        Integer startMonth = events.Start_Date_Time__c.month();
        Integer startDay = events.Start_Date_Time__c.day();
        
       
        Integer endYear = events.End_Date_Time__c.year();
        Integer endMonth = events.End_Date_Time__c.month();
        Integer endDay = events.End_Date_Time__c.day();
        Integer hr = Integer.valueOf(events.Actual_Duration__c/60);
        Integer min =  math.mod(Integer.valueOf(events.Actual_Duration__c), 100);
        min = Integer.valueOf(events.Actual_Duration__c)-(hr*60);
        min = math.mod(min, 100);
        System.debug(min);        
        String reqBody = '{' +
            +'"sSubject": "'+events.Subject+'",'+
        '"sActivityType": "Client Meeting",'+
        '"sAttendees": "'+events.AttendeesId__c+'",'+
        '"sCompanyName": "'+company+'",'+
        '"sActivityDate": "'+startDay+'/'+startMonth+'/'+startYear+'",'+
        '"sCompletedDate": "'+endDay+'/'+endMonth+'/'+endYear+'",'+
        '"sDuration":"'+hr+'.'+min+'",'+
        '"sUserId": "'+events.OwnerId+'",'+
        '"sNewclient": "'+leadId+'",'+
        '"sMeetingId": "'+events.Id+'","sLeaderId": "'+userRecord.USER_ID__c+'"}';
        System.debug('reqBody'+reqBody);
        
        if(events.WCGTStatus__c != 'Success'){
            salesforceToWCGT.sendBDActivity(reqBody, events.Id);
        }
        else{
            system.debug('Already Updated');
        }
    }
    @Future(callout=true)
    public static void sendBDActivity(String reqBody, Id eventId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        WCGTEndPoint__mdt bdRecord = [SELECT Id, MasterLabel, URL__c FROM WCGTEndPoint__mdt Where Label = 'BD Activity' limit 1];
        req.setEndpoint(bdRecord.URL__c);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json'); 
        req.setTimeout(30000);
        req.setBody(reqBody);
        HttpResponse resp;
        try{
	             resp = http.send(req);
                System.debug('resp -->'+resp);
            salesforceToWCGT.updateEventAfterCallout(resp.getStatusCode(),eventId);
        }
        catch(Exception e){
            salesforceToWCGT.updateEventAfterCallout(400,eventId);
            ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'sendBDActivity' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
    }
    public Static void updateEventAfterCallout(Integer statusCode,Id eventId){
        try{
            Event eventRecord = [Select Id, WCGTStatus__c From Event Where Id =: eventId Limit 1];
            if(statusCode == 200){
                eventRecord.WCGTStatus__c = 'Success';
                
            }else{
                eventRecord.WCGTStatus__c = 'Error';
            }
            Update eventRecord;
        }
        catch(Exception e){
            //ErrorLogCreater_cls.apexDebugLoggerForAPICallout(e, 'salesforceToWCGT' , 'updateEventAfterCallout' , '' , reqBody,resp.getBody(), 'https://uat360.wcgt.in/GTSF/api/BDActivity/Insert' );
        }
    }
}