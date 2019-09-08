public with sharing class InvConfirmation {
   
    @AuraEnabled    
    public static void unmarkAsDraft(Id invoiceId){
        update new Invoice__c(Id = invoiceId, Draft__c = False);
    }
}