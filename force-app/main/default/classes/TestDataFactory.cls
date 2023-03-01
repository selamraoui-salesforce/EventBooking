@isTest
public class TestDataFactory {
    public static List<Account> createAccountsWithContacts(Integer numAccts, Integer numContactsPerAcct){
        List<Account> accts = new List<Account>();
        for(Integer i=0;i<numAccts;i++){
            Account a = new Account(Name='Salesforce' + i);
            accts.add(a);
        }
        insert accts;
        List<Contact> contacts = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add contacts
            for (Integer k=0;k<numContactsPerAcct;k++) {
                contacts.add(new Contact(LastName = 'Contact '+k, AccountId = acct.ID));  
            }
        }

        insert contacts;
        return accts;

    }
    public static List<Case> createCaseByAcct(Account acc, Integer numReqPerAcct,String origin, Integer numContactsPerAcct){
        String description = '';
        List<Case> requests = new List<Case>();
        if(numContactsPerAcct==0){
            description = 'Book Spots';
        }
        else if(numContactsPerAcct==1){
            description = 'Book One Spot for Company A1';
        }
        else{
            description = 'Book Spots for Company A1 & their '+numContactsPerAcct+' employees';
        }
        // for(Account acc: accList){
            for(Integer i=0;i<numReqPerAcct;i++){
                Case request = new Case(Origin = origin,
                                    Subject = 'Event Booking', 
                                    Description = description, 
                                    AccountId = acc.ID);
                requests.add(request);
            }
        // }
        return requests;

    }

    public static List<Case> createCasesNoAcct(Integer numCases, String origin){
        List<Case> requests = new List<Case>();
        for(Integer i=0;i<numCases;i++) {
            Case request = new Case(Origin = origin,
                Subject = 'Event Booking', 
                Description = 'Book Spots');
            requests.add(request);
        }
        return requests;

    }


    public static List<Case> createClosedCaseByAcct(Account acc, Integer numReqPerAcct,String origin, Integer numContactsPerAcct){
        List<Case> cases = createCaseByAcct(acc, numReqPerAcct, origin, numContactsPerAcct);
        for(Case c: cases){
            c.Status = 'Closed';
        }
        insert cases;
        return cases;
    }
}