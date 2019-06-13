/**
 * Created by ociszek001 on 22.05.2019.
 */
@isTest
private class TestContentNumberValidation {

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
    }

    @isTest
    static void testInsertContentPositive() {
        List<User> u = [SELECT Id FROM User WHERE UserName = 'devkama23052019@test.com'];      
        List<AggregateResult> ar = new List<AggregateResult>();
        ContentDocumentLink cdl = new ContentDocumentLink();
        System.runAs(u.get(0)) {
            Test.startTest();           
            List<Account> acc = [SELECT Id from Account];
            ContentVersion contentVersion = new ContentVersion(
                    Title = 'Test',
                    PathOnClient = 'Test.jpg',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true
            );
            insert contentVersion;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

            cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = acc.get(0).Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            ar = [SELECT COUNT (Id) num FROM ContentDocumentLink WHERE shareType = 'V' AND LinkedEntityId = :acc.get(0).Id];
            Test.stopTest();
        }
        System.assertEquals(1, ar.get(0).get('num'));
    }

    @isTest
    static void testInsertContentNegative() {
        List<Account> acc = [SELECT Id from Account];
        ContentDocumentLink cdlFirst = TestDataClass.insertContent(acc);
        ContentVersion contentVersion = new ContentVersion(
                Title = 'Test2',
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        Test.startTest();
        insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Title = 'Test2'];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = cdlFirst.LinkedEntityId;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        Database.SaveResult result = Database.insert(cdl, false);
        Test.stopTest();
        System.assertEquals(false, result.isSuccess());
    }
}