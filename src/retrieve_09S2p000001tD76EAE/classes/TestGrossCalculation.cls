/**
 * Created by ociszek001 on 22.05.2019.
 */
@isTest
private class TestGrossCalculation {

    @TestSetup
    static void loadData() {
        List<User> u = TestDataClass.insertUser();
        List<Invoice__c> inv = new List<Invoice__c>();
        System.runAs(u.get(0)) {
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
    static void TestGrossAfterInsert() {
        List<Invoice__c> inv = [SELECT Id, Gross_Total__c FROM Invoice__c];
        List<User> u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        System.runAs(u.get(0)) {
            Test.startTest();
            List<Service__c> ser = [SELECT Id, Invoice__c,Gross_Amount__c from Service__c WHERE Invoice__c = :inv.get(0).Id];
            Test.stopTest();
            inv = [SELECT Id, Gross_Total__c FROM Invoice__c];
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(true, inv.get(0).Gross_Total__c != null);
    }

    @isTest
    static void TestGrossAfterUpdate() {
        List<Invoice__c> inv = [SELECT Id, Gross_Total__c FROM Invoice__c];
        List<User> u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        System.runAs(u.get(0)) {
            Test.startTest();
            List<Service__c> ser = [SELECT Id, Invoice__c,Net_Price__c from Service__c WHERE Invoice__c = :inv.get(0).Id];
            for (Service__c s : ser) {
                s.Net_Price__c = 0;
            }
            update ser;
            Test.stopTest();
            inv = [SELECT Id, Gross_Total__c FROM Invoice__c WHERE id = :inv.get(0).Id];
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(0, inv.get(0).Gross_Total__c);
    }

    @isTest
    static void TestGrossAfterDelete() {
        List<Invoice__c> invoicesBeforeDelete = new List<Invoice__c>();
        List<Service__c> serBeforeDelete = new List<Service__c>();
        List<Invoice__c> inv = new List <Invoice__c>();
        List<User> u = [SELECT Id FROM User WHERE UserName = :TestDataClass.userName];
        System.runAs(u.get(0)) {
            Test.startTest();
            serBeforeDelete = [SELECT Id, Invoice__c,Net_Price__c, Gross_Amount__c from Service__c LIMIT 1];
            invoicesBeforeDelete = [SELECT Id, Gross_Total__c FROM Invoice__c WHERE id = :serBeforeDelete.get(0).Invoice__c];
            delete serBeforeDelete.get(0);
            Test.stopTest();
            inv = [SELECT Id, Gross_Total__c FROM Invoice__c WHERE id = :serBeforeDelete.get(0).Invoice__c];
        }
        System.assertEquals(false, invoicesBeforeDelete.isEmpty());
        System.assertEquals(false, serBeforeDelete.isEmpty());
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(invoicesBeforeDelete.get(0).Gross_Total__c - serBeforeDelete.get(0).Gross_Amount__c, inv.get(0).Gross_Total__c);
    }
}