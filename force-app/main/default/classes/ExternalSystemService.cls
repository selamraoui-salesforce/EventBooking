public with sharing class ExternalSystemService {

    private String webServiceURL;

    public ExternalSystemService(){
        this.webServiceURL = ('callout:animals_JSON?format=json');
    }

    public void registerAttendees(List<Contact> closedRequestsAttendees){
        List<Contact> contactsToEmail = new List<Contact>();
        for(Contact contact : closedRequestsAttendees){
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint(this.webServiceURL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody('{"name":"'+ contact.Name + '-' + contact.Email  +'}');

            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +
                    response.getStatusCode() + ' ' + response.getStatus());
            } else {
                // Everything went as expected.
                contactsToEmail.add(contact);
            }
        }
        EmailService.sendReservationConfirmationEmailsToAttendees(contactsToEmail);
    } 


    public void notifyAttendeeByEmail(Contact contact){
      
        Task tk = new Task();
        tk.Subject = 'Send Email To' + contact.Name;
        tk.Status = 'Open';
        tk.Priority = 'Normal';
        tk.WhatId = contact.ID;
        insert tk;
    } 


}
