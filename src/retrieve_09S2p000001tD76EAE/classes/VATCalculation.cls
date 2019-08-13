//Created by ociszek001 on 06.05.2019.
public with sharing class VATCalculation {

    public static void calculateVAT(List <Service__c> ser, String triggerOperation) {
        Set<Id> invoiceIdList = new Set<Id>();
        for (Service__c s : ser) {
            invoiceIdList.add(s.Invoice__c);
        }
        Map<Id, Decimal> invoiceWithVatMap = new Map<Id, Decimal>();
        if ('AFTER_DELETE'.equals(triggerOperation)) {
            for (Id invoiceId : invoiceIdList) {
                invoiceWithVatMap.put(invoiceId, 0);
            }
        }
        for (AggregateResult ar : [SELECT SUM(VAT_Amount__c) sumAmount, Invoice__c FROM Service__c WHERE Invoice__c = :invoiceIdList GROUP BY Invoice__c]) {
            if (ar.get('Invoice__c') != null && ar.get('sumAmount') != null) {
                invoiceWithVatMap.put((Id) ar.get('Invoice__c'), (Decimal) ar.get('sumAmount'));
            }
        }
        List<Invoice__c> invoices = [SELECT Id, VAT_Total__c from Invoice__c WHERE Id = :invoiceWithVatMap.keySet()];
        if (invoices != null || !invoices.isEmpty()) {
            for (Invoice__c inv : invoices) {
                if (invoiceWithVatMap.containsKey(inv.Id)) {
                    inv.VAT_Total__c = invoiceWithVatMap.get(inv.Id);
                }
            }
            update invoices;
        }
    }
}