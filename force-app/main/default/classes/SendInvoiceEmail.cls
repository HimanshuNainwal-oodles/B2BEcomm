public class SendInvoiceEmail implements Queueable, Database.AllowsCallouts { 
    
    private Set<Id> invoiceIds;
    
    public SendInvoiceEmail(Set<Id> invoiceIds) {
        this.invoiceIds = invoiceIds;
    }
    
    public void execute(QueueableContext context) {
        Set<Id> oppIds = new Set<Id>();
        List<OrderInvoice__c> invoices = [SELECT Id, Name, Total_Amount__c, Invoice_Date__c, Order__c, Order__r.OrderNumber, Order__r.ShippingAddress,
                                          Opportunity__c, Opportunity__r.Account.Name FROM OrderInvoice__c
                                          WHERE Id IN :invoiceIds];
        
        
        
        
        for(OrderInvoice__c inv : invoices){
            String accountName = inv.Opportunity__r != null && inv.Opportunity__r.Account != null 
                ? inv.Opportunity__r.Account.Name 
                : 'No Account Found';
            System.debug('Account Name: ' + accountName);
        }
        
        //List<orderItem> orderItem = [SELECT Id, OrderId, Product2Id,  Quantity FROM OrderItem WHERE OrderId IN :orderIds];
        Set<Id> ordIds = new Set<Id>();
        for (OrderInvoice__c invoice : invoices) {
            if (invoice.Order__c != null) {
                ordIds.add(invoice.Order__c);
            }
        }
        List<OrderItem> items = [SELECT Id, OrderId, Product2Id, Product2.Name, UnitPrice, ListPrice, Quantity, TotalPrice FROM OrderItem WHERE OrderId IN:ordIds];
        Set<Id> prodIds = new Set<Id>();
        for(OrderItem it: items){
            prodIds.add(it.Product2Id);
        }
        List<Product2> prod = [SELECT Id, Name, ProductCode, Price__c FROM Product2 WHERE Id IN:prodIds];
        System.debug(prod);
        
        /*for(item: [SELECT Id, OrderId, Product2Id, Product2.Name, UnitPrice, ListPrice, Quantity, TotalPrice FROM OrderItem WHERE OrderId IN:ordIds]){
prodIds.put(item.Product2Id);
System.debug(item);
System.debug(item.Product2.Name);
}*/
        
        for (OrderInvoice__c invoice : invoices) {
            if (invoice.Opportunity__c != null) {
                oppIds.add(invoice.Opportunity__c);
            }
        }
        
        Map<Id, String> oppToContactEmail = new Map<Id, String>();
        for (OpportunityContactRole ocr : [SELECT OpportunityId, Contact.Email 
                                           FROM OpportunityContactRole 
                                           WHERE OpportunityId IN :oppIds AND IsPrimary = TRUE]) {
                                               if (ocr.Contact.Email != null) {
                                                   oppToContactEmail.put(ocr.OpportunityId, ocr.Contact.Email);
                                               }
                                           }
        
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (OrderInvoice__c invoice : invoices) {
            String contactEmail = oppToContactEmail.get(invoice.Opportunity__c);
            List<OrderItem> item = [SELECT Id, OrderId, Product2Id, Product2.Name, UnitPrice, ListPrice, Quantity, TotalPrice FROM OrderItem WHERE OrderId =:invoice.Order__c];
            String productDetails = '';
            for(OrderItem it: item){
                productDetails+= it.Product2.Name + ' Price '+ it.UnitPrice +' Quantity '+ it.Quantity+' Total Price '+it.TotalPrice+'\n';
            }
            
            if (String.isNotBlank(contactEmail)) {
                try {
                    // ✅ Ensure callouts are allowed in Queueable Apex
                    System.debug('Generating PDF for Invoice: ' + invoice.Id);
                    
                    // Generate PDF
                    PageReference pdfPage = Page.InvoicePdf;
                    pdfPage.getParameters().put('id', invoice.Id);
                    Blob pdfBlob = pdfPage.getContent(); // 
                    
                    // Attach PDF to Invoice Record
                    Attachment pdfAttachment = new Attachment(
                        Name = 'Invoice_' + invoice.Name + '.pdf',
                        Body = pdfBlob,
                        ContentType = 'application/pdf',
                        ParentId = invoice.Id
                    );
                    
                    insert pdfAttachment;
                    
                    // Create and Send Email
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new List<String>{contactEmail});
                    email.setSubject('Your Invoice ' + invoice.Name + ' is Ready');
                    email.setPlainTextBody('Dear ' + (invoice.Opportunity__r.Account.Name != null ? invoice.Opportunity__r.Account.Name : 'Customer') + ',\n\n' +
                                           'We hope you are doing well! Thank you for your recent order with us. Below are the details of your invoice:\n\n' +
                                           '📄 <h1>**Invoice Number**:</h1> ' + invoice.Name + '\n' +
                                           '📦 **Order ID**: ' + invoice.Order__c + ' (' + invoice.Order__r.OrderNumber + ')\n\n' +
                                           '🛍️ **Order Summary:**\n' +
                                           productDetails + '\n' +
                                           '💰 **Total Amount Due**: ₹' + invoice.Total_Amount__c + '\n\n' +
                                           '📎 Please find your invoice attached as a PDF.\n\n' +
                                           'If you have any questions or require further assistance, feel free to reach out to our support team.\n\n' +
                                           'Best Regards,\n' +
                                           '**B2B Ecomm Team**'
                                          );
                    
                    
                    
                    // Attach PDF to Email
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setBody(pdfBlob);
                    attachment.setFileName('Invoice_' + invoice.Name + '.pdf');
                    attachment.setContentType('application/pdf');
                    email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attachment });
                    
                    emails.add(email);
                    
                } catch (Exception e) {
                    System.debug('Error generating invoice PDF: ' + e.getMessage());
                }
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}