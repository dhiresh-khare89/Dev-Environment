/*
 * Author : Suraj Kumar
 * Date : 21-12-2022
 * Description : Helper class of ReminderAccountPlanBatch
*/

public class ReminderAccountPlanBatchHelper {
    public static String getQuery(){
        String query = 'SELECT Id, Name, Account_Plan_Status__c, AccountType__c, CSL__r.Email, CoCSL__r.Email, NSL__r.Email, CreatedDate  FROM Account WHERE (Account_Plan_Status__c = \'Draft\' OR Account_Plan_Status__c = \'Pending NSL Approval\') AND (AccountType__c = \'Key Account - CX\' OR AccountType__c = \'Key Account - GX\' )';
        return query;
    }
}