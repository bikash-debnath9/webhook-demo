/**
 * @descrpiton:
 * @author:
 * @group:
 * @last Modified By:
 * @last Modified On:
 */
@RestResource(urlMapping='/github/webhook/v1/*')
global with sharing class WebhookListener {
    @HttpPost
    global static void handleNotification() {
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;

        Blob body = request.requestBody;
        System.debug(System.LoggingLevel.DEBUG, body.toString());

        /*
        String responseStr = RestContext.request.requestBody.toString();
        RestResponse response = RestContext.response;
        response.statusCode = 200;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf('{"success":true, event:"UNKNOWN"}');
        */

        JSONParser parser = JSON.createParser(request.requestBody.toString());
        while(parser.nextToken() != null) {
            System.debug('nextToken = ' + parser.nextToken());
        }


    }

    @HttpGet
    global static String doGet() {
        return '{"message":"Hello from stripe webhook v1"}';
    }
}