/**
 * Created by ociszek001 on 02.05.2019.
 */

trigger ServiceTrigger on Service__c (after insert, after update, after delete) {

    Set<Id> invoiceIdList = new Set<Id>();
    for(Service__c ser:Trigger.New){
        invoiceIdList.add(ser.Invoice__c);
    }

    Map<Id,Decimal> invoiceWithVatMap = new Map<Id,Decimal>();
    for (AggregateResult ar:[SELECT SUM(VAT_Amount__c) sumAmount, Invoice__c FROM Service__c Where Invoice__c=: invoiceIdList GROUP BY Invoice__c]){
        invoiceWithVatMap.put((Id)ar.get('Invoice__c'),(Decimal)ar.get('sumAmount'));
    }

    List<Invoice__c> invoices = [SELECT Id, VAT_Total__c from Invoice__c WHERE Id=: invoiceWithVatMap.keySet()];
    for (Invoice__c inv:invoices){
        if(invoiceWithVatMap.containsKey(inv.Id)){
            inv.VAT_Total__c=invoiceWithVatMap.get(inv.Id);
        }
    }
    update invoices;
}