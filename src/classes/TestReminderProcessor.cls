@isTest
private class TestReminderProcessor {
    
    @TestSetup
    static void loadData(){       
        List<Invoice__c> inv = new List<Invoice__c>();
        inv = TestDataClass.loadInvoices();
        inv.get(0).Draft__c = false;
        update inv;
        TestDataClass.insertAdmin();
    }
    
    @isTest
    static void testReminderProcessor() { 
        List<User> u = [SELECT Id from User WHERE userName = :TestDataClass.userAdminName];
        System.assertEquals(0, [select count() from Notify_Purchaser__c]);
        System.runAs(u.get(0)){
            Test.startTest();
            ReminderProcessor rp = new ReminderProcessor();
            Id batchId = Database.executeBatch(rp);
            Test.stopTest();
        }        
        
        System.assertEquals(1, [select count() from Notify_Purchaser__c]);
    }
}