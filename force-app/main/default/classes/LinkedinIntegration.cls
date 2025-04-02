public class LinkedinIntegration {
    
    public static void postToLinkedin(String message){
        String loginId = loginToLinkedin();
        postMessage(loginId, message);
        
    }
    
    public static String loginToLinkedin(){
        Http http = new Http();
        Httprequest req = new Httprequest();
        req.setMethod('GET');
        req.setEndpoint('callout:Linkedin/v2/userinfo');
        
        Httpresponse res = http.send(req);
             // System.debug('response '+ res.getBody());
        
               //System.debug('response '+ res.getStatusCode());
        
        try{
            if(res.getStatusCode() == 200){
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                
                String email = (String) results.get('sub');
                System.debug(email);
                return email;
            }else{
                return 'Test';
            }
        }catch(Exception ex){
            System.debug('Error while fetching user detial or error at authentication');
            return ex.getMessage();
        }

        
    }
    public static void postMessage(String id, String postMessage){
        Http http = new Http();
        String authorId = 'urn:li:person:'+id; 
        Httprequest request = new Httprequest();
        request.setMethod('POST');
        request.setEndpoint('callout:Linkedin/v2/ugcPosts');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Linkedin-Version', '202411');
        
       /* String postBody = 
            '{'+
            'author: '+authorId+', '+
            'lifecycleState: PUBLISHED, ' +
            'specificContent: { '+
            '"com.linkedin.ugc.ShareContent": { '+
            '   "shareCommentary": {'+
            '			"text": "'+postMessage+'"'+
            '		}, ' +
            '     "shareMediaCategory": "NONE" '+
            '}'+
            '},'+
            '    "visibility": {'+
            '"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC" '+
            '}'+
            '}';
*/
        String postBody = '{' +
            '"author": "'+authorId+'", '+
            '"lifecycleState": "PUBLISHED",' +
            '"specificContent": {' +
            '"com.linkedin.ugc.ShareContent": {' +
            '"shareCommentary": {' +
            '"text": "'+postMessage+'"'+
            '},' +
            '"shareMediaCategory": "NONE"' +
            '}' +
            '},' +
            '"visibility": {' +
            '"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"' +
            '}' +
            '}';
        
        
        request.setBody(postBody);
        Httpresponse response = http.send(request);
        System.debug('response: '+ response.getBody());
        System.debug(response.getStatusCode());
        
        
    }
}