public class OpportunityContractTriggerHandler {
    
    public static void createContract(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpp){
        
        List<Contract> contractList = new List<Contract>();
        for(Opportunity opp: OpportunityList){
            
            if(opp.StageName == 'Closed Won'){
                Opportunity op = [Select Id, Account.Id, ContactId, Account.BillingStreet, Account.BillingCity, 
                                  Account.BillingState, Account.BillingPostalCode, 
                                  Account.BillingCountry, StageName FROM Opportunity WHERE Id =:opp.Id ];
            
                Contract contract = new Contract();
               
                contract.AccountId=  op.Account.Id;
                contract.StartDate = System.Today();
                contract.ContractTerm = 6;
                contract.Pricebook2Id = '01sWU000008vIJlYAM';
                contract.CustomerSignedId = op.ContactId;
                contract.BillingCountry = op.Account.BillingCountry;
                contract.BillingCity = op.Account.BillingCity;
                contract.BillingStreet = op.Account.BillingStreet;
                contract.BillingState = op.Account.BillingState;
                contract.BillingPostalCode = op.Account.BillingPostalCode;
                
                insert contract; 
  
                Order order = new Order();
                order.AccountId = op.Account.Id;
                order.ContractId = contract.Id;
                order.OpportunityId = op.Id;
                order.EffectiveDate = System.Today();
                order.Status = 'Draft';
                order.CustomerAuthorizedById = op.ContactId;
                insert order;
            }
           
        }
        
    }
}