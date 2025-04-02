public class SOQLDemo {
    
    public static void queryDemo(){
        List<Account> acclst = [SELECT Id, Name, Industry
                                FROM Account
                                WHERE Industry = 'Media' AND Rating = 'Hot']; 
        //[SELECT Id, Name, Industry FROM Account Industry IN ('Media', 'Energy') AND Rating = 'Hot']; 
        for(Account acc : acclst){
            System.debug(acc);      
        }
        System.debug('Good Evening');
        System.debug('Good Evening test using Cli');
    }
    
}