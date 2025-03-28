public class OrderHelper{
    public Order orderRecord;
    
    public OrderHelper(Opportunity op, Contract c){
		orderRecord = new Order();
        orderRecord.AccountId = op.AccountId;
        orderRecord.ContractId = c.Id;
        orderRecord.OpportunityId = op.Id;
        orderRecord.EffectiveDate = System.Today() + 7;
        orderRecord.Status = 'Draft';
        orderRecord.CustomerAuthorizedById = op.ContactId;
        
        orderRecord.BillingCountry = op.Account.BillingCountry;
        orderRecord.BillingCity = op.Account.BillingCity;
        orderRecord.BillingStreet = op.Account.BillingStreet;
        orderRecord.BillingState = op.Account.BillingState;
        orderRecord.BillingPostalCode = op.Account.BillingPostalCode;
        orderRecord.ShippingCountry = op.Account.ShippingCountry;
        orderRecord.ShippingCity = op.Account.ShippingCity;
        orderRecord.ShippingStreet = op.Account.ShippingStreet;
        orderRecord.ShippingState = op.Account.ShippingState;
        orderRecord.ShippingPostalCode = op.Account.ShippingPostalCode;
    }
    
    public Order getOrderRecord(){
        return orderRecord;
    }
}