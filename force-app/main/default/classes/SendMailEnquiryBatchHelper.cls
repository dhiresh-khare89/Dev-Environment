/*
 * Author : Suraj Kumar
 * Date : 12-12-2022
 * Description : Helper class of SendMailEnquiryBatch
*/

public class SendMailEnquiryBatchHelper {
    public static String getQuery(){
        String query = 'SELECT Id, DS_Team_Verification_date__c, Owner.Email, Owner.Name FROM Opportunity WHERE DS_Team_Verification_date__c < LAST_N_MONTHS : 6';
        if(String.isNotBlank(query)){
            return query;
        }
        else{
            return null;
        }
    }
}