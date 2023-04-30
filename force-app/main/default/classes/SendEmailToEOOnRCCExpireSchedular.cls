global class SendEmailToEOOnRCCExpireSchedular implements Schedulable{
    global void execute(SchedulableContext Sc){
        SendEmailToEOOnRCCExpire batchObj = new SendEmailToEOOnRCCExpire();
        Database.executeBatch(batchObj);
    }

}