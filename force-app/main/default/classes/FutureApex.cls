public class FutureApex {
    
    @future
    public static void futureMethod(List<Id> accIds){
        List<Account> accList = [SELECT Id, Count_No_of_Contacts__c, (SELECT Id From Contacts) FROM Account WHERE Id IN: accIds];
        
        for(Account acc: accList){
            acc.Count_No_of_Contacts__c = acc.Contacts.size();            
        }	
        if(!accList.isEmpty()){
            update accList;
        }
    }
}