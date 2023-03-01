@isTest
public class TestDataFactory {
    public static List<Account> createAccountsWithContacts(Integer numAccts, Integer numContactsPerAcct){
        List<Account> accounts = new List<Account>();
        for(Integer i=0;i<numAccts;i++){
            Account a = new Account(Name='Salesforce' + i);
            accounts.add(a);
        }
        insert accounts;
        List<Contact> contacts = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account account = accounts[j];
            // For each account just inserted, add contacts
            for (Integer k=0;k<numContactsPerAcct;k++) {
                contacts.add(new Contact(LastName = 'Contact '+k, AccountId = account.ID));  
            }
        }

        insert contacts;
        return accounts;

    }
    public static List<Case> createCaseByAcct(Account account, Integer numReqPerAcct,String origin, Integer numContactsPerAcct){
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
            for(Integer i=0;i<numReqPerAcct;i++){
                Case request = new Case(Origin = origin,
                                    Subject = 'Event Booking', 
                                    Description = description, 
                                    AccountId = account.ID);
                requests.add(request);
            }
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


    public static List<Case> createClosedCaseByAcct(Account account, Integer numReqPerAcct,String origin, Integer numContactsPerAcct){
        List<Case> cases = createCaseByAcct(account, numReqPerAcct, origin, numContactsPerAcct);
        for(Case bookingRequest: cases){
            bookingRequest.Status = 'Closed';
        }
        insert cases;
        return cases;
    }
}