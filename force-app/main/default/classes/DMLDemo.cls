public class DMLDemo {
    public static void insertDemo(){
        Account acc = new Account();
        acc.Name = 'DML Test';
        acc.Active__c = 'true';
        
        insert acc;
        
        System.debug(acc.Id);
        
    }
}