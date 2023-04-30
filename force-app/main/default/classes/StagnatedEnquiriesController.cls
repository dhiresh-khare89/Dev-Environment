/*
 * Author : Suraj Kumar
 * Date : 27-12-2022
 * Description : Helper class of ReminderAccountPlanBatch
*/
public class StagnatedEnquiriesController {
    
    @AuraEnabled(Cacheable=True)
    public static List<Opportunity> getEnquiries(String Id){
        
        Opportunity opp = [SELECT Id, Name, StageName, Amount, Expertise__c, OwnerId, Recovery__c, CloseDate FROM Opportunity WHERE Id =: Id];
        Decimal lowerAmount = opp.Amount - (opp.Amount * 0.1);
        Decimal higherAmount = opp.Amount + (opp.Amount * 0.1);
        SYstem.debug('lowerAmount : ' + lowerAmount + ' and higherAmount : ' + higherAmount);
        List<Opportunity> oppList = [SELECT Id, Name, StageName, Amount, Expertise__c, Owner.Name, Recovery__c, CloseDate FROM Opportunity WHERE Amount >: lowerAmount AND Amount <: higherAmount AND StageName='Closed Won'];
        System.debug('oppList : ' + oppList);
        return oppList;
        
    }
}