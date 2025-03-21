trigger OpportunityContractTrigger on Opportunity (after update) {

    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            OpportunityContractTriggerHandler.createContract(Trigger.New, Trigger.OldMap);
        }
    }
}