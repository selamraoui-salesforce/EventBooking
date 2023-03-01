public with sharing class EmailService {

    public static void sendReservationConfirmationEmailsToAttendees(List<Contact> contactsToEmail, Case reservationRequest){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String[] contactsMailAddresses = new String[]{};

        for(Contact contact: contactsToEmail){
            String mailAddress = contact.email;
            contactsMailAddresses.add(mailAddress);
        }
        message.toAddresses = contactsMailAddresses;
        message.subject = 'Registration confirmed';
        message.plainTextBody = 'Your registration has been confirmed.';
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}