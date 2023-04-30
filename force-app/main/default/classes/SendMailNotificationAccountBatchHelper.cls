/*
 * Author : Suraj Kumar
 * Date : 21-12-2022
 * Description : Helper class of SendMailNotificationAccountBatch
*/

public class SendMailNotificationAccountBatchHelper {
    public static String getQuery(){
        String query = 'SELECT Id, Name, AccountType__c FROM Account WHERE AccountType__c = \'Non Key Client\' ';
        return query;
    }
}