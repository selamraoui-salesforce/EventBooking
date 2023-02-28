@isTest
public class EventBookingTest {  

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
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
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,0);
            Account a1 = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(a1,1,'Phone',0);
            Case request = testRequests.get(0);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage());
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // Given
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account a1 = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(a1,1,'Phone',3);
            Case request = testRequests.get(0);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);
            Test.stopTest();

            // Then

            System.assert(result.isSuccess());
            List<Case> expectedRequest = [SELECT Id, AccountId FROM Case WHERE AccountId=:a1.ID];
            System.assertEquals(1,expectedRequest.size(),'No requests were created');



        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given
            
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,4);
            Account a1 = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(a1,1,'Phone',4);
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage());

        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,1);
            Account a1 = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(a1,1,'Web',1);
            Case request = testRequests.get(0);
                
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess());
            List<Case> expectedRequest = [SELECT Id, AccountId FROM Case WHERE AccountId=:a1.ID];
            System.assertEquals(1,expectedRequest.size(),'No requests were created');


                
        } 
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given

            Account[] testAccts = TestDataFactory.createAccountsWithContacts(1,3);
            Account a1 = testAccts.get(0);

            Case[] testRequests = TestDataFactory.createCaseByAcct(a1,1,'Web',3);
            Case request = testRequests.get(0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(request, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess());
            System.assert(result.getErrors().size() > 0);
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage());
      
        } 
    
    
}
