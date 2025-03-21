public class ReturnOrderTriggerHandler {
    public static void onAfterUpdate(List<ReturnOrder> orderList, Map<Id, ReturnOrder> orderMap) {
        List<ReturnOrderLineItem> itemList = new List<ReturnOrderLineItem>();
        Set<Id> lineItemIds = new Set<Id>();
        for(ReturnOrder ord: orderList){ 
           System.debug(ord);
        }
    }
}