/*
 * Author : Suraj Kumar
 * Date : 12-12-2022
 * Description : Scheduled class for ReminderAccountPlanBatch
*/

global class ScheduleReminderAccountPlanBatch implements Schedulable {
    global void execute(SchedulableContext sc){
        Database.executeBatch(new ReminderAccountPlanBatch());
    }
}