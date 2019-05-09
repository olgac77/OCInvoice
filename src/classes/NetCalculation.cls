/**
 * Created by ociszek001 on 08.05.2019.
 */

public with sharing class NetCalculation {

    public static void calculateNet(List <Service__c> ser) {
        Set<Id> invoiceIdList = new Set<Id>();
        for (Service__c s : ser) {
            invoiceIdList.add(s.Invoice__c);
        }
        Map<Id, Decimal> invoiceWithVatMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [SELECT SUM(Net_Amount__c) sumAmount, Invoice__c FROM Service__c WHERE Invoice__c = :invoiceIdList GROUP BY Invoice__c]) {
            if(ar.get('Invoice__c')!=null&&ar.get('sumAmount')!=null){
                invoiceWithVatMap.put((Id) ar.get('Invoice__c'), (Decimal) ar.get('sumAmount'));
            }
        }
        List<Invoice__c> invoices = [SELECT Id, Net_Total__c from Invoice__c WHERE Id = :invoiceWithVatMap.keySet()];
        if(!invoices.isEmpty()||invoices!=null){
            for (Invoice__c inv : invoices) {
                if (invoiceWithVatMap.containsKey(inv.Id)) {
                    inv.Net_Total__c = invoiceWithVatMap.get(inv.Id);
                }
            }
            update invoices;
        }
    }
}