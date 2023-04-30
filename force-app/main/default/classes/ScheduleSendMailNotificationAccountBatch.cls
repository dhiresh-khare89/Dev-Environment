/*
 * Author : Suraj Kumar
 * Date : 05-01-2023
 * Description : Scheduled class for SendMailNotificationAccountBatch
*/

global class ScheduleSendMailNotificationAccountBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SendMailNotificationAccountBatch());
    }
}