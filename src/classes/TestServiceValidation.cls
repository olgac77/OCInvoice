/**
 * Created by ociszek001 on 22.05.2019.
 */
@isTest
private class TestServiceValidation {

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
    static void TestUnpaidStatus() {
        User u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        List <Service__c> ser = new List<Service__c>();
        System.runAs(u) {
            ser = [SELECT Net_Price__c FROM Service__c LIMIT 1];
            Test.startTest();
            ser.get(0).Net_Price__c = 3000;
            update ser;
            ser = [SELECT Net_Price__c from Service__c WHERE Id = :ser.get(0).Id];
            Test.stopTest();
        }
        System.assertEquals(false, ser.isEmpty());
        System.assertEquals(3000, ser.get(0).Net_Price__c);
    }

    @isTest
    static void TestPaidStatusUpdate() {
        User u = [SELECT Id from User WHERE UserName = :TestDataClass.userName];
        System.runAs(u) {
            Invoice__c invoice = [SELECT Id, Status__c FROM Invoice__c LIMIT 1];
            invoice.Status__c = 'Paid';
            Test.startTest();
            update invoice;
            List<Service__c> ser = [SELECT Invoice__c,Net_Price__c FROM Service__c WHERE Invoice__c = :invoice.Id];
            ser.get(0).Net_Price__c = 3000;
            try {
                ServiceValidation.validateService(ser);
            } catch (OCInvoiceException e) {
                System.assertEquals('Adding/Editing/Deleting service impossible while invoice in "Paid" status', e.getMessage());
            }
            Test.stopTest();
        }
    }
    @isTest
    static void TestPaidStatusAdd() {
        User u = [SELECT Id from User WHERE UserName = :TestDataClass.userName];
        System.runAs(u) {
            Invoice__c invoice = [SELECT Id, Status__c FROM Invoice__c LIMIT 1];
            invoice.Status__c = 'Paid';
            VAT__c vat = [SELECT Id from VAT__c LIMIT 1];
            Test.startTest();
            update invoice;
            List<Service__c> ser = new List<Service__c>();
            Service__c newSer = new Service__c(Name_of_service__c = 'Usługa', Net_Price__c = 100, Unit__c = 'Pcs', Quantity__c = 1, VAT__c = vat.Id, Invoice__c = invoice.Id);
            ser.add(newSer);
            try {
                ServiceValidation.validateService(ser);
            } catch (OCInvoiceException e) {
                System.assertEquals('Adding/Editing/Deleting service impossible while invoice in "Paid" status', e.getMessage());
            }
            Test.stopTest();
        }
    }

    @isTest
    static void TestPaidStatusDelete() {
        User u = [SELECT Id from User WHERE UserName = :TestDataClass.userName];
        System.runAs(u) {
            List<Invoice__c> invoice = [SELECT Id, Status__c FROM Invoice__c LIMIT 1];
            invoice.get(0).Status__c = 'Paid';
            Test.startTest();
            update invoice;
            List<Service__c> ser = [SELECT Id, Invoice__c FROM Service__c WHERE Invoice__c = :invoice.get(0).Id];
            ser.remove(0);
            try {
                ServiceValidation.validateService(ser);
            } catch (OCInvoiceException e) {
                System.assertEquals('Adding/Editing/Deleting service impossible while invoice in "Paid" status', e.getMessage());
            }
            Test.stopTest();
        }
    }

    @isTest
    static void serviceUpdate() {
        User u = [SELECT Id from User WHERE UserName = :TestDataClass.userName];
        List <Service__c> ser = new List <Service__c>();
        System.runAs(u) {
            ser = [SELECT Id, Net_Price__c, Invoice__c FROM Service__c LIMIT 1];
            ser.get(0).Net_Price__c = 0;
            Test.startTest();
            update ser;
            ser = [SELECT Id, Net_Price__c FROM Service__c WHERE Id = :ser.get(0).Id];
            Test.stopTest();
        }
        System.assertEquals(0, ser.get(0).Net_Price__c);
    }

    @isTest
    static void serviceDelete() {
        User u = [SELECT Id from User WHERE UserName = :TestDataClass.userName];
        List<Service__c> services = new List<Service__c>();
        System.runAs(u) {
            List<Service__c> ser = [SELECT ID from Service__c];
            Test.startTest();
            delete ser;
            Test.stopTest();
            services = [SELECT Id, Net_Price__c from Service__c];
        }
        System.assertEquals(true, services.isEmpty());
    }
}