public class EventScreenController {
    @InvocableMethod
    public static List<Event> getMeetings(List<event> eventsList){
        List<Event> eventListToSendToFlow = new List<Event>();
        
        //List<Event> eventsList = [select id, whoId, (select id, relationId,isInvitee from eventrelations where isInvitee=true) from event where whoId=: recordIds[0] ];
        
        for(Event ev : eventsList){
            if(!ev.eventrelations.isEmpty()){
                System.debug('evRelations : ' + ev.eventrelations);
                eventListToSendToFlow.add(ev);
            }
        }
        System.debug('eventListToSendToFlow : ' + eventListToSendToFlow);
        return eventListToSendToFlow;
        
    }
    
}