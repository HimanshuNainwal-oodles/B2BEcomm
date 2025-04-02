@RestResource(urlMapping='/accountmngmt/*')
global class CustomApi {
    
    @HttpGet
    global static List<Account> getTopAccount(){
        List<Account> accList = [SELECT Name, Id FROM Account ];
        return accList;
    }
    /*global static AccountWrapper getRecord(){
Map<String, String> reqParam = RestContext.request.params;
Set<Id> id =  new Set<Id>();
String accIndustry = reqParam.get('Industry');
System.debug(accIndustry);
List<Account> accList = [SELECT Id, Name, Phone, Industry, Valid_Phone__c FROM Account WHERE Industry =:accIndustry ORDER BY CreatedById ];
for(Account acc: accList){
id.add(acc.id);
}
List<Contact> conList = [SELECT Id, lastName, firstName, email FROM Contact WHERE accountId in:id];
List<Case> caseList = [SELECT Id, priority, status, ContactPhone, ContactMobile, CaseNumber FROM Case WHERE accountId in:id];

AccountWrapper accWr = new AccountWrapper();
accWr.accList = accList;
accWr.conList = conList;
accWr.caseList = caseList;

return accWr;
}
*/
    
    /*@HttpPost
global static String createAccount(String AccName, String Industry, String Rating){
Account acc = new Account();
acc.Name = AccName;
acc.Industry = Industry;
acc.Rating = Rating;
try{
insert acc;
return 'Account created Successfully';
}catch(Exception e){
return e.getMessage();
}
}*/
    @HttpPost
    global static String createAccountAndContact(AccountInformation accInfo){
        Account createAcc = accInfo.accountRecord;
        Contact createCon = accInfo.contactRecord;
        try{
            insert createAcc;
            createCon.AccountId = createAcc.Id;
            insert createCon;
            return 'Account and Contact created';
        }catch(Exception e){
            return e.getMessage(); 
        }
    }
    
    @HttpDelete
    global static String deleteAccount(){
        Map<String, String> paramMap = RestContext.request.params;
        String accId = paramMap.get('accId');
        List<Account> acc = [Select Id from Account where id =:accId];
        if(!acc.isEmpty()){
            
            try{
                delete acc;       
                return 'Account removed successfully';
            } catch(Exception e){
                return e.getMessage();
            }
        }
        return 'No Account present with '+accId+' account id';
    }
    
    
    
    
    global class AccountWrapper{
        global List<Account> accList;
        global List<Contact> conList;
        global List<Case> caseList;
    }
    
    global class AccountInformation{
        global Account accountRecord{get;set;}
        
        global Contact contactRecord{get; set;}
    }
    
}