public class UpdateParentAccount implements Queueable{
    
    private List<Account> accList;
    
    private Id parentAccId;
    
    public UpdateParentAccount(List<Account> accRecord, Id accId){
        this.parentAccId = accId;
        this.accList = accRecord;
    }
    
    public void execute(QueueableContext context){
        for(Account acc: accList){
            acc.ParentId = parentAccId;
        }
        
        update accList;
        
    }
    
}