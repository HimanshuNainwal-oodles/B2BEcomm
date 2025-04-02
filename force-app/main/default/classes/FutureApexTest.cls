@isTest
private class FutureApexTest {
    
    @isTest
    static void createAccount(){
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i< 200; i++){
            accList.add(new Account(name = 'test'+i, billingcity = 'hld'));
        }
        
        Test.startTest();
        insert accList;
        
        List<Id> accIds = new List<Id>();
        List<Contact> conList = new List<Contact>();
        
        for(Account acc: accList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
            con.FirstName = 'Test';
            con.LastName = acc.Name;
            conList.add(con);
            accIds.add(acc.Id);
        }
        insert conList;
        
        FutureApex.futureMethod(accIds);
        
        Test.stopTest();
        
        //List<Account> accCon = [SELECT Id,(SELECT ID, Name From Contacts), Count_No_of_Contacts__c from Account];
        
       // System.assertEquals(1, accCon[0].Count_No_of_Contacts__c, 'Contacts are not counted Successfully');
        List<Account> accCon = [SELECT Id, Description, Count_No_of_Contacts__c, (SELECT ID, Name From Contacts) from Account];
		System.assertEquals('Test test0',accCon[0].Contacts[0].Name);
    }
    
    
}