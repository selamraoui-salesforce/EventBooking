public with sharing class CaseTriggerHandler extends TriggerHandler {
    public CaseTriggerHandler() {

    }

    public override void beforeUpdate() {
        List<Id> requestIds = new List<Id>();
        for (Case request  : (List<Case>) Trigger.new) {
            requestIds.add(request.Id);
        }

        Map<Id, Case> mapRequest = new Map<Id, Case>([SELECT Id, Status FROM Case where Id IN :requestIds WITH SECURITY_ENFORCED ]);
        List<Case> updateRequest = new List<Case>();

        for(Case request: (List<Case>) Trigger.new){
            Case r = mapRequest.get(request.Id);
            if(r.Status == 'Closed'){
                ExternalSystemService service = new ExternalSystemService();
                service.registerAttendees(r);
            }
        }
    }
    
    public override void beforeInsert() {
        Set<Id> accountIds = New Set<Id>();

        for (Case request  : (List<Case>) Trigger.new) {
            accountIds.add(request.AccountId);
        }

        Map<Id, Account> mapAccount = new Map<Id, Account>([SELECT ID, (select id from contacts) FROM Account where id IN :accountIds WITH SECURITY_ENFORCED]);
        List<Account> updateAccount = new List<Account>();

        For(Case r : (List<Case>) Trigger.new)
        {
            if(r != null && r.AccountId != null){

                Account account =  mapAccount.get(r.AccountId);

                Integer s = account.Contacts.size();
        
                if(s ==0){
                    r.addError('You cannot create a request for accounts without contacts');
                }   else {
                    switch on r.Origin {
                        when 'Web' {
                            if(s >= 2 ){
                                r.addError('Web request are only allowed to have one attendee');
                            }
                        }
                        when 'Phone'{
                            if(s >= 4 ){
                                r.addError('Phone request are only allowed to have three attendee');
                            }
                        }
                    }    
                                
                }
        
            }else {
                r.addError('You cannot create a request without attaching an account');
            }
        
        }
 
    }
}