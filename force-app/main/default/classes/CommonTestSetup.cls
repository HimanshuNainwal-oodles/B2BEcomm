@isTest
private class CommonTestSetup {
    
    @testSetup
    static void setup(){
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i<= 200; i++){
            accList.add(new Account(name = 'test'+i));
            
        }
        insert accList;
    }
    
    @isTest
    static void testAcc(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'test200'];
        System.assertEquals('test200', acc.Name);
        
    }
    
    @isTest
    static void testUpdateAcc(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'test200'];
        
        acc.Phone = '123-431';
        update acc;
        Account acc2 =[SELECT Id, Phone FROM Account WHERE Name = 'test200'];
        System.assertEquals('123-431', acc2.Phone);
    }
    
    @isTest
    static void testDeleteAcc(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'test200'];
        
        delete acc;
        List<Account> acc2 =[SELECT Id FROM Account];
        System.assertEquals(199, acc2.size());
    }
    
}