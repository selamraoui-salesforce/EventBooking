@isTest
private class EventBookingTest {  

        @isTest
        private static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Given
    
            Case[] testRequests = TestDataFactory.createCasesNoAcct(1,'Phone');
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals(System.Label.Cannot_Create_Request_With_No_Account_Error_Message, result.getErrors()[0].getMessage());
        }
        
        @isTest
        private static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,0);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(account,1,'Phone',0);
            Case request = testRequests.get(0);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals(System.Label.Cannot_Create_Request_For_Accounts_With_No_Contacts_Error_Message, result.getErrors()[0].getMessage());
        }
        

        @isTest
        private static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given
            
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,4);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(account,1,'Phone',4);
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals(System.Label.Phone_Requests_Allow_Only_Three_Attendees_Error_Message, result.getErrors()[0].getMessage());
        }

        @isTest
        private static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(account,1,'Web',3);
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals(System.Label.Web_Requests_Allow_Only_One_Attendee_Error_Message, result.getErrors()[0].getMessage());
        } 
        
        @isTest
        private static void bookEventFromPhone(){
            // Given
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(account,1,'Phone',3);
            Case request = testRequests.get(0);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then

            System.assert(result.isSuccess());
            List<Case> expectedRequest = [SELECT Id, AccountId FROM Case WHERE AccountId=:account.ID WITH SECURITY_ENFORCED];
            System.assertEquals(1,expectedRequest.size(),'No requests were created');
        }

        @isTest
        private static void bookEventFromTheWeb(){
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,1);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(account,1,'Web',1);
            Case request = testRequests.get(0);
                
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess());
            List<Case> expectedRequest = [SELECT Id, AccountId FROM Case WHERE AccountId=:account.ID WITH SECURITY_ENFORCED];
            System.assertEquals(1,expectedRequest.size(),'No requests were created');
        } 
            
        

        @isTest
        private static void updateExistingCase(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account account = testAccts.get(0);

            List<Case> testRequests = TestDataFactory.createClosedCaseByAcct(account,1,'Phone',1);
            Case request = testRequests.get(0);

            // When 

            // Test.startTest();

            request.Subject = 'Event Booking Request';
            Database.SaveResult result = Database.update(request, false);  

            // Test.stopTest();
                      

            // Then

            List<Case> requestsToCompare = [SELECT Id, Subject FROM Case WHERE (Id = :request.Id AND Subject='Event Booking Request') WITH SECURITY_ENFORCED];


            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals(1,requestsToCompare.size(),'Description was not updated');
        }


        @isTest
        private static void testThatEmailWasSent(){
            //When 
            Contact contactToEmail = new Contact(LastName='Salesforce', Email='selamraoui@salesforce.com');
            List<Contact> contactsToEmail = new List<Contact> ();
            contactsToEmail.add(contactToEmail);
            Test.startTest();
            System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
     
            EmailService.sendReservationConfirmationEmailsToAttendees(contactsToEmail);
     
            System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
            Test.stopTest();
        }


    
}
