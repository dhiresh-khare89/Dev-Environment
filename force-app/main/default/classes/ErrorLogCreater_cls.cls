/* 
     Written By: Bhanwar Singh
     Created Date: 15-03-23
     Last Modified By : 
     Last Modified Date : 15-03-23
     Description : This class is used to create the Error Log For all the Exception occurred in the System.
     Variable Used : - 
      debugMessages : - List of Messages Recieved From Flow 
      className :- Apex Class Name in which exception occurred 
      methodName : - Apex Method/ Function Name in which exception occurred
      recordReference : - Record Id on which error has occurred
      requestBody : - Request Body sent from apex class
      responseBody : - Response recived by API callout
      endPointURL : - API callout url
*/
public class ErrorLogCreater_cls {
    // This Method is used for Exception occurred in Flow
    
    @InvocableMethod(label='Log Debug Message' description='Outputs messages to the debug log')
    public static void flowDebugLogger (List<String> debugMessages) {
        try{
            List<ErrorLog__c> errorList = new List<ErrorLog__c>();
            for(String message : debugMessages){
                ErrorLog__c err = new ErrorLog__c();
                err.ExceptionMessage__c = message;
                err.ErrorAPI__c = true;
                errorList.add(err);
            }
            
            System.debug('Limits  ');
            insert errorList;
        }
        Catch(Exception e){
            ErrorLogCreater_cls.apexDebugLogger(e, 'ErrorLog' , 'flowDebugLogger' , '' );
            
        }
    }
    // This Method is used for all exception occurred in Apex Class except Apex class having API callout
    public static void apexDebugLogger(Exception e, String className , String methodName , String recordReference ){
        try{
            ErrorLog__c err = new ErrorLog__c();
            err.NameofArtifact__c = className;
            err.ExceptionMessage__c = e.getMessage();
            err.ExceptionType__c = e.getTypeName();
            err.MethodName__c = methodName;
            err.SFDCRecordReference__c = recordReference;
            err.ErrorAPI__c = true;
            insert err;
        }
        Catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLogger(ex, 'ErrorLog' , 'apexDebugLogger' , '' );
        }
    }
    // This Method is used for all exception occurred in Apex Class with API callout
    
    public static void apexDebugLoggerForAPICallout(Exception e, String className , String methodName , String recordReference , String requestBody , String responseBody, String endPointURL){
        try{
            ErrorLog__c err = new ErrorLog__c();
            err.NameofArtifact__c = className;
            err.ExceptionMessage__c = e.getMessage();
            err.ExceptionType__c = e.getTypeName();
            err.MethodName__c = methodName;
            err.SFDCRecordReference__c = recordReference;
            if(requestBody.length() > 131072){
                requestBody = requestBody.substring(0, 131070);
            }
            if(responseBody.length() > 131072){
                responseBody = responseBody.substring(0, 131070);
            }
            err.RequestBody__c = requestBody;
            err.Response_Body__c = responseBody;
            err.URL__c = endPointURL;
            err.ErrorAPI__c = false;
            insert err;
        }
        Catch(Exception ex){
            ErrorLogCreater_cls.apexDebugLogger(ex, 'ErrorLog' , 'apexDebugLoggerForAPICallout' , '' );
        }
    }
}