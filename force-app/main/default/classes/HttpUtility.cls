public class HttpUtility {
public static HttpRequest getHttpRequest(String endpoint, String method, String otherHeaderKey, String otherHeaderValue, String requestBody, String contentType, Blob requestBodyBlob) {
    System.debug('content type'+contentType);
    System.debug('requestBody'+requestBody);
    System.debug('requestBodyBlob'+requestBodyBlob);
    HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod(method);
        httpRequest.setEndpoint(endpoint);
        if (requestBody != null) {
            httpRequest.setBody(requestBody);
        }
        if (contentType != null) {
            httpRequest.setHeader('Content-Type',contentType);
        }
        if (otherHeaderKey != null && otherHeaderValue != null) {
            httpRequest.setHeader(otherHeaderKey,otherHeaderValue );
        }
        if (requestBodyBlob != null) {
            httpRequest.setBodyAsBlob(requestBodyBlob);
        }
    
        
       // httpRequest.setTimeout(120000);
        return httpRequest;
    }
    public static HttpResponse makeCallout(HttpRequest request) {
        try {
            Http http = new Http();
            System.debug(request);
            HttpResponse response = http.send(request);
            return response;
        } catch (CalloutException exp) {
            System.debug(' Exception Message ::' + exp.getMessage() + ' Class Name : HttpUtility at Line ::' + exp.getLineNumber());
        }
        return null;
    }
}