@isTest
private class TestAddDeleteController {
    
    @TestSetup
    static void loadData(){
        List<User> u = new List<User>();
        List<Invoice__c> inv = new List<Invoice__c>();
        VAT__c vat = new VAT__c();
        List<VAT__c> vats = new List<VAT__c>();
        TestDataClass.insertUser();
        inv = TestDataClass.loadInvoices(); 
        vat = TestDataClass.insertVat();
        vats.add(vat);
        TestDataClass.insertServices(vats, inv);        
    }
    
    @isTest
    static void testFetchServices(){
        List<User> u = [SELECT Id FROM User WHERE Username = :TestDataClass.userName];
        List<Invoice__c> inv = [SELECT Id FROM Invoice__c LIMIT 1];
        List<Service__c> ser = new List<Service__c>();
        
        System.runAs(u.get(0)){
            Test.startTest();
            ser = addDeleteController.fetchServices(inv.get(0).Id);
            Test.stopTest();
        }
        System.assertEquals(true, ser.size()>0);
    }
    @isTest
    static void testFetchServicesZero(){
        List<User> u = [SELECT Id FROM User WHERE Username = :TestDataClass.userName];
        List<Invoice__c> inv = [SELECT Id FROM Invoice__c LIMIT 1];
        List<Service__c> ser = [SELECT Id FROM Service__c];
        System.runAs(u.get(0)){
            Test.startTest();
            for(Service__c service: ser){
                addDeleteController.deleteService(service.Id);
            }  
            ser = addDeleteController.fetchServices(inv.get(0).Id);
            Test.stopTest();
        }
        System.assertEquals(true, ser.size()==1);
    }     
}