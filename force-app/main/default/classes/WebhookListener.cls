/**
 * @descrpiton:
 * @author:
 * @group:
 * @last Modified By:
 * @last Modified On:
 */
@RestResource(urlMapping='/stripe/webhook/v1/*')
global with sharing class WebhookListener {
    @HttpPost
    global static void doPost() {
        //RestContext.response
        //RestContext.request
        String responseStr = RestContext.request.requestBody.toString();
        RestResponse response = RestContext.response;
        response.statusCode = 200;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf('{"success":true, event:"UNKNOWN"}');
    }

    @HttpGet
    global static String doGet() {
        return '{"message":"Hello from stripe webhook v1"}';
    }
}