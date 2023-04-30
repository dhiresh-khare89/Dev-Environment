/**
* @Author     : Ankita Pathak 
* @created on : 25-11-2022
**/
global class SendEmailOnValidateStageBatchSchedular implements Schedulable{
    global void execute(SchedulableContext sc) {
        SendEmailToEOOnValidateStageBatch batchObj = new SendEmailToEOOnValidateStageBatch(); 
        Database.executeBatch(batchObj);
    }
}