public with sharing class ExternalSystemService {

    private String webServiceURL;

    public ExternalSystemService(){
        this.webServiceURL = ('callout:animals_JSON?format=json');
    }

 
    public void registerAttendees(Case bookingRequest){
        Account a = [SELECT Id FROM Account WHERE Id = :bookingRequest.Account.Id WITH SECURITY_ENFORCED LIMIT 1];
        List<Contact> contacts = [SELECT Id,Name, Email FROM Contact WHERE AccountId = :a.Id WITH SECURITY_ENFORCED];
        List<Contact> contactsToEmail = new List<Contact>();
        for(Contact contact : contacts){
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            request.setEndpoint(this.webServiceURL);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody('{"name":"'+ contact.name + '-' + contact.email  +'}');

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
        EmailService.sendReservationConfirmationEmailsToAttendees(contactsToEmail, bookingRequest);


    } 

    public void notifyAttendeeByEmail(Contact account){
      
        Task tk = new Task();
        tk.Subject = 'Send Email To' + account.name;
        tk.Status = 'Open';
        tk.Priority = 'Normal';
        tk.WhatId = account.ID;
        insert tk;
    } 


}
