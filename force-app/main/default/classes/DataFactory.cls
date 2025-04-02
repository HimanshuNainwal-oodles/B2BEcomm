public class DataFactory {
    public static List<Account> createAccountRecord(String Name, Integer count, Boolean isInsert){
        List<Account> accList = new List<Account>();
        for(Integer i =0; i< count; i++){
			Account acc = new Account(name = 'Name'+i);
            accList.add(acc);
        }
        
        if(isInsert){
            insert accList;
        }
        return accList;
    }
}