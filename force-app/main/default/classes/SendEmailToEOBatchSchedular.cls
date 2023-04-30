global class SendEmailToEOBatchSchedular implements Schedulable {
   global void execute(SchedulableContext sc) {
      SendEmailToEOBatch batchObj = new SendEmailToEOBatch(); 
      Database.executeBatch(batchObj);
   }
}