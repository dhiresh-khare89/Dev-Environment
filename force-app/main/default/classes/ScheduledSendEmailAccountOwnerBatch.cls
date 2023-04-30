/*
 * Author : Gaurav Kumar
 * Date : 22/12/2022
 * Description : Scheduled class for SendMailEnquiryBatch
*/

global class ScheduledSendEmailAccountOwnerBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SendEmailAccountOwnerBatch());
    }
}