public class ContractHelper {
    public Contract contractRecord;
       
       public ContractHelper(Opportunity op, String pricebook){
           contractRecord = new Contract();
           contractRecord.AccountId = op.AccountId;
           contractRecord.StartDate = System.Today() + 5;
           contractRecord.ContractTerm = 6;
           contractRecord.Pricebook2Id = pricebook;
           contractRecord.Opportunity__c = op.Id;
           contractRecord.CustomerSignedId = op.ContactId;
           contractRecord.BillingCountry = op.Account.BillingCountry;
           contractRecord.BillingCity = op.Account.BillingCity;
           contractRecord.BillingStreet = op.Account.BillingStreet;
           contractRecord.BillingState = op.Account.BillingState;
           contractRecord.BillingPostalCode = op.Account.BillingPostalCode;
   
       }
   
       public Contract getContractRecord() {
           return contractRecord;
       }
   }