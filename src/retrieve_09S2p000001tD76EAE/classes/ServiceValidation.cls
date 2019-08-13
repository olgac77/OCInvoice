/**
 * Created by ociszek001 on 19.05.2019.
 */

public with sharing class ServiceValidation {

    public static void validateService(List<Service__c> ser) {
        Set<Id> invoiceIdList = new Set<Id>();
        for (Service__c s : ser) {
            invoiceIdList.add(s.Invoice__c);
        }
        List<Invoice__c> invoices = [SELECT Id, Status__c FROM Invoice__c WHERE Id = :invoiceIdList];
        if (invoices != null || !invoices.isEmpty()) {
            for (Invoice__C inv : invoices) {
                if ('Paid'.equals(inv.Status__c)) {
                    throw new OCInvoiceException('Adding/Editing/Deleting service impossible while invoice in "Paid" status');
                }
            }
        }
    }
}