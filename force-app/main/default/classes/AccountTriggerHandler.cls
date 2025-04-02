public class AccountTriggerHandler {
    @future(callout=true)
    public static void verifyPhone(List<Id> accIds){
        List<Account> accountsToUpdate = [SELECT Id, Phone FROM Account WHERE Id IN :accIds];
		List<Account> verifiedPhoneAcc = new List<Account>();
        
        for(Account acc : accountsToUpdate){
            String endpoint = 'http://apilayer.net/api/validate?access_key=' + '36eac3ca1950fe2d2ea01a680fa42be5' + '&number=' + acc.Phone;
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            
            Http http = new Http();
            System.debug('Test verify Phone');
            try {
                HttpResponse response = http.send(request);
                if (response.getStatusCode() == 200) {
                    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    Boolean isValid = (Boolean) result.get('valid');
                    System.debug(result.get('valid'));
                    System.debug(result);
                    
                    if(isValid){
                        acc.Valid_Phone__c = true;
                        verifiedPhoneAcc.add(acc);
                        
                    } 
                }
                update verifiedPhoneAcc;
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
            
        }
    }
    
    
    public static void updateAccount(List<Account> accList, Map<Id, Account> accOldMap){
        List<Account> accToBeUpdated = new List<Account>();
        
        for(Account acc: accList){
            Account a = new Account();
            a.Id = acc.Id;
            a.Description = 'Test Trigger Recursion';
            accToBeUpdated.add(a);
        }
        
        if(!accToBeUpdated.isEmpty()){
            update accToBeUpdated;
        }
        
    }
    
    public static void preventDeletion(List<Account> accList){
        for(Account acc: accList){
            if(acc.Active__c == 'Yes'){
                acc.addError(Label.Prevent_Account_Deletion);
                //acc.addError('Active Account cannot be deleted');
            }
        }
        
    }
    
    public static void updateRelatedContact(List<Account> accList, Map<Id, Account> accOldMap){
        
        List<Contact> conList = new List<Contact>();
        
        
        Map<Id, Account> accMap = new Map<Id, Account>();
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                accMap.put(acc.Id, acc);
            }
        }
        for(Contact con: [SELECT Id, HomePhone, AccountId FROM Contact 
                          WHERE AccountId IN: accMap.keySet()]){
                              if(accMap.containsKey(con.AccountId)){
                                  con.HomePhone = accMap.get(con.AccountId).Phone;
                                  conList.add(con);
                              }
                          } 
        if(!conList.isEmpty()){
            update conList;	
        }
        
        
        
        //OR
        /* Set<Id> accId = new Set<Id>();
for(Account acc : accList){
if(acc.Phone != accOldMap.get(acc.Id).Phone){
accId.add(acc.Id);
}
}
for(Account acc: [SELECT Id, Phone, (SELECT HomePhone FROM Contacts) FROM Account where Account.Id IN: accId]){
if(acc.Contacts != null){
for(Contact con: acc.Contacts){
con.HomePhone = acc.Phone;

conList.add(con);
}
}
}

if(!conList.isEmpty()){
update conList;	
}*/
        
    }	 
    
    public static void populateRating(List<Account> accList, Map<Id, Account> accOldMap){
        for(Account acc : accList){
            if((accOldMap == null && acc.Industry != null && acc.Industry == 'Finance') ||
               (accOldMap != null && acc.Industry != null && acc.Industry != accOldMap.get(acc.Id).Industry && acc.Industry == 'Finance')){
                   acc.Rating = 'Hot';
                   
               }
        }
    }
    public static void updatePhone(List<Account> accList, Map<Id, Account> accOldMap){
        for(Account acc : accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                acc.Description = 'Phone is updated | Old Value :' + accOldMap.get(acc.Id).Phone + ' New Value :' +acc.Phone; 	
            }
        }
    }
    
    public static void createOpportunity(List<Account> accList){
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Account acc: accList){
            Opportunity opp = new Opportunity(); 
            opp.Name = acc.Name;
            opp.CloseDate = System.today();
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            oppList.add(opp);
        }
        if(!oppList.isEmpty()){          
            insert oppList;
        }
    }
    
    public static void updateDescription(List<Account> accList){
        if(!accList.isEmpty()){
            for(Account acc : accList){
                acc.Description = 'Account Description via Trigger Handler';
            }
        }
    }
    
}