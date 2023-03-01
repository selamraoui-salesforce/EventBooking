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
        private static void updateExistingCase(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createClosedCaseByAcct(account,1,'Phone',1);
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            request.Description = 'Book One Spot for the A1 company in our hotel';
            Database.SaveResult result = Database.update(request, false);  

            Test.stopTest();
                      

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            // System.assertEquals(request.Id, result.getId(), 'Description was not updated');
            
        }

        @isTest
        private static void sendEmailAfterAttendeeRegistry(){
            // Given

            //create account, contacts, closed case
            //create mock http post request to register attendees

            // When

            Test.startTest();

            ///
            // request.Description = 'Book One Spot for the A1 company in our hotel';
            // Database.SaveResult result = Database.update(request, false);  

            Test.stopTest();

            // Then
        }

        /*

        @isTest
        private static void closeExistingCase(){
            // Given
            // Create account, contacts, case properly
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account account = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createClosedCaseByAcct(account,1,'Phone',3);
            Case request = testRequests.get(0);

            // When start test
            //Change case status to closed
            Test.startTest();

            request.Status = 'Book One Spot for the A1 company in our hotel';
            Database.SaveResult result = Database.update(request, false);  
            
            Test.stopTest();

            // Then
            // Assert success
            // Assert that attendees were created

        } */
    
}
