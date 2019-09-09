public with sharing class addDeleteController {
    
    @AuraEnabled
    public static void saveServices(List<Service__c> ListServices){
        upsert ListServices;
    }
    
    @AuraEnabled
    public static List<Service__c> fetchServices(Id invoiceId){
        List<Service__c> services = new List<Service__c>();
        if(String.isNotBlank(invoiceId)){
            services= [SELECT Name_of_Service__c, Quantity__c,Unit__c,Net_Price__c,VAT__c, Invoice__c from Service__c WHERE Invoice__c =:invoiceId];
        }
        
        if(services.size() == 0){
            Service__c ser = new Service__c(Name_of_Service__c='', Quantity__c=0, Unit__c='Pcs', Net_Price__c=0,VAT__c=null, Invoice__c =invoiceId);
            services.add(ser);
        }
        return services;
    }
    
    @AuraEnabled    
    public static void deleteService(Id serviceId){
        database.delete(serviceId);
    }
}