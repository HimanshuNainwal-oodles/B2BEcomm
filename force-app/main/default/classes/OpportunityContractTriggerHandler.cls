public class OpportunityContractTriggerHandler {
    
    public static void createContract(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOppMap) {
        
        
        List<Pricebook2> pricebookList = [SELECT Id, Name FROM Pricebook2 WHERE Name LIKE '%B2B%'];
        String bookName = '';
        
        if (!pricebookList.isEmpty()) {
            bookName = pricebookList[0].Id;
        }
        
        Set<Id> oppIds = new Set<Id>();
        for (Opportunity opp : opportunityList) {
            oppIds.add(opp.Id);
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT Id, AccountId, ContactId, StageName, 
             Account.BillingStreet, Account.BillingCity, Account.BillingState, 
             Account.BillingPostalCode, Account.BillingCountry, Account.ShippingStreet, Account.ShippingCity, Account.ShippingState,
             Account.ShippingPostalCode, Account.ShippingCountry
             FROM Opportunity WHERE Id IN :oppIds]
        );
        
        List<Contract> allContracts = [SELECT Id, Opportunity__c FROM Contract WHERE Opportunity__c IN :oppIds];
        List<Order> allOrders = [SELECT Id, OpportunityId FROM Order WHERE OpportunityId IN :oppIds];
        
        Map<Id, List<Contract>> oppContracts = new Map<Id, List<Contract>>();
        Map<Id, List<Order>> oppOrders = new Map<Id, List<Order>>();
        
        for (Contract c : allContracts) {
            if (!oppContracts.containsKey(c.Opportunity__c)) {
                oppContracts.put(c.Opportunity__c, new List<Contract>());
            }
            oppContracts.get(c.Opportunity__c).add(c);
        }
        
        for (Order o : allOrders) {
            if (!oppOrders.containsKey(o.OpportunityId)) {
                oppOrders.put(o.OpportunityId, new List<Order>());
            }
            oppOrders.get(o.OpportunityId).add(o);
        }
        
        List<Contract> contractsToInsert = new List<Contract>();
        List<Order> ordersToInsert = new List<Order>();
        
        for (Opportunity opp : opportunityList) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            
            // Check if the Opportunity stage has changed to 'Closed Won'
            if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) {
                
                if (oppContracts.containsKey(opp.Id) && !oppContracts.get(opp.Id).isEmpty() ||
                    oppOrders.containsKey(opp.Id) && !oppOrders.get(opp.Id).isEmpty()) {
                        System.debug('Contract or Order already present for the opportunity');
                        continue;
                    }
                
                Opportunity op = oppMap.get(opp.Id);
                
                // Create the new Contract
                /*Contract contract = new Contract();
                contract.AccountId = op.AccountId;
                contract.StartDate = System.Today() + 5;
                contract.ContractTerm = 6;
                contract.Pricebook2Id = bookName;
                contract.Opportunity__c = op.Id;
                contract.CustomerSignedId = op.ContactId;
                contract.BillingCountry = op.Account.BillingCountry;
                contract.BillingCity = op.Account.BillingCity;
                contract.BillingStreet = op.Account.BillingStreet;
                contract.BillingState = op.Account.BillingState;
                contract.BillingPostalCode = op.Account.BillingPostalCode;
*/
                ContractHelper contract = new ContractHelper(op, bookName);
                contractsToInsert.add(contract.getContractRecord());
            }
        }
        
        if (!contractsToInsert.isEmpty()) {
            insert contractsToInsert;
        }
        
        for (Contract c : contractsToInsert) {
            Opportunity op = oppMap.get(c.Opportunity__c); 
            
            // Order order = new Order();
            // order.AccountId = op.AccountId;
            // order.ContractId = c.Id;
            // order.OpportunityId = op.Id;
            // order.EffectiveDate = System.Today() + 7;
            // order.Status = 'Draft';
            // order.CustomerAuthorizedById = op.ContactId;
            
            // order.BillingCountry = op.Account.BillingCountry;
            // order.BillingCity = op.Account.BillingCity;
            // order.BillingStreet = op.Account.BillingStreet;
            // order.BillingState = op.Account.BillingState;
            // order.BillingPostalCode = op.Account.BillingPostalCode;
            // order.ShippingCountry = op.Account.ShippingCountry;
            // order.ShippingCity = op.Account.ShippingCity;
            // order.ShippingStreet = op.Account.ShippingStreet;
            // order.ShippingState = op.Account.ShippingState;
            // order.ShippingPostalCode = op.Account.ShippingPostalCode;
            OrderHelper order = new OrderHelper(op, c);
            ordersToInsert.add(order.getOrderRecord());
        }
        
        if (!ordersToInsert.isEmpty()) {
            insert ordersToInsert;
        }
        
          }
}