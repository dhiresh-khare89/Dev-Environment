public class ShowError {
    @InvocableMethod
    public static void addErrorFlow(List<Id> leadId){
        System.debug('Add Error Flow');
        for(Lead ld:[select Id, Status from Lead where Id in: leadId]){
            ld.Status.addError('Please add Meeting to move on to next tab');
        }
        
    }
}