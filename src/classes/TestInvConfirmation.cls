@isTest
private class TestInvConfirmation {
    
    @TestSetup
    static void loadData(){
        List<User> u = new List<User>();
        List<Invoice__c> inv = new List<Invoice__c>();        
        TestDataClass.insertUser();
        inv = TestDataClass.loadInvoices();                
    }
    
    @isTest
    static void testUnmarkAsDraft(){
        List<User> u = [SELECT Id FROM User WHERE Username = :TestDataClass.userName];
        List<Invoice__c> inv = [SELECT Id, Draft__c FROM Invoice__c LIMIT 1];
        List<Invoice__c> invAfter = new List<Invoice__c>();
                
        System.runAs(u.get(0)){
            Test.startTest();
            InvConfirmation.unmarkAsDraft(inv.get(0).Id);
            invAfter = [SELECT Draft__c FROM Invoice__c WHERE Id=:inv.get(0).Id];
            Test.stopTest();
        }
        System.assertEquals(true, inv.get(0).Draft__c);
        System.assertEquals(false, invAfter.get(0).Draft__c);
    }
    
    @isTest
    static void testgetPDFURL(){
         List<User> u = [SELECT Id FROM User WHERE Username = :TestDataClass.userName];
         String url = '';
		        
                
        System.runAs(u.get(0)){
            Test.startTest();
            url = InvConfirmation.getPDFURL();
            Test.stopTest();
        }
        System.assertEquals(true, String.isNotBlank(url));        
    }        
}