/**
 * Created by ociszek001 on 28.05.2019.
 */

@IsTest
private class TestNetCalculation {
    @TestSetup
    static void loadInvoices() {
        User u = TestDataClass.insertUser();
        List<Invoice__c> inv = new List<Invoice__c>();
        System.runAs(u) {
            Test.startTest();
            VAT__c vat = TestDataClass.insertVat();
            inv = TestDataClass.loadInvoices();
            List<Service__c> ser = TestDataClass.insertServices(new List<VAT__c>{
                    vat
            }, inv);
            Test.stopTest();
        }
        System.assertEquals(false, inv.isEmpty());
    }

    @isTest
    static void NetAfterDelete() {
        User u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        Invoice__c inv = new Invoice__c();
        List<Service__c> ser = [SELECT Id, Invoice__c FROM Service__c];
        System.runAs(u) {
            Test.startTest();
            delete ser;
            List<Service__c> serAfter = [SELECT Id, Invoice__c FROM Service__c];
            inv = [SELECT Id, Net_Total__c FROM Invoice__c LIMIT 1];
            Test.stopTest();
        }
        System.assertEquals(0, inv.Net_Total__c);
    }

    @isTest
    static void NetAfterUpdate() {
        List<Invoice__c> inv = [SELECT Id, Gross_Total__c FROM Invoice__c];
        User u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        System.runAs(u) {
            Test.startTest();
            List<Service__c> ser = [SELECT Id, Invoice__c,Net_Price__c from Service__c WHERE Invoice__c = :inv.get(0).Id];
            for (Service__c s : ser) {
                s.Net_Price__c = 0;
            }
            update ser;
            Test.stopTest();
            inv = [SELECT Id, Net_Total__c FROM Invoice__c WHERE id = :inv.get(0).Id];
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(0, inv.get(0).Net_Total__c);
    }

    @isTest
    static void NetAfterInsert() {
        List<Invoice__c> inv = [SELECT Id, Gross_Total__c FROM Invoice__c];
        User u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        System.runAs(u) {
            Test.startTest();
            List<Service__c> ser = [SELECT Id, Invoice__c,Gross_Amount__c from Service__c WHERE Invoice__c = :inv.get(0).Id];
            Test.stopTest();
            inv = [SELECT Id, Net_Total__c FROM Invoice__c];
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(500, inv.get(0).Net_Total__c);
    }
}