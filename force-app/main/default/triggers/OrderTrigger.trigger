trigger OrderTrigger on Order (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            OrderTriggerHandler.createInvoice(Trigger.New, Trigger.oldMap);
        }
    }
    
}