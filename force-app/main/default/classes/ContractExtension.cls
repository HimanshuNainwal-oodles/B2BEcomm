public class ContractExtension {

    public Contract contract { get; set; }
    //public List<OrderItem> orderItems { get; set; }

    public ContractExtension(ApexPages.StandardController controller) {
        // Get Invoice ID from the page
        Id contractId = controller.getId();	
        
        // Fetch Invoice Details with Order Data
        contract = [
            SELECT Id, ContractNumber
            FROM Contract 
            WHERE Id  = :contractId
            LIMIT 1
        ];

        // Fetch Order Items Related to this Order
 /*       orderItems = [
            SELECT Id, Product2.Name, UnitPrice, Quantity, TotalPrice 
            FROM OrderItem 
            WHERE OrderId = :invoice.Order__c
        ];
   */
    }
}