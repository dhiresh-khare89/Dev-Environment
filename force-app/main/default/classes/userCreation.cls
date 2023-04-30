@RestResource(urlMapping='/CreateUserAtLinkreta/*')
global class userCreation{
    @HTTPPOST
    global static string createUser(){
        RestRequest req = RestContext.request;
        blob body = req.requestBody;
        string RequestString = body.toString();
        JsonForUserCreation data = parse(RequestString);
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        //TODO: Customize the username. Also check that the username doesn't already exist and
        //possibly ensure there are enough org licenses to create a user. Must be 80 characters
        //or less.
        u.username = data.username + '@myorg.com';
        
        
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.username;
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        return 'Success';
    }
    public static JsonForUserCreation parse(String json) {
        return (JsonForUserCreation)System.JSON.deserialize(json, JsonForUserCreation.class);
    }
    public class JsonForUserCreation {
        public String Email;  
        public string FirstName;
        public String LastName;  
        public string username;
        public string EMP_Tier;
        public string EMP_NAME;
        public string EMP_LNAME;
        public string EMP_MNAME;
        public string EMP_FNAME;
        public string Joining_Date;
        public string Resignation_LWD;
        public String Employee_Status;
        public String Internal_Service_Unit;
        public String COMMON_USER;
        public String Service_Line;
        public String Location;
        public String IS_USER_LOCK;
        public String EMPLOYEECATEGORYID;
        public String AD_USERNAME;
        public String MOBILE_ACCESS;
        public String CR_USER_ID;
        public String CR_DATE;
        public String UP_USER_ID;
        public String UP_DATE;
        public String DEL_USER_ID;
        public String DEL_DATE;
        public String IS_DELETED;
        public String USER_DESG;
        public String EMP_ID;
        public String USER_NAME;
        public String USER_ID;
        public String GRP_COMP_ID;        
    }
}