/**
* Created by ociszek001 on 21.05.2019.
*/
@isTest
public with sharing class TestDataClass {
    public static final String userName = 'devkama23052019@test.com';
    public static final String userAdminName = 'devkon242365432547@test.com';
    public static final String fakeInvoiceNumber = 'FV/2019/01/01';
    public static final String hoursUnit = 'Hours';
    
    public static List<Invoice__c> loadInvoices() {
        List<Account> acc = insertAccount();
        List<Seller__c> sell = insertSeller();
        List<Invoice__c> inv = new List<Invoice__c> {new Invoice__c(Issue_Place__c = 'Warszawa', Delivery_Date__c = Date.newInstance(2019, 06, 13), Seller__c = sell.get(0).Id, Issue_Date__c = Date.newInstance(2019, 06, 13), 
                                                                    Account__c = acc.get(0).Id,Payment_Terms__c = 7, Status__c = 'Unpaid', Payment__c = 'Transfer', Invoice_Number__c =fakeInvoiceNumber)};
                                                                        insert inv;
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
    
    public static ContentDocumentLink insertContent(List<Account> acc) {        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.get(0).Id;
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
    
    public static List <User> insertAdmin(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        List<User> uAdmin = new List<User>{new User(Alias = 'newAdmin', Email = 'newuserAdmin@testorg.com',
                                                    EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'pl',
                                                    LocaleSidKey = 'pl_PL', ProfileId = p.Id,
                                                    TimeZoneSidKey = 'Europe/Prague', UserName = userAdminName)};
                                                        insert uAdmin;
        return uAdmin;
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
    
    public static List<Account> insertAccount(){
        List<Account> acc = new List <Account> {new Account(Name = 'TestTest1', NIP__c = '111-111-11-11', Phone = '123', BillingPostalCode = '12-542', Email__c = 'olga.ciszek@pwc.com')};
            insert acc;
        return acc;
    }
    
    public static List<Seller__c> insertSeller(){
        List<Seller__c> sell = new List<Seller__c> {new Seller__c(Company_Name__c = 'TestCompany', First_Name__c = 'Jan', Last_Name__c = 'Kowalski', NIP__c = '111-112-12-12', Street__c ='Testowa', Street_no__c = '1', City__c = 'Testowo', Postal_Code__c = '00-001', Bank_Account_Number__c = '11111111111111111111111111', Phone__c = '12345' )};
            insert sell;
        return sell;
    }
}