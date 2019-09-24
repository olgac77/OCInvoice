global class ReminderProcessor  implements Database.Batchable<sObject>, Database.Stateful{
    
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator ('SELECT Id, Draft__c, Due_date__c, Email_Sent__c, Account__r.Email__c, Seller__r.Company_Name__c FROM Invoice__c WHERE Status__c = \'Unpaid\'');
    }
    
    global void execute (Database.BatchableContext bc, List<Invoice__c> scope){
        List<Notify_Purchaser__c> nfList = new List <Notify_Purchaser__c>();		      
        for(Invoice__c inv : scope){
            if((!inv.Draft__c) && System.today()>inv.Due_date__c){
                nfList.add(new Notify_Purchaser__c(Invoice__c=inv.Id, Email__c=inv.Account__r.Email__c, Seller_Name__c=inv.Seller__r.Company_Name__c));
                recordsProcessed = recordsProcessed + 1;
            }
        }
        insert nfList;        
    }

    global void finish(Database.BatchableContext bc){     
        system.debug(recordsProcessed+ ' records processed');       
    } 
}