/**
 * @descrpiton:
 * @author:
 * @group:
 * @last Modified By:
 * @last Modified On:
 */
@RestResource(urlMapping='/github/webhook/v1/*')
global with sharing class WebhookListener {
    /**
     * webhook secret - githubToSalesforce
     */

    @HttpPost
    global static void handleNotification() {
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;

        String hashValue = request.headers.get('X-Hub-Signature-256');
        System.debug(System.LoggingLevel.DEBUG, 'hashValue ' + hashValue);

        Blob body = request.requestBody;
        System.debug(System.LoggingLevel.DEBUG, body.toString());

        Blob hmac = Crypto.generateMac('hmacSHA256', body, Blob.valueOf('githubToSalesforce'));
        System.debug(System.LoggingLevel.DEBUG, 'hmac ' + EncodingUtil.convertToHex(hmac));

        String hmacString = 'sha256='+EncodingUtil.convertToHex(hmac);
        if(hashValue == hmacString) {
            System.debug(System.LoggingLevel.DEBUG, 'Secter value matched and source can be trusted');

            Pusher ps;
        Head_commit hc;
        JSONParser parser = JSON.createParser(request.requestBody.toString());
        while(parser.nextToken() != null) {
            if(parser.getText() == 'pusher') {
                parser.nextToken();
                ps = (Pusher)parser.readValueAs(Pusher.class);
                System.debug(System.LoggingLevel.DEBUG, 'ps ' + ps);
            }

            if(parser.getText() == 'head_commit') {
                parser.nextToken();
                hc = (Head_commit)parser.readValueAs(Head_commit.class);
                System.debug(System.LoggingLevel.DEBUG, 'hc ' + hc);
            }
        }

        response.statusCode = 200;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize(new WebhookResponse('Success', 'Processed Successfully')));
        } else {
            response.statusCode = 401;
            response.addHeader('Content-Type', 'application/json');
            response.responseBody = Blob.valueOf(JSON.serialize(new WebhookResponse('Failure', 'Not a valid sender')));
        }
    }

    public class WebhookResponse {
        public String status;
        public String message;

        public WebhookResponse(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }

    public class Pusher {
        public String name;
        public String email;
    }

    public class Head_commit {
        public String id;
        public String tree_id;
        public String message;
        public String timestamp;
        public String url;
        public author author;
    }

    public class author {
        public String name;
        public String email;
        public String username;
    }
}