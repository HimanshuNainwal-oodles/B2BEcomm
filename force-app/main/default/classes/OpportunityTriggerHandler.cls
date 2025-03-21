public class OpportunityTriggerHandler {
    
     
    public static void createInvoice(List<Opportunity> oppList){
        
        List<OrderInvoice__c> oInvList = new List<OrderInvoice__c>();
        
        for(Opportunity opp: oppList){
            OrderInvoice__c oInv = new OrderInvoice__c();
            oInv.Status__c = 'Pending';
            oInv.Opportunity__c = opp.Id;
            oInvList.add(oInv);
            
        }
        
        if(!oInvList.isEmpty()){
            insert oInvList;
        }
    }    
}