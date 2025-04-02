public class LeadConversionTriggerHandler {
    
    public static void LeadConversion(List<Lead_Tracking__c> leadList, Map<Id, Lead_Tracking__c> oldLeadMap) {
        
        List<Account_Company__c> accountsToInsert = new List<Account_Company__c>();
        List<Contact__c> contactsToInsert = new List<Contact__c>();
        List<Opportunity_Deal__c> opportunitiesToInsert = new List<Opportunity_Deal__c>();
        
        Map<Id, Account_Company__c> leadToAccount = new Map<Id, Account_Company__c>();
        for (Lead_Tracking__c lead : leadList) {
            Lead_Tracking__c oldLead = oldLeadMap.get(lead.Id);
            
            if (lead.Status__c == 'Converted' && (oldLead == null || oldLead.Status__c != 'Converted')) {
                
                // Create Account
                Account_Company__c acc = new Account_Company__c();
                acc.Name = lead.Company_Name__c;
                acc.Email__c = lead.Email__c;
                acc.Phone__c = lead.Phone__c;
                acc.Address__c = lead.Address__c;
                acc.Status__c = 'Active';
                accountsToInsert.add(acc);
                
                leadToAccount.put(lead.Id, acc);                
            } else if (oldLead != null && oldLead.Status__c == 'Converted' && lead.Status__c != 'Converted') {
                lead.addError('Converted status cannot be reverted back.');
            }
        }
        
        if (!accountsToInsert.isEmpty()) {
            insert accountsToInsert;
        }
        
        for (Lead_Tracking__c lead : leadList) {
            if (leadToAccount.containsKey(lead.Id)) {
                Account_Company__c accId = leadToAccount.get(lead.Id);
                System.debug('id: '+accId);
                
                // Create Contact
                Contact__c con = new Contact__c();
                con.Name = lead.Name;
                con.Email__c = lead.Email__c;
                con.Phone__c = lead.Phone__c;
                con.Account_Company__c = accId.Id; 
                contactsToInsert.add(con);
                
                // Create Opportunity
                Opportunity_Deal__c opp = new Opportunity_Deal__c();
                opp.Name = lead.Company_Name__c + ' - Deal';
                opp.Stage__c = 'Prospecting';
                opp.Account_Company__c = accId.Id;
                opportunitiesToInsert.add(opp);
            }
        }
        if(!contactsToInsert.isEmpty()){
			insert contactsToInsert;
        }
        if(!opportunitiesToInsert.isEmpty()){
			insert opportunitiesToInsert;
        }
    }
    
}