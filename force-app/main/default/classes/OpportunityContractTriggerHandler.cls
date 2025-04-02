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
        
        Map<Id, Contract> oppContracts = new Map<Id, Contract>();
        Map<Id, Order> oppOrders = new Map<Id, Order>();
        
        for (Contract c : allContracts) {
            if (!oppContracts.containsKey(c.Opportunity__c)) {
                oppContracts.put(c.Opportunity__c, new Contract());
            }
            // oppContracts.get(c.Opportunity__c).add(c);
        }
        
        for (Order o : allOrders) {
            if (!oppOrders.containsKey(o.OpportunityId)) {
                oppOrders.put(o.OpportunityId, new Order());
            }
            // oppOrders.get(o.OpportunityId).add(o);
        }
        
        List<Contract> contractsToInsert = new List<Contract>();
        List<Order> ordersToInsert = new List<Order>();
        
        for (Opportunity opp : opportunityList) {
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            
            // Check if the Opportunity stage has changed to 'Closed Won'
            if (opp.StageName == 'Closed Won' && (oldOpp == null || oldOpp.StageName != 'Closed Won')) {
                Opportunity optest = oppMap.get(opp.Id);
                if(optest.Account.BillingCity == null || optest.Account.BillingStreet == null|| optest.Account.BillingState == null||
                optest.Account.BillingPostalCode == null|| optest.Account.BillingCountry == null){
                    opp.addError('Billing Address cannot be empty');
                    return;
                }
                if (oppContracts.containsKey(opp.Id) && oppContracts.get(opp.Id) != null ||
                oppOrders.containsKey(opp.Id) && oppOrders.get(opp.Id) != null) {
                    System.debug('Contract or Order already present for the opportunity');
                    continue;
                }
                
                Opportunity op = oppMap.get(opp.Id);
                
                ContractHelper contract = new ContractHelper(op, bookName);
                contractsToInsert.add(contract.getContractRecord());
            }
        }
        
        if (!contractsToInsert.isEmpty()) {
            insert contractsToInsert;
        }
        
        for (Contract c : contractsToInsert) {
            Opportunity op = oppMap.get(c.Opportunity__c);
            
            OrderHelper order = new OrderHelper(op, c);
            ordersToInsert.add(order.getOrderRecord());
        }
        
        if (!ordersToInsert.isEmpty()) {
            insert ordersToInsert;
        }
        
    }
}