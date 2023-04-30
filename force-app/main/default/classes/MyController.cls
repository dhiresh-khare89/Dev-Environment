public class MyController {
    public boolean msgReturn {get;set;}
    public void controller(){
        
        String UserId = UserInfo.getUserId();
        List<LoginHistory> userHistoryData = [SELECT Id, UserId, LoginTime, Platform, LoginType FROM 
                                              LoginHistory WHERE UserId=:UserId ORDER By LoginTime DESC];
        //System.debug('userHistory :'+userHistoryData);
        
        if(userHistoryData[0].Platform.contains('Windows') || userHistoryData[0].Platform.contains('Linux')){
            msgReturn = true;
            
        }
    }
}