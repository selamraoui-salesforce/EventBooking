public with sharing class CaseTriggerHandlerHelper {

    public static void beforeCaseInsertContactNumberCheck(Integer requestAccountContactsNumber, Case bookingRequest){
        if( requestAccountContactsNumber == 0){
            bookingRequest.addError(System.Label.Cannot_Create_Request_For_Accounts_With_No_Contacts_Error_Message);
        }   else {
            switch on bookingRequest.Origin {
                when 'Web' {
                    if(requestAccountContactsNumber >= 2){
                        bookingRequest.addError(System.Label.Web_Requests_Allow_Only_One_Attendee_Error_Message);
                    }
                }
                when 'Phone'{
                    if(requestAccountContactsNumber >= 4){
                        bookingRequest.addError(System.Label.Phone_Requests_Allow_Only_Three_Attendees_Error_Message);
                    }
                }
                when else{
                    bookingRequest.addError(System.Label.Cannot_Create_Not_In_Phone_Or_Web_Error_Message);
                }
            }                 
        }
    }

    public static void isRequestAndAccountNotNull(Case bookingRequest){
        if(bookingRequest != null && bookingRequest.AccountId != null){
            return true;
        }
        else{
            return false;
        }
    }
    
}