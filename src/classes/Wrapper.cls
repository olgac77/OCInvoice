public with sharing class Wrapper {
    @AuraEnabled
    public String Message {get; set;}
    @AuraEnabled
    public Boolean Successful {get; set;}
    
    public Wrapper (String message, Boolean successful){
        this.Message = message;
        this.Successful = successful;
    }

}