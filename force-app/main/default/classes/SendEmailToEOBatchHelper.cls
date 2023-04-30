/*
* Author :Gaurav Kumar 
* Batch Class :SendEmailToEOBatch
* Date :26/12/2022
*/
public class SendEmailToEOBatchHelper {
    public static String getQuery(){
        String query = 'Select Id,Owner.Email,Calculate_Days_On_Nurture_Stage__c,Nurture_Finalizing_Closure_Date__c,Name '+ 
            'from Opportunity '+ 'where StageName =\'Closed Won\' AND Nurture_Finalizing_Closure_Date__c!=null ';
        
        if(String.isNotBlank(query)){
            return query;
        }
        else{
            return query;
        }
    }
}