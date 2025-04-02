public class InvoiceExtension {
    public OrderInvoice__c invoice { get; set; }
    public List<OrderItem> orderItems { get; set; }

    public InvoiceExtension(ApexPages.StandardController controller) {
        // Get Invoice ID from the page
        Id invoiceId = controller.getId();	
        
        // Fetch Invoice Details with Order Data
        invoice = [
            SELECT Id, Name, Total_Amount__c, Invoice_Date__c, 
                   Order__c, Order__r.OrderNumber, Order__r.BillingCountry, Order__r.BillingStreet,  Order__r.BillingCity, Order__r.BillingState, Order__r.BillingPostalCode,
                  Order__r.ShippingStreet, Order__r.ShippingCity, Order__r.ShippingState, Order__r.ShippingPostalCode, Order__r.ShippingCountry,
                   Opportunity__r.Account.Name
            FROM OrderInvoice__c 
            WHERE Id  = :invoiceId
            LIMIT 1
        ];

        // Fetch Order Items Related to this Order
        orderItems = [
            SELECT Id, Product2.Name, UnitPrice, Quantity, TotalPrice 
            FROM OrderItem 
            WHERE OrderId = :invoice.Order__c
        ];
    }
}