@isTest
private class UpdateParentAccountTest {
    
    @testSetup
    static void setup(){
        Account acc = new Account(name = 'Parent', billingcity = 'Hawani');
        List<Account> accList = new List<Account>();
        accList.add(acc);
        for(Integer i = 0; i< 200; i++){
            Account acc2 = new Account();
            acc2.Name= 'Test'+i;
            acc2.BillingCity = 'hld'+i;
            accList.add(acc2);
            
        }
        insert accList;
    }
    
    
    @isTest
    private static void testQueueable(){
        
        Id parentId = [SELECT Id from Account WHERE Name ='Parent'][0].id;
        List<Account> accL = [Select Id from Account Where Name LIKE 'Test%'];
        UpdateParentAccount updateJob = new UpdateParentAccount(accL, parentId);
        
        Test.startTest();
        System.enqueueJob(updateJob);
        Test.stopTest();
        
        System.assertEquals(200, [SELECT count() FROM Account WHERE ParentId =: parentId]);
    }
}