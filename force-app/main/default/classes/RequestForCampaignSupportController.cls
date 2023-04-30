public class RequestForCampaignSupportController {
    public static void sendEmailToMarcomTeam(){
        
        Set<Id> ids = new Set<Id>();
        List<GroupMember> members = [select id, GroupId,UserOrGroupId from GroupMember  where group.developerName = 'Marcom_Team'];
        for(GroupMember grp : members){
            ids.add(grp.UserOrGroupId);
        }
        
        List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
        
        for(User u : [SELECT Id, Email FROM User WHERE Id IN : ids ]){
            System.debug('Usre email : ' + u.Email);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] {u.Email});
            email.setSubject('Request for Campaign support');
            String body = 'Hi Team <br> <br>';
            body += 'Congrats! a new Client is emerged into the system and now you are required to create an Account Plan for the Client ';
            body += 'Once created, Please schedule a discussion with NSL to discuss on Account Plan. <br> <br>';
            body += 'Regards <br> GT Team </br>';
            email.setHtmlBody(body);
            mailsList.add(email);
        }
        
        if(!mailsList.isEmpty()){              
            Messaging.sendEmail(mailsList);
        }
        else{
            System.debug('Mail List is empty');
        }
        
        
    }
}