public with sharing class EmailService {
    public EmailService() {

    }
    public static void sendEmail(Contact contact, Case r){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { contact.email };
        message.optOutPolicy = 'FILTER';
        message.subject = 'Registration confirmed';
        message.plainTextBody = 'Hello, '+contact.FirstName+' '+contact.LastName+'! Your registration has been confirmed.';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}