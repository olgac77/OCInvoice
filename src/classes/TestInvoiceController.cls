/**
 * Created by ociszek001 on 28.05.2019.
 */

@IsTest
private class TestInvoiceController {
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
    static void testGetInvoice() {
        List<User> u = [SELECT Id from User where Username = :TestDataClass.userName];
        Invoice__c invoice = new Invoice__c();
        List<Invoice__c> inv = new List<Invoice__c>();
        System.runAs(u.get(0)) {
            Test.startTest();
            inv = [SELECT Id from Invoice__c LIMIT 1];
            PageReference invoicePage = Page.Invoice;
            Test.setCurrentPage(invoicePage);
            ApexPages.currentPage().getParameters().put('invId', inv.get(0).Id);
            InvoiceController invC = new InvoiceController();
            invoice = invC.getInvoice();
            Test.stopTest();
        }
        System.assertEquals('Unpaid', invoice.Status__c);
    }

    @isTest
    static void testGetLogos() {
        List<User> u = [SELECT Id from User where Username = :TestDataClass.userName];
        ContentDocumentLink cdl = new ContentDocumentLink();
        Test.startTest();
        /*Account acc = new Account(Name = 'TestTest4', NIP__c = '115-111-11-11', Phone = '113', BillingPostalCode = '12-542');
        insert acc;*/
        List<Account> acc = [SELECT Id from Account];
        ContentVersion cv = TestDataClass.insertContentVersion();
        insert cv;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.get(0).Id;
        cdl.ContentDocumentId = documents.get(0).Id;
        cdl.shareType = 'V';
        insert cdl;
        Test.stopTest();
        String logoURL;
        String env;
        System.runAs(u.get(0)) {
            InvoiceController invC = new InvoiceController();
            logoURL = invC.getLogos(acc.get(0).Id);
            env = URL.getSalesforceBaseUrl().toExternalForm();
        }
        System.assertEquals(env + '/sfc/servlet.shepherd/document/download/' + cdl.ContentDocumentId, logoURL);
    }
}