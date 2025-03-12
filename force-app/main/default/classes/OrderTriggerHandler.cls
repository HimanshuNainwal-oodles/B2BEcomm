public class OrderTriggerHandler {
    
    public static void createInvoice(List<Order> orderList, Map<Id, Order> orderMap){
        List<OrderInvoice__c> invoice = new List<OrderInvoice__c>();
        
        for(Order ord: orderList){
            Order oldOrder = orderMap.get(ord.Id);
            System.debug('invoice creation: '+ ord);
            if(ord.Status == 'Activated' && oldOrder.Status != 'Activated'){
                OrderInvoice__c inv = new OrderInvoice__c();
                inv.Order__c = ord.Id;
                inv.Status__c = 'Pending';
                invoice.add(inv);
            }
        }
        if(!invoice.isEmpty()){
            insert invoice;
        }
    }
}