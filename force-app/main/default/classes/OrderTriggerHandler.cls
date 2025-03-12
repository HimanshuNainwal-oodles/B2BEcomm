public class OrderTriggerHandler {
    
    public static void createInvoice(List<Order> orderList, Map<Id, Order> orderMap){
        List<OrderInvoice__c> invoice = new List<OrderInvoice__c>();
       //

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
        for (OrderItem item : orderItems) {
            productIds.add(item.Product2Id);
        }

        List<Inventory__c> inventoryList = [SELECT Id, Product__c, Available_Quantity__c FROM Inventory__c WHERE Product__c IN :productIds];

        for (Inventory__c inv : inventoryList) {
            inventoryMap.put(inv.Product__c, inv);
        }

        for(Order ord: orderList){
            Order oldOrder = orderMap.get(ord.Id);
            if(ord.Status == 'Activated' && oldOrder.Status != 'Activated'){
                Boolean isInventorySufficient = true;
                Decimal totalAmount = 0;
                List<Inventory__c> updatedInventoryList = new List<Inventory__c>();
    
                orderIds.add(ord.Id);
            }
        }

        if(!invoice.isEmpty()){
            insert invoice;
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
    }
}