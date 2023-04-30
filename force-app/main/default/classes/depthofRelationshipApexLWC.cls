public class depthofRelationshipApexLWC {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getClientContact()
    {
        List<Contact> listContact = new List<Contact> ([SELECT Id,Name From Contact]);
        return listContact;
    }
}