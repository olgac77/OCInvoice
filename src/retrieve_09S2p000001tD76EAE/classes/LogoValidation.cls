public with sharing class LogoValidation {
    
    @AuraEnabled
    public static Wrapper validateLogo(Id sellerId, Id documentId){
        AggregateResult ar = [SELECT COUNT(ContentDocumentId) cdlcount from ContentDocumentLink WHERE LinkedEntityId = :sellerId]; 
            if (Integer.valueOf(ar.get('cdlcount')) > 1) {
                List<ContentDocumentLink> cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :sellerId AND ContentDocumentId=:documentId];
                try{
                    delete cdl; 
                    return new Wrapper(Label.LogoError, false);
                }
                catch(Exception e){
                    throw new AuraHandledException(Label.LogoException);
                }                      
            }else{
                return new Wrapper(Label.LogoSuccess, true);
            }
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getFiles(Id sellerId){
    	return [Select ContentDocumentId from ContentDocumentLink WHERE LinkedEntityId=:sellerId];      
    }    
    

    @AuraEnabled 
    public static void deleteContentFile(Id contentDocumentId){
        try{
            Database.delete(contentDocumentId);      
        }
        catch (Exception e){
            throw new AuraHandledException(Label.LogoDeleteException);
        }      
    }
}