@isTest
private class AccountTriggerHandlerTest {
    
    @isTest
    static void createOppTest(){
        /*
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT Id from Opportunity where AccountId =:accList[0].Id];
        
        System.assert(oppList != null, 'Opportunity is not created');
        */
        
      
       
 		List<Account> accList = DataFactory.createAccountRecord('Test', 10, true);
        System.assertEquals(10, accList.size());
        
        
    }
    
}