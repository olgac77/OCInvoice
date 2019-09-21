@isTest
private class TestReminderProcessor {
    
    @TestSetup
     static void loadData(){       
        List<Invoice__c> inv = new List<Invoice__c>();
        inv = TestDataClass.loadInvoices();
         inv.get(0).Draft__c = false;
         update inv;
    }
    
    @isTest
     static void testReminderProcessor() {        
        Test.startTest();
        ReminderProcessor rp = new ReminderProcessor();
        Id batchId = Database.executeBatch(rp);
        Test.stopTest();
        
        System.assertEquals(1, [select count() from Notify_Purchaser__c]);
    }
}