public class createClientContact {
    @future(callout=true)
    public static void createContactFromCAPIQBOD(Id clientId ,String companyID)
    {
        System.debug('Client Contact BOD');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        String username = 'apiadmin@in.gt.com';
        String password = 'GTBharat@123'; 
        Blob headerValue = Blob.valueOf  (username + ':' + password);
 
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        System.debug('companyID ===>' + companyID );
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}},'+
            '{"function":"GDSHE","mnemonic":"IQ_BOARD_MEMBER_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}}'+']}';
        
        req.setBody(reqBody);
        System.debug(clientId);
        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        System.debug(respoApex);
        List<Contact> conlist = new List<Contact>();
        try{
            for(Integer i=0;i<30 ;i++)
            {
                String Name= respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                Contact oldCon = [Select Name,AccountId,RecordTypeId ,Title,Email,Phone From Contact Where Name = : Name Limit 1];
                if(oldCon.Name == Name)
                {
                    if(oldCon.Title == '')
                    {
                        oldCon.Title = respoApex.GDSSDKResponse[3].Rows[i].Row[0];
                    }
                    if(oldCon.Email == 'data@unavilable.com')
                    {
                        oldCon.Email= 'data@unavilable.com';
                    }else if(oldCon.Email == ''){
                        oldCon.Email= 'data@unavilable.com';
                    }
                    if(oldCon.Phone == ''){
                        oldCon.Phone = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    }
                    update oldCon;
                }
                else{
                    Contact con = new Contact ();
                    con.LastName = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    con.AccountId = clientId;
                    con.RecordTypeId= '0126D000002mLYIQA2';
                    con.Title = respoApex.GDSSDKResponse[3].Rows[i].Row[0];
                    if(respoApex.GDSSDKResponse[2].Rows[i].Row[0] == 'Data Unavailable')
                    {
                        con.Email= 'data@unavilable.com';
                    }
                    else
                    {
                        con.Email = respoApex.GDSSDKResponse[2].Rows[i].Row[0];
                    }
                    con.Phone = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    conlist.add(con);
                }
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        insert conlist;
    }
    @future(callout=true)
    public static void createContactFromCAPIQProfessional(Id clientId ,String companyID)
    {
        System.debug('Client Contact Proffesional');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ciq.marketintelligence.spglobal.com/gdsapi/rest/v3/clientservice.json');
        req.setMethod('POST');
        String username = 'apiadmin@in.gt.com';
        String password = 'GTBharat@123'; 
        Blob headerValue = Blob.valueOf  (username + ':' + password);
 
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type','application/json');
        System.debug('companyID ===>' + companyID );
        String reqBody = '{"inputRequests": [{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_MAIN_PHONE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_EMAIL","identifier":"'+companyID+'","properties": { "startRank":"1","endRank":"30"}},'+
        '{"function":"GDSHE","mnemonic":"IQ_PROFESSIONAL_TITLE","identifier":"'+companyID+'","properties": {"startRank":"1","endRank":"30"}}'+
        ']}';
        
        req.setBody(reqBody);

        HttpResponse resp = http.send(req); 
        clientNewIqWrapper respoApex=(clientNewIqWrapper) System.JSON.deserialize(resp.getBody(), clientNewIqWrapper.class);
        System.debug(respoApex);
        List<Contact> conlist = new List<Contact>();
        try{
            for(Integer i=0;i<5 ;i++)
            {
                String Name= respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                Contact oldCon = [Select Name,AccountId,RecordTypeId ,Title,Email,Phone From Contact Where Name = : Name Limit 1];
                
                if(oldCon.Name == Name)
                {
                    if(oldCon.Title == '')
                    {
                        oldCon.Title = respoApex.GDSSDKResponse[3].Rows[i].Row[0];
                    }
                    if(oldCon.Email == 'data@unavilable.com')
                    {
                        oldCon.Email= 'data@unavilable.com';
                    }else if(oldCon.Email == ''){
                        oldCon.Email= 'data@unavilable.com';
                    }
                    if(oldCon.Phone == ''){
                        oldCon.Phone = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    }
                    update oldCon;
                }
                else{
                    Contact con = new Contact ();
                    con.LastName = respoApex.GDSSDKResponse[0].Rows[i].Row[0];
                    con.AccountId = clientId;
                    con.RecordTypeId= '0126D000002mLYIQA2';
                    con.Title = respoApex.GDSSDKResponse[3].Rows[i].Row[0];
                    if(respoApex.GDSSDKResponse[2].Rows[i].Row[0] == 'Data Unavailable')
                    {
                        con.Email= 'data@unavilable.com';
                    }
                    else
                    {
                        con.Email = respoApex.GDSSDKResponse[2].Rows[i].Row[0];
                    }
                    con.Phone = respoApex.GDSSDKResponse[1].Rows[i].Row[0];
                    conlist.add(con);
                }
            }
        }
        catch(Exception e){
   			System.debug('List exception fired');         
        }
        insert conlist;
    }
}