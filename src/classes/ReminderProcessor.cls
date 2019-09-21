global class ReminderProcessor  implements Database.Batchable<sObject>, Database.Stateful{
        
    global Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator ('SELECT Id, Draft__c, Due_date__c, Email_Sent__c, Account__r.Email__c, Seller__r.Company_Name__c FROM Invoice__c WHERE Status__c = \'Unpaid\'');
    }
    
    global void execute (Database.BatchableContext bc, List<Invoice__c> scope){
	List<Notify_Purchaser__c> nfList = new List <Notify_Purchaser__c>();		      
        if(scope!=null || !scope.isEmpty()){
            for(Invoice__c inv : scope){
                system.debug(inv.Draft__c==false);
                if((inv.Draft__c==false) && System.today()>inv.Due_date__c){
                    nfList.add(new Notify_Purchaser__c(Invoice__c=inv.Id, Email__c=inv.Account__r.Email__c, Seller_Name__c=inv.Seller__r.Company_Name__c));				                   
                }
            }
        }
        insert nfList;        
    }
    global void finish(Database.BatchableContext bc){       
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        system.debug(job);       
    } 
}