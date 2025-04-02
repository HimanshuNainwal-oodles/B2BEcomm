public class ContractTriggerHandler {
    
    public static void createContractPdf(List<Contract> contractList, Map<Id, Contract> oldContractMap){
        Set<Id> contractIds = new Set<Id>();
        for(Contract con: contractList){
            if(con.Status == 'Activated'){
                contractIds.add(con.Id);
                System.debug(con.ContractNumber);
                
            }
        }
        if(!contractIds.isEmpty()){
            createContract(contractIds);
        }
        else{
            
        }
    }
    
    @Future(callout=true)
    public static void createContract(Set<Id> contractIds){
        Contract con = [SELECT Id, ContractNumber from Contract WHERE Id IN :contractIds];
        System.debug(con);
        PageReference page = Page.ContractPdf;
        page.getParameters().put('id', con.Id);
        Blob pageblob = page.getContent();
        
        Attachment attachment = new Attachment(
            Name = 'Contract_'+con.ContractNumber+'.pdf',
            Body = pageblob,
            ContentType = 'application/pdf',
            ParentId = con.Id);
        insert attachment;
        
    }
}