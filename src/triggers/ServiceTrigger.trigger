/**
 * Created by ociszek001 on 02.05.2019.
 */

trigger ServiceTrigger on Service__c (after insert, after update, after delete) {


    for (Service__c service:Trigger.New){
        Id parentId = service.Invoice__c;
        Decimal vatSum = 0.00;
        List <AggregateResult>groupedResults = [SELECT SUM(VAT_Amount__c) sumAmount FROM Service__c Where Invoice__c=: parentId ];

        for (AggregateResult ar : groupedResults) {
            vatSum = (Decimal)ar.get('sumAmount');
        }
        List<Invoice__c> invoices = [SELECT Id, VAT_Total__c from Invoice__c WHERE Id=: parentId];
        if(!invoices.isEmpty()){
            for(Invoice__c invoice: invoices){
                invoice.VAT_Total__c = vatSum;
            }
            update invoices;
        }

    }


}