/*
* Author : Gaurav Kumar
* Date : 26/12/2022
* Description : Scheduled class for SendEmailToEOBatch
*/

global class ScheduledSendEmailToEOBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new SendEmailToEOBatch());
    }
}