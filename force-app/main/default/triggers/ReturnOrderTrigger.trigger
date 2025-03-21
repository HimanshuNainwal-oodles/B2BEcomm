trigger ReturnOrderTrigger on ReturnOrder (after update) {
	if(Trigger.isAfter){
        if(Trigger.isUpdate){
            ReturnOrderTriggerHandler.onAfterUpdate(trigger.new, trigger.oldMap);
        }    
    }
}