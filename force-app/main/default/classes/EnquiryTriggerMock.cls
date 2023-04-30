@isTest
public class EnquiryTriggerMock implements HttpCalloutMock{
    
    public HTTPResponse respond(HTTPRequest req) { 
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        res.setHeader('api-key', 'A30f94cd9321905aff9822f773349c113');
        String body = '{ ' +
            '"P_FLAG":"C",'+
            '"P_PREFIX":"Mr.",'+
            '"P_FIRSTNAME":"TestFirstName"'+
            '"P_MIDDLENAME":"null",'+
            '"P_LASTNAME":"Mourya",'+
            '"P_EMAIL":"aveshawasthi@gmail.com",'+
            '"P_MOBILENO":"9958126363",'+
            '"P_Pitchdescription":"GTB Test",'+
            '"P_Clientid":"GTBLLP",'+
            '"P_REMARKS":"Test Enquiry10",'+
            '"P_SECTOR":"ET000011",'+
            '"P_Service_Line":"ES000004",'+
            '"P_Urgency":"No",'+
            '"P_Designation":"Manager",'+
            '"p_enquiry_id":"null",'+
            '"P_USER_UP":"",'+
            '"P_USER_CR":"US000001"'+
            '}';       
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}