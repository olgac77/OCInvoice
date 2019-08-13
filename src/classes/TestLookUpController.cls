@isTest
private class TestLookUpController {
    
    @TestSetup
    static void loadData(){
        List<User> u = new List<User>();
        List<Invoice__c> inv = new List<Invoice__c>();
        TestDataClass.insertUser();
        TestDataClass.loadInvoices(); 
    }
    
    @isTest    
    static void testFetchRecordsFound(){        
        DescribeSObjectResult describe = SObjectType.Account;
        String objectName =describe.getName();
        Schema.DescribeFieldResult describeField = Account.Name.getDescribe();
        String filterField = describeField.getName();
        String searchString = 'TestTest1';
        List<CustomLookUpController.RecordsData> rec = new List<CustomLookUpController.RecordsData>();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
            Test.startTest();
            rec = CustomLookUpController.fetchRecords(objectName, filterField, searchString);
            Test.stopTest();
        }
        System.assertEquals(false,u==null||u.isEmpty());
        System.assertEquals('TestTest1', rec.get(0).Label); 
    }
    
    @isTest    
    static void testFetchRecordById(){
        DescribeSObjectResult describe = SObjectType.Account;
        String objectName =describe.getName();
        Schema.DescribeFieldResult describeField = Account.Name.getDescribe();
        String filterField = describeField.getName();
        List<Account> acc = [SELECT Id from Account];
        String recordId = acc.get(0).Id;
        CustomLookUpController.RecordsData rec = new CustomLookUpController.RecordsData();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
            Test.startTest();
            rec = CustomLookUpController.fetchRecordById(recordId, objectName,filterField);
            Test.stopTest();
        }
        System.assertEquals(false, acc==null||acc.isEmpty());
        System.assertEquals(false,u==null||u.isEmpty());
        System.assertEquals('TestTest1', rec.Label);
    }
    @isTest    
    static void testFetchRecordByIdNoResult(){
        DescribeSObjectResult describe = SObjectType.Account;
        String objectName =describe.getName();
        Schema.DescribeFieldResult describeField = Account.Name.getDescribe();
        String filterField = describeField.getName();        
        String recordId = '';
        CustomLookUpController.RecordsData rec = new CustomLookUpController.RecordsData();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
            Test.startTest();
            rec = CustomLookUpController.fetchRecordById(recordId, objectName,filterField);
            Test.stopTest();
        }
        System.assertEquals(false,u==null||u.isEmpty());
        System.assertEquals(null, rec);
    }
    
    @isTest    
    static void testFetchInvoices(){
        DescribeSObjectResult describe = SObjectType.Invoice__c;
        String objectName =describe.getName();
        Schema.DescribeFieldResult describeField = Invoice__c.Invoice_Number__c.getDescribe();
        String filterField = describeField.getName();
        String searchString = 'FV';
        List<Account> acc = [SELECT Id from Account LIMIT 1];
        List<Seller__c> sel = [SELECT Id from Seller__c LIMIT 1];
        List<CustomLookUpController.RecordsData> rec = new List<CustomLookUpController.RecordsData>();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
            Test.startTest();
            rec = CustomLookUpController.fetchInvoices(objectName,filterField, searchString, acc.get(0).Id, sel.get(0).Id);
            Test.stopTest();
        }
        System.assertEquals(false, sel==null||sel.isEmpty());
        System.assertEquals(false, acc==null||acc.isEmpty());
        System.assertEquals(false, u==null||u.isEmpty());
        System.assertEquals(TestDataClass.fakeInvoiceNumber, rec.get(0).Label);
    }   
}