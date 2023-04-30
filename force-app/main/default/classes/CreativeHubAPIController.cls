public class CreativeHubAPIController {
    @InvocableMethod
    public static void invocable(List<Id> oppoIds){
        sendRequest(oppoIds);
    }
    @future(callout=true)
    public static void sendRequest(List<Id> oppoIds){
        String UserEmail = UserInfo.getUserEmail();
        
        List<IntegratedEnquiry__c > oppoList=[select Id, Type_of_content__c, Specify_details_of_content__c, Reason_for_request__c, Job_Code__c,
                                              Type_of_document__c, Level_of_support__c,ClientName__c, Legal_Entity__c, Lead_member_firm__c,
                                              Proposal_value__c,Support_required__c,CreatedBy.Name,Child_Enquiries__c,Attachment__C,
                                              (Select ContentDocumentId,contentdocument.title, ContentDocument.LatestPublishedVersionId  from contentdocumentlinks order by ContentDocument.LatestPublishedVersionId desc limit 1)content,
                                              
                                              Sector__c, Expertise__c from IntegratedEnquiry__c  where Id In:oppoIds];
        System.debug('oppoList====>'+oppoList);
        
        
        Creative_Hub__mdt apiMetaData = [select id,Client_id__c,Client_Secret__c,urlForDocBinding__C,End_Point_URL__c,Grant_Type__c,Scope__c,
                                         Token_End_Point_URL__c,DocURL__c from Creative_Hub__mdt where MasterLabel='Creative Hub Meta Data' limit 1];
        String requestBody ='client_id='+apiMetaData.Client_id__c+'&client_secret='+apiMetaData.Client_Secret__c
            +'&scope='+apiMetaData.Scope__c+'&grant_type='+apiMetaData.Grant_Type__c;
        
        HttpRequest postRequest = HttpUtility.getHttpRequest(apiMetaData.Token_End_Point_URL__c,'POST',null,null,requestBody,'application/x-www-form-urlencoded', null);
        HttpResponse postResponse = HttpUtility.makeCallout(postRequest);
        system.debug('Response Token'+postResponse.getBody());
        AccessTokenGenerator accessToken = (AccessTokenGenerator) JSON.deserialize(postResponse.getBody(),AccessTokenGenerator.class);
        
        String body = '{ "fields": { ' +
            '"UserEmail":"'+UserEmail+'",'+
            '"TypeOfDocument":"'+oppoList[0].Type_of_document__c+'",'+
            '"LevelOfSupport":"'+oppoList[0].Level_of_support__c+'",'+
            '"ClientName":"'+oppoList[0].ClientName__c+'",'+
            '"Sector":"'+oppoList[0].Sector__c+'",'+
            '"SubSector":"'+oppoList[0].Sector__c+'",'+
            '"DetailsOfSupport":"'+oppoList[0].Type_of_document__c+'",'+
            '"LegalEntity":"'+oppoList[0].Legal_Entity__c+'",'+
            '"LeadMemberFirm":"'+oppoList[0].Lead_member_firm__c+'",'+
            '"PipeLineID":"'+oppoList[0].Id+'",'+
            '"ProposalValue":"'+oppoList[0].Proposal_value__c+'",'+
            '"SupportRequired":"'+oppoList[0].Support_required__c+'",'+
            '"TypeOfContent":"'+oppoList[0].Type_of_content__c+'",'+
            '"DetailsOfContent":"'+oppoList[0].Specify_details_of_content__c+'",'+
            '"ReasonForRequest":"'+oppoList[0].Reason_for_request__c+'",'+
            '"TypeOfBranding":"'+oppoList[0].Type_of_document__c+'",'+
            '"RaiseBy":"LinKreta",'+
            '"RequestorName":"'+oppoList[0].CreatedBy.Name+'",'+
            '"JobCode":"13-11-GTBL001-002-NCA-NR-2021-00001",'+
            '"ChildPipelineIds":"'+oppoList[0].Child_Enquiries__c+'"'+
            '        }' +
            '}';
        String bearerAccessToken='Bearer '+accessToken.access_token;
        
        HttpRequest apiRequest = HttpUtility.getHttpRequest(apiMetaData.End_Point_URL__c,'POST','accept','*/*',body,'application/json', null);
        apiRequest.setHeader('Authorization', bearerAccessToken);
        HttpResponse apiResponse = HttpUtility.makeCallout(apiRequest);
        System.debug('Status code'+apiResponse.getStatusCode());
        System.debug('APi Response'+apiResponse.getBody());
        CreativeHubAPIController.wrapperClass wrapObj = (CreativeHubAPIController.wrapperClass)JSON.deserialize(apiResponse.getBody(), CreativeHubAPIController.wrapperClass.class);
        System.debug('wrapObj :'+wrapObj);
        
        
        if(wrapObj != null && apiResponse.getStatusCode()==201 && oppoList[0].Attachment__C==true){
            ContentVersion cntv =[SELECT Id,Title,ContentDocumentId,versiondata,IsLatest FROM ContentVersion WHERE IsLatest=true and ContentDocumentId =:oppoList[0].ContentDocumentLinks[0].ContentDocumentId LIMIT 1]; 
            system.debug('Title'+cntv.Title);
            string str='';
            str+=Datetime.now();
            
            string str2=str.replace(' ','');
            String str3=str2.replace('-','');
            String str4=str3.replace(':','');
            system.debug('str'+str);
            String url=apiMetaData.DocURL__c+cntv.Title+str4;
            String url1=url+'.pdf:/content';
            String url2=url+'.pdf:/listItem/fields';
            system.debug('url'+url);
            
            string contentData =EncodingUtil.base64Encode(cntv.VersionData);
            system.debug('bearerAccessToken'+bearerAccessToken);
            HttpRequest apiRequestdoc = HttpUtility.getHttpRequest(url1,'PUT','accept','*/*',contentData,'application/json', null);
            apiRequestdoc.setHeader('Authorization', bearerAccessToken);
            HttpResponse apiResponsedoc = HttpUtility.makeCallout(apiRequestdoc);
            System.debug('Status code'+apiResponsedoc.getStatusCode());
            System.debug('APi Response'+apiResponsedoc.getBody());
           
             if(apiResponsedoc.getStatusCode()==200){
            String bodyrequestId='{ ' +
                '"RequestID":"'+wrapObj.id+'"}';
                
            HttpRequest apiRequestdocAttached = HttpUtility.getHttpRequest(url2,'PATCH','accept','*/*',bodyrequestId,'application/json', null);
            apiRequestdocAttached.setHeader('Authorization', bearerAccessToken);
            HttpResponse apiResponsedocAttached = HttpUtility.makeCallout(apiRequestdocAttached);
            System.debug('Status code'+apiResponsedocAttached.getStatusCode());
            System.debug('APi Response'+apiResponsedocAttached.getBody());
             updateCreativeIdAndStatus(wrapObj);
             }}
    
       
        
    }
    public static void updateCreativeIdAndStatus(wrapperClass obj){
        IntegratedEnquiry__c intGraObj = [SELECT Id,Creative_Hub_Id__c,Type_of_document__C,Proposal_Status__c,Pitch_Presentation_Status__C,Creative_Hub_Status__c FROM IntegratedEnquiry__c WHERE Id =: obj.fields.PipeLineID];
        if(intGraObj.Type_of_document__C=='Pitch Presentation'){
           
           intGraObj.Pitch_Presentation_Status__C=obj.fields.RequestStatus;
        }else{
             intGraObj.Proposal_Status__c=obj.fields.RequestStatus;
        }
        intGraObj.Creative_Hub_Id__c = obj.Id;
        intGraObj.Creative_Hub_Status__c = obj.fields.RequestStatus;
        intGraObj.Attachment__C=false;
        update intGraObj;
    }
      

    @future(callout=true)
    public static void uploadeDocumentToCreativeHub(id contentVersionId){
        
        ContentVersion cntv =[SELECT Id,Title,ContentDocumentId,versiondata,IsLatest FROM ContentVersion WHERE IsLatest=true and ContentDocumentId =:contentVersionId LIMIT 1]; 
        string contentData =EncodingUtil.base64Encode(cntv.VersionData);
        system.debug('cntv'+contentData);
        
        Creative_Hub__mdt apiMetaData = [select id,Client_id__c,Client_Secret__c,End_Point_URL__c,Grant_Type__c,Scope__c,
                                         Token_End_Point_URL__c,DocURL__c from Creative_Hub__mdt where MasterLabel='Creative Hub Meta Data' limit 1];
        String requestBody ='client_id='+apiMetaData.Client_id__c+'&client_secret='+apiMetaData.Client_Secret__c
            +'&scope='+apiMetaData.Scope__c+'&grant_type='+apiMetaData.Grant_Type__c;
        HttpRequest apiRequest = HttpUtility.getHttpRequest(apiMetaData.DocURL__c,'PUT','accept','*/*',contentData,'application/json', null);
        HttpRequest postRequest = HttpUtility.getHttpRequest(apiMetaData.Token_End_Point_URL__c,'POST',null,null,requestBody,'application/x-www-form-urlencoded', null);
        HttpResponse postResponse = HttpUtility.makeCallout(postRequest);
        system.debug('Response Token'+postResponse.getBody());
        AccessTokenGenerator accessToken = (AccessTokenGenerator) JSON.deserialize(postResponse.getBody(),AccessTokenGenerator.class);
         String bearerAccessToken='Bearer '+accessToken.access_token;
        apiRequest.setHeader('Authorization', bearerAccessToken);
        HttpResponse apiResponse = HttpUtility.makeCallout(apiRequest);
        System.debug('Status code'+apiResponse.getStatusCode());
        System.debug('APi Response'+apiResponse.getBody());
        
        
        
        
    }
    public class AccessTokenGenerator{
        public String token_type;	
        public Integer expires_in;
        public Integer ext_expires_in;	
        public String access_token;
    }
    public class wrapperClass{
        public string id;
        public Fields fields;
    }
    public class Fields{
        public string id;
        public string RequestStatus;
        public string ReasonForRequest;
        public string TypeOfBranding;
        public string LevelOfSupport;
        public string PipeLineID;
        public string ClientName;
        public string DetailsOfSupport;
        public string Sector;
        public string SubSector;
        
    }
}