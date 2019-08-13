@isTest
public class TestLookUpController {
    
     @TestSetup
    static void loadData(){
        List<User> u = new List<User>();
      	List<Invoice__c> inv = new List<Invoice__c>();
        u = TestDataClass.insertUser();
        inv = testDataClass.loadInvoices(); 
     }
    
    @isTest    
    public static void testFetchRecordsFound(){
        String objectName = 'Account';
        String filterField = 'Name';
        String searchString = 'TestTest1';
        List<CustomLookUpController.RecordsData> rec = new List<CustomLookUpController.RecordsData>();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
           Test.startTest();
           rec = CustomLookUpController.fetchRecords(objectName, filterField, searchString);
           Test.stopTest();
        }
         System.assertEquals('TestTest1', rec.get(0).Label); 
    }
    
    @isTest    
    public static void testFetchRecordById(){
        String objectName = 'Account';
        String filterField = 'Name';
        List<Account> acc = [SELECT Id from Account];
        String recordId = acc.get(0).Id;
        CustomLookUpController.RecordsData rec = new CustomLookUpController.RecordsData();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
           Test.startTest();
           rec = CustomLookUpController.fetchRecordById(recordId, objectName,filterField);
           Test.stopTest();
        }
         System.assertEquals('TestTest1', rec.Label);
    }
     @isTest    
    public static void testFetchRecordByIdNoResult(){
        String objectName = 'Account';
        String filterField = 'Name';        
        String recordId = 'a012p00001H9TgTAAC';
        CustomLookUpController.RecordsData rec = new CustomLookUpController.RecordsData();
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        System.runAs(u.get(0)){
           Test.startTest();
           rec = CustomLookUpController.fetchRecordById(recordId, objectName,filterField);
           Test.stopTest();
        }
         System.assertEquals(null, rec);
    }
    
        @isTest    
    public static void testFetchInvoices(){
        String objectName = 'Invoice__c';
        String filterField = 'Invoice_Number__c';
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
         System.assertEquals('FV/2019/01/01', rec.get(0).Label);
    }


}