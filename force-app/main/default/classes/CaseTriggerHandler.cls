public with sharing class CaseTriggerHandler extends TriggerHandler {

    static final List<Case> triggerCases = (List<Case>) Trigger.new;

    //put trigger new in a variable
    public override void beforeUpdate() {
        List<Id> requestIds = new List<Id>();

        for (Case request: triggerCases) {
            requestIds.add(request.Id);
        }

        Map<Id, Case> mapRequest = new Map<Id, Case>([SELECT Id, Status FROM Case WHERE Id IN :requestIds WITH SECURITY_ENFORCED ]);

        List<Case> closedRequests = new List<Case>();
        List<Id> closedRequestsAccountIds = new List<Id>();

        for(Case request: triggerCases){
            Case bookingRequest = mapRequest.get(request.Id);
            if(bookingRequest.Status == 'Closed'){
                closedRequests.add(bookingRequest);
                closedRequestsAccountIds.add(bookingRequest.AccountId);
            }
        }

        List<Contact> closedRequestsAttendees = [SELECT Name, Email FROM Contact WHERE AccountId IN :closedRequestsAccountIds];
        ExternalSystemService service = new ExternalSystemService();
        service.registerAttendees(closedRequestsAttendees);
    }
    
    public override void beforeInsert() {
        Set<Id> accountIds = New Set<Id>();

        for (Case request  : triggerCases) {
            accountIds.add(request.AccountId);
        }

        Map<Id, Account> mapAccount = new Map<Id, Account>([SELECT Id, (SELECT Id FROM contacts) FROM Account Where Id IN :accountIds WITH SECURITY_ENFORCED]);

        For(Case bookingRequest: triggerCases)
        {
            if(CaseTriggerHandlerHelper.isRequestAndAccountNotNull(bookingRequest)){

                Account account =  mapAccount.get(bookingRequest.AccountId);

                Integer requestAccountContactNumber = account.Contacts.size();
    
                CaseTriggerHandlerHelper.beforeCaseInsertContactNumberCheck(requestAccountContactNumber,bookingRequest);  
            }
            else {
                bookingRequest.addError(System.Label.Cannot_Create_Request_With_No_Account_Error_Message);
            }
        
        }
 
    }
}