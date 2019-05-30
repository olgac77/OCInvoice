/**
 * Created by ociszek001 on 21.05.2019.
 */
@isTest
private class TestAmountToText {

    @TestSetup
    static void loadData() {
        List<User> u = TestDataClass.insertUser();
        List<Invoice__c> inv = new List<Invoice__c>();
        List<Service__c> ser = new List<Service__c>();
        System.runAs(u.get(0)) {
            Test.startTest();
            VAT__c vat = TestDataClass.insertVat();
            inv = TestDataClass.loadInvoices();
            ser = TestDataClass.insertServices(new List<VAT__c>{
                    vat
            }, inv);
            Test.stopTest();
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals(false,inv.isEmpty());
    }
    @isTest
    static void testAmountToText() {
        List<User> u = [SELECT Id from User WHERE userName = :TestDataClass.userName];
        List<Invoice__c> inv = new List <Invoice__c>();
        List<Service__c> ser = new List<Service__c>();
        System.runAs(u.get(0)) {
            Test.startTest();
            ser = [SELECT Id, Invoice__c, Net_Price__c from Service__c];
            inv = [SELECT Amount_in_words__c,Gross_Total__c, (Select Id, Net_Price__c from Services__r) FROM Invoice__c WHERE id = :ser.get(0).Invoice__c];
            Test.stopTest();
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals('sześćset piętnaście PLN 0/100', inv.get(0).Amount_in_words__c);
    }

    @isTest
    static void testAmount0toText() {
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        List<Invoice__c> inv = new List <Invoice__c>();
        List<Service__c> ser = new List<Service__c>();
        System.runAs(u.get(0)) {
            Test.startTest();
            ser = [SELECT Id, Net_Price__c, Invoice__c FROM Service__c];
            for (Service__c s : ser) {
                s.Net_Price__c = 0;
            }
            update ser;
            inv = [SELECT Gross_Total__c, Amount_in_words__c FROM Invoice__c WHERE id = :ser.get(0).Invoice__c];
            System.assertEquals(true, Schema.sObjectType.Invoice__c.fields.Amount_in_words__c.isAccessible());
            Test.stopTest();
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals('zero PLN 0/100', inv.get(0).Amount_in_words__c);
    }

    @isTest
    static void testNegativeAmountToText() {
        List<User> u = [SELECT Id from User WHERE Alias = 'newuser'];
        List<Invoice__c> inv = new List <Invoice__c>();
        List<Service__c> ser = new List<Service__c>();
        System.runAs(u.get(0)) {
            Test.startTest();
            ser = [SELECT Id, Invoice__c, Net_Price__c FROM Service__c];
            for (Service__c s : ser) {
                s.Net_Price__c = -1256060;
            }
            update ser;
            inv = [SELECT Amount_in_words__c,Gross_Total__c FROM Invoice__c WHERE id = :ser.get(0).Invoice__c];
            Test.stopTest();
        }
        System.assertEquals(false, inv.isEmpty());
        System.assertEquals('minus cztery miliony sześćset trzydzieści cztery tysiące osiemset sześćdziesiąt jeden PLN 40/100', inv.get(0).Amount_in_words__c);
    }
}