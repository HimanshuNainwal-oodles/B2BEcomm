@isTest
private class OppProcessorTest {
    
    @testSetup
    static void setUp(){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i = 0; i< 200; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test'+i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            oppList.add(opp);
        }
        insert oppList;
    }
    
    
    @isTest
    static void testBatch(){
        
        List<Opportunity> updatedOpp = [SELECT Id FROM Opportunity];
        System.assertEquals(200, updatedOpp.size());
    }
    
    @isTest
    static void testBatch2(){
        
        
        
        Test.startTest();
        OppProcessor oppProcessor = new OppProcessor();
        Id batchId = Database.executeBatch(oppProcessor, 200);
        Test.stopTest();
        
        List<Opportunity> updatedOpp = [SELECT Id FROM Opportunity WHERE LeadSource = 'Web'];
        System.assertEquals(200, updatedOpp.size());
        
        
        
    }
}