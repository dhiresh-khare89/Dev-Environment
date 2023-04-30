public class ProposedAccountOwnerController {
@InvocableMethod
    public static void updateOwnerChangeFields(List<Id> recordIdList){
        Account acc= new Account();
        acc.id = recordIdList[0];
        
    }
}