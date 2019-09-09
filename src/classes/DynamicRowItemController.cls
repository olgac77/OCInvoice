public with sharing class DynamicRowItemController {
    
    @AuraEnabled        
    public static List <String> getUnits() {        
        List <String> allOpts = new list <String> ();        
        Schema.sObjectType objType = Service__c.getSObjectType();        
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();        
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();        
        List <Schema.PicklistEntry> values =
            fieldMap.get('Unit__c').getDescribe().getPickListValues();        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }      
        allOpts.sort();
        return allOpts;
    }
}