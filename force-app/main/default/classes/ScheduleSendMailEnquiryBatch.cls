/*
 * Author : Suraj Kumar
 * Date : 12-12-2022
 * Description : Scheduled class for SendMailEnquiryBatch
*/

global class ScheduleSendMailEnquiryBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SendMailEnquiryBatch());
    }
}