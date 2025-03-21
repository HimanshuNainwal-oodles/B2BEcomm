public class OrderTriggerHandler {
    
    public static void createInvoice(List<Order> orderList, Map<Id, Order> orderMap){
        
        List<OrderInvoice__c> invoiceList = new List<OrderInvoice__c>();
        
        
        Map<Id, Inventory__c> inventoryMap = new Map<Id, Inventory__c>();
        
        Set<Id> orderIds = new Set<Id>();
        for(Order ord: orderList){
            Order oldOrder = orderMap.get(ord.Id);
            if(ord.Status == 'Activated' && oldOrder.Status != 'Activated'){
                orderIds.add(ord.Id);
            }
        }
        if(orderIds.isEmpty()) return;
        List<orderItem> orderItem = [SELECT Id, OrderId, Product2Id,  Quantity FROM OrderItem WHERE OrderId IN :orderIds];
        
        Set<Id> productIds = new Set<Id>();
        for (OrderItem item : orderItem) {
            productIds.add(item.Product2Id);
        }
        
        List<Inventory__c> inventoryList = [SELECT Id, Product__c, Stock_Quantity__c FROM Inventory__c WHERE Product__c IN :productIds];
        
        for (Inventory__c inv : inventoryList) {
            inventoryMap.put(inv.Product__c, inv);
        }
        
        for(Order ord: orderList){
            Order oldOrder = orderMap.get(ord.Id);
            if(ord.Status == 'Activated' && oldOrder.Status != 'Activated'){
                
                Boolean isInventorySufficient = true;
                Decimal totalAmount = 0;
                List<Inventory__c> updatedInventoryList = new List<Inventory__c>();
                for (OrderItem item : orderItem) {
                    if (item.OrderId == ord.Id) {
                        Inventory__c inv = inventoryMap.get(item.Product2Id);
                        
                        if (inv == null || inv.Stock_Quantity__c < item.Quantity) {
                            isInventorySufficient = false;
                            ord.addError('Insufficient inventory for Product');
                            System.debug('Insufficient inventory for Product: ' + item.Product2Id);
                            break;
                        }
                        
                        // Reduce inventory for confirmed orders
                        //inv.Stock_Quantity__c -= item.Quantity;
                        //updatedInventoryList.add(inv);
                        
                        //totalAmount += item.Quantity * item.UnitPrice;
                    }
                }
                if (isInventorySufficient) {
                    OrderInvoice__c inv = new OrderInvoice__c();
                    inv.Order__c = ord.Id;
                    inv.Status__c = 'Pending';
                    inv.Opportunity__c = ord.OpportunityId;
                    invoiceList.add(inv);
                    System.debug(inv+': result invoice');
                    // Update inventory
                    // if (!updatedInventoryList.isEmpty()) {
                    //   update updatedInventoryList;
                    //}
                }
            }
        }
        if (!invoiceList.isEmpty()) {
            try {
                insert invoiceList;
                System.debug('Invoices successfully created: ' + invoiceList);
                Set<Id> invoiceIds = new Set<Id>();
                for (OrderInvoice__c inv : invoiceList) {
                    if (inv.Id != null) {
                        invoiceIds.add(inv.Id);
                    }
                }
                
                if (!invoiceIds.isEmpty()) {
                    System.debug('Sending invoice emails for: ' + invoiceIds);
                    System.enqueueJob(new SendInvoiceEmail(invoiceIds));
                    //SendInvoiceEmail.sendEmailAsync(invoiceIds);
                } else {
                    System.debug('No valid invoice IDs found, skipping email sending.');
                }
            } catch (Exception e) {
                System.debug('Error creating invoices: ' + e.getMessage());
            }
        }
        
    }
}



// for(Order ord: orderList){
//     Order oldOrder = orderMap.get(ord.Id);
//     System.debug('invoice creation: '+ ord);
//     if(ord.Status == 'Activated' && oldOrder.Status != 'Activated'){
//         OrderInvoice__c inv = new OrderInvoice__c();
//         inv.Order__c = ord.Id;
//         inv.Status__c = 'Pending';
//         invoice.add(inv);
//     }
// }
// if(!invoice.isEmpty()){
//     insert invoice;
// }