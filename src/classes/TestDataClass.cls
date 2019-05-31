/**
 * Created by ociszek001 on 21.05.2019.
 */
@isTest
public with sharing class TestDataClass {
    public static final String userName = 'devkama23052019@test.com';

    public static List<Invoice__c> loadInvoices() {
        List<sObject>inv = Test.loadData(Invoice__c.getSObjectType(), 'TestData');
        return inv;
    }

    public static List <Service__c> insertServices(List<VAT__c> vats, List<Invoice__c> invoices) {
        List<Service__c> services = new List <Service__c>();
        for (Invoice__c ic : invoices) {
            for (Integer i = 1; i < 3; i++) {
                Service__c ser = new Service__c(Name_of_service__c = 'Usługa', Net_Price__c = 100 * i, Unit__c = 'Pcs',
                        Quantity__c = 1 * i, VAT__c = vats.get(0).Id, Invoice__c = ic.Id);
                services.add(ser);
            }
        }
        insert services;
        return services;
    }

    public static VAT__c insertVat() {
        VAT__c vat = new VAT__c(Name = '23%', Value__c = 0.23);
        insert vat;
        return vat;
    }

    public static ContentDocumentLink insertContent() {
        Account acc = new Account(Name = 'TestTest', NIP__c = '111-111-11-11', Phone = '123', BillingPostalCode = '12-542');
        insert acc;
        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.id;
        cdl.ContentDocumentId = documents.get(0).Id;
        cdl.shareType = 'V';
        insert cdl;
        return cdl;
    }

    public static List<User> insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'OCInvoice User'];
        List<User> u = new List<User>{new User (Alias = 'newUser', Email = 'newuser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'pl',
                LocaleSidKey = 'pl_PL', ProfileId = p.Id,
                TimeZoneSidKey = 'Europe/Prague', UserName = userName)};
        insert u;
        return u;
    }

    public static ContentVersion insertContentVersion(){
        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
                return contentVersion;
    }
}