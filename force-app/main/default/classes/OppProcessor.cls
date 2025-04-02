public class OppProcessor implements Database.Batchable<sObject>, Database.stateful {
    
    public integer recordCount = 0;

    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator([SELECT Id , LeadSource, CloseDate FROM Opportunity]);
    }
    
    public void execute(Database.BatchableContext context, List<Opportunity> oppList){
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                opp.LeadSource = 'Web';
            }
            
            update oppList;
            recordCount += oppList.Size();
        }
    }
    public void finish(Database.BatchableContext context){
        System.debug('Total Record Processed: ' + recordCount);
    }
    
}