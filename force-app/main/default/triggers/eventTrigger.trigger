trigger eventTrigger on Event (after insert, after Update) {
        for(Event EventObj: Trigger.new){
            String Events = JSON.serialize(EventObj.Id);
            System.debug('Events Id '+EventObj.Id);
            //salesforceToWCGT.sendWhenBDActivity(Events);
            
        }
}