public class InsertAccountRecord {
    public static ID insertAccount(){
        Account acc = new Account();
        
        acc.Name = 'Apex Test 5';
        acc.Industry = 'Media'; 
        
        insert acc;     
        return acc.Id;
    }
    
    public static void createContactRecord(ID accId){
        Contact c = new Contact();
        c.AccountId = accId;
        c.Phone = '1231231235';
        c.FirstName='Apex ';
        c.LastName='Contact 2';
        insert c;
    }
    public static void createOpportunityRecord(){
        ID accId = insertAccount();
        createContactRecord(accId);
        Opportunity opp = new Opportunity();
        
        opp.AccountId = accId;
        opp.StageName = 'Prospecting';
        opp.Amount = 1000;
        opp.Name = 'Opp Apex 1';
        opp.CloseDate = System.today();
        insert opp;
        
        
    }
}