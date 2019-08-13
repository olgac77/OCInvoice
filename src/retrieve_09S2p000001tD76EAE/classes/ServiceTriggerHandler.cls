/*
 * Created by ociszek001 on 08.05.2019.
 */


public with sharing class ServiceTriggerHandler {
    final List<Service__c> newRecords;
    final List<Service__c> oldRecords;

    public ServiceTriggerHandler(List<Service__c> newRecords, List<Service__c> oldRecords) {
        this.newRecords = newRecords;
        this.oldRecords = oldRecords;
    }

    public void afterInsert() {
        NetCalculation.calculateNet(newRecords,trigger.operationType.name());
        VATCalculation.calculateVAT(newRecords,trigger.operationType.name());
        GrossCalculation.calculateGross(newRecords, trigger.operationType.name());
        AmountToText.showAmountAsText(newRecords);
    }

    public void afterUpdate() {
        NetCalculation.calculateNet(newRecords, trigger.operationType.name());
        VATCalculation.calculateVAT(newRecords,trigger.operationType.name());
        GrossCalculation.calculateGross(newRecords, trigger.operationType.name());
        AmountToText.showAmountAsText(newRecords);
    }

    public void afterDelete() {
        NetCalculation.calculateNet(oldRecords, trigger.operationType.name());
        VATCalculation.calculateVAT(oldRecords,trigger.operationType.name());
        GrossCalculation.calculateGross(oldRecords, trigger.operationType.name());
        AmountToText.showAmountAsText(oldRecords);
    }
    public void beforeInsert() {
        ServiceValidation.validateService(newRecords);
    }
    public void beforeUpdate() {
        ServiceValidation.validateService(newRecords);
    }
    public void beforeDelete() {
        ServiceValidation.validateService(oldRecords);
    }
}