@isTest
private class TestReminderProcessorScheduler {
    
    private static String CRON_EXP = '0 0 0 15 3 ? 2022';
    
    @TestSetup
    static void loadData(){       
        List<Invoice__c> inv = new List<Invoice__c>();
        inv = TestDataClass.loadInvoices();
        inv.get(0).Draft__c = false;         
        update inv;
        TestDataClass.insertAdmin();
    }
    
    @isTest
    static void testReminderScheduler(){        
        List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType 
                                         from AsyncApexJob WHERE ApexClass.Name = 'ReminderProcessorScheduler'];        
   		System.assertEquals(0, jobsBefore.size());
        List<User> u = [SELECT Id from User WHERE userName = :TestDataClass.userAdminName];
        System.runAs(u.get(0)){        
            Test.startTest();
            String jobId = system.schedule('Test Reminder', CRON_EXP, new ReminderProcessorScheduler());
            Test.stopTest();
        }
        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType 
                                            from AsyncApexJob where JobType = 'ScheduledApex' and ApexClass.Name = 'ReminderProcessorScheduler'];
        System.assertEquals(0, jobsBefore.size());
        System.assertEquals('ReminderProcessorScheduler', jobsScheduled.get(0).ApexClass.Name);        
    }   
}