public class DailyOppProcessor implements Schedulable {
    
    public void execute(SchedulableContext context){
        List<Opportunity> oppList = [SELECT Id, LeadSource FROM Opportunity WHERE LeadSource = null Limit 200];
        
        for(Opportunity opp : oppList){
            opp.LeadSource = 'Web';
        }
        if(!oppList.isEmpty())
            update oppList;
        
        
    }
}