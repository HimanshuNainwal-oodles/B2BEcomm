@isTest
public class OpportunityContractTriggerHandlerTest {
    
    @testSetup
    public static void createDate(){
        Account ac = new Account();
        ac.Name = 'test';
        ac.BillingCountry = 'India';
        ac.BillingStreet = 'street';
        ac.BillingCity = 'city';
        ac.BillingState = 'Uttarakhand';
        ac.BillingPostalCode = '123456';
        
        insert ac;
        
        Opportunity op = new Opportunity();
        op.Name = 'test';
        op.CloseDate = System.today();
        op.AccountId = ac.Id;
        op.StageName = 'Prospecting';
        insert op;
        
        Opportunity op1 = new Opportunity();
        op1.Name = 'test1';
        op1.CloseDate = System.today();
        op1.AccountId = ac.Id;
        op1.StageName = 'Closed Won';
        insert op1;
    }
    
    @isTest
    public static void checkOpportunityIsNotWon(){
        Opportunity op = [SELECT Id, StageName FROM Opportunity WHERE StageName =:'Prospecting'];
        
        Test.startTest();
        OpportunityContractTriggerHandler.createContract(new List<Opportunity>{op}, new Map<Id, Opportunity>());
        Test.stopTest();
        
        List<Contract> contract = [SELECT Id, ContractNumber FROM Contract WHERE Opportunity__c =: op.Id];
        List<Order> order = [SELECT Id, OrderNumber FROM Order WHERE OpportunityId =: op.Id];
        
        System.assertEquals(0, contract.size(), 'No contract for Opportunity Not won Closed');
        System.assertEquals(0, order.size(), 'No Order for Opportunity Not won Closed');
        
    }
    
    @isTest
    public static void checkOpportunityIsWon(){
        Opportunity op = [SELECT Id, StageName FROM Opportunity WHERE StageName =:'Closed Won'];
        
        Test.startTest();
        OpportunityContractTriggerHandler.createContract(new List<Opportunity>{op}, new Map<Id, Opportunity>());
        Test.stopTest();
        
        List<Contract> contract = [SELECT Id, ContractNumber FROM Contract WHERE Opportunity__c =: op.Id];
        List<Order> order = [SELECT Id, OrderNumber FROM Order WHERE OpportunityId =: op.Id];
        
        System.assertEquals(1, contract.size(), 'contract for Opportunity Not won Closed');
        System.assertEquals(1, order.size(), 'Order for Opportunity Not won Closed');
        
    }
    
    
    @isTest
    static void testOpportunityWithExistingContractOrOrder() {
        Opportunity opp = [SELECT Id, AccountId, StageName FROM Opportunity WHERE StageName = 'Closed Won' LIMIT 1];
        Account acc = [SELECT Id, BillingCountry, BillingCity, BillingStreet, BillingState, BillingPostalCode FROM Account WHERE Id =: opp.AccountId];
        
        // Create a Contract and Order for the Opportunity
        Contract existingContract = new Contract();
        existingContract.Opportunity__c = opp.Id;
        existingContract.AccountId = acc.Id;
        existingContract.StartDate = System.Today();
        existingContract.ContractTerm = 6;
        insert existingContract;
        
        Order existingOrder = new Order();
        existingOrder.OpportunityId = opp.Id;
        existingOrder.AccountId = acc.Id;
        existingOrder.ContractId = existingContract.Id;
        existingOrder.EffectiveDate = System.Today();
        existingOrder.BillingCountry = acc.BillingCountry;
        existingOrder.BillingCity = acc.BillingCity;
        existingOrder.BillingStreet = acc.BillingStreet;
        existingOrder.BillingState = acc.BillingState;
        existingOrder.BillingPostalCode = acc.BillingPostalCode;
        existingOrder.Status = 'Draft';
        insert existingOrder;
     
        Test.startTest();
        // Simulating the trigger call
        OpportunityContractTriggerHandler.createContract(new List<Opportunity>{opp}, new Map<Id, Opportunity>());
        Test.stopTest();
        
        // Verify that no new contract or order is created
        List<Contract> contracts = [SELECT Id FROM Contract WHERE Opportunity__c = :opp.Id];
        List<Order> orders = [SELECT Id FROM Order WHERE OpportunityId = :opp.Id];
        
        System.assertEquals(1, contracts.size(), 'No new Contract should be created');
        System.assertEquals(1, orders.size(), 'No new Order should be created');
        
    }
}