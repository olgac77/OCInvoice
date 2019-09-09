@isTest
private class TestDynamicRowItemController {
    
    @TestSetup
    static void loadData(){
        List<User> u = new List<User>();        
        TestDataClass.insertUser();                
    }
    
    @isTest
    static void testGetUnits(){
        List<User> u = [SELECT Id FROM User WHERE Username = :TestDataClass.userName];
        List<String> units = new List<String>();
        System.runAs(u.get(0)){
            Test.startTest();
            units = DynamicRowItemController.getUnits();
            Test.stopTest();
        }
        System.assertEquals(true, units.contains(TestDataClass.hoursUnit));
    }
}