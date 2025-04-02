@isTest
private class DailyOppProcessorTest {
    
    
    
    @isTest
    private static void testScheduleApex(){
        
        String sch = '0 0 0 ? * * *';
        
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i = 0; i<500; i++){
            if(i<250){
                oppList.add(new Opportunity(Name ='Test'+i, StageName = 'Prospecting', CloseDate = System.today()));
            }else{
                oppList.add(new Opportunity(Name ='Test'+i, StageName = 'Prospecting', CloseDate = System.today(), LeadSource = 'Email'));
            }
        }
        insert oppList;
        
        Test.startTest();
        System.schedule('Process Opp', sch, new DailyOppProcessor());	
        Test.stopTest();
        
        List<Opportunity> updatedOpp = [SELECT Id , LeadSource FROM Opportunity Where LeadSource = 'Web'];
        
        System.assertEquals(200, updatedOpp.size());
        
    }
}