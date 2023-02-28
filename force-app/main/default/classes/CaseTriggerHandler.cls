public with sharing class CaseTriggerHandler extends TriggerHandler {
    public CaseTriggerHandler() {

    }

    public override void beforeUpdate() {

        for(Case request: (List<Case>) Trigger.new){
            Case r = [SELECT AccountId, Status FROM Case where id=:request.ID];
            if(r.Status == 'Closed'){
                ExternalSystemService service = new ExternalSystemService();
                service.registerAttendees(r);
            }
        }
    }
    
    public override void beforeInsert() {
        Set<Id> accountIds = New Set<Id>();
        For(Case r : (List<Case>) Trigger.new)
        {
            if(r != null && r.AccountId != null){

                Account account =  [SELECT ID, (select id from contacts) FROM Account where id = :r.AccountId LIMIT 1];
        
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