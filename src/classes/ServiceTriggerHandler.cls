/*
 * Created by ociszek001 on 08.05.2019.
 */


public with sharing class ServiceTriggerHandler {
    final List<Service__c> newRecords;

    public ServiceTriggerHandler(List<Service__c> newRecords) {
        this.newRecords = newRecords;
    }

    public void afterInsert() {
        NetCalculation.calculateNet(newRecords);
        VATCalculation.calculateVAT(newRecords);
        GrossCalculation.calculateGross(newRecords);
        AmountToText.showAmountAsText(newRecords);
    }

    public void afterUpdate(){
        NetCalculation.calculateNet(newRecords);
        VATCalculation.calculateVAT(newRecords);
        GrossCalculation.calculateGross(newRecords);
        AmountToText.showAmountAsText(newRecords);
    }

    public void afterDelete(){
        NetCalculation.calculateNet(newRecords);
        VATCalculation.calculateVAT(newRecords);
        GrossCalculation.calculateGross(newRecords);
        AmountToText.showAmountAsText(newRecords);
    }
    public void beforeInsert() {
        ServiceValidation.validateService(newRecords);
    }
    public void beforeUpdate() {
        ServiceValidation.validateService(newRecords);
    }
    public void beforeDelete() {
        ServiceValidation.validateService(newRecords);
    }
}