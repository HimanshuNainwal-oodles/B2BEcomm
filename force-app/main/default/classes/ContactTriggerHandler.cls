public class ContactTriggerHandler {

    public static void updateContactCount(List<Contact> conList){
        List<Account> accList = new List<Account>();
        Set<Id> accIds = new Set<Id>();
        
        for(Contact con : conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
        
        for(Account acc: [SELECT Id, (SELECT Id from Contacts) FROM Account WHERE Id IN: accIds ]){
            acc.Total_Contact__c = acc.Contacts.size();
            accList.add(acc);
        }
        if(!accList.isEmpty()){
			update accList;
        }
    }
}