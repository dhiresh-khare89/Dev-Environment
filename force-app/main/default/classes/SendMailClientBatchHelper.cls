public class SendMailClientBatchHelper {
public static String getQuery(){
        String query = 'SELECT Id, DS_Team_Verification_date__c, Owner.Email, Owner.Name FROM Account WHERE DS_Team_Verification_date__c < LAST_N_MONTHS : 6';
        if(String.isNotBlank(query)){
            return query;
        }
        else{
            return null;
        }
    }
}