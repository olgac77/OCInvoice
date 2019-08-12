public with sharing class CustomLookUpController {
    
	@AuraEnabled(cacheable=true)
    public static List<RecordsData> fetchRecords( String objectName, String filterField, String searchString ) {
        List<RecordsData> recordsDataList = new List<RecordsData>();
 
        try {
	        String query = 'SELECT Id, ' + filterField+
	                        ' FROM '+objectName+
	                        ' WHERE '+filterField+' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + ' LIMIT 50000';
 
	        for(SObject s : Database.query(query)){
	            RecordsData recordsData = new RecordsData();
	            recordsData.value = String.valueOf(s.get('id'));
	            recordsData.label = String.valueOf(s.get(filterField));
	            recordsDataList.add(recordsData);
	        } 
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
        
        return recordsDataList;
    } 
    
    @AuraEnabled(cacheable=true)
    public static RecordsData fetchRecordById( string recordId, string objectName, string filterField ){
        try{
             String query = 'SELECT Id,' + filterField+
	                        ' FROM '+objectName+
	                        ' WHERE Id ='+'\''+recordId+ '\'';        
        List<SObject> recordsDataList = Database.query(query);        
        if(recordsDataList==null || recordsDataList.isEmpty() ){
            return null;            
        }
        RecordsData rd = new RecordsData();
        rd.label = String.valueOf(recordsDataList.get(0).get(filterField));
        rd.value = String.valueOf(recordsDataList.get(0).get('id'));
        return rd; 
        }catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }
      
    }
    
    @AuraEnabled(cacheable=true)
    public static List<RecordsData> fetchInvoices (String objectName, String filterField, String searchString, Id accountId, Id sellerId){
      List<RecordsData> recordsDataList = new List<RecordsData>();
 
        try {
	        String query = 'SELECT Id, ' + filterField+
	                        ' FROM '+objectName+
	                        ' WHERE '+filterField+' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' + 'AND Account__c ='+'\''+accountId+'\'' 
                + 'AND Seller__c ='+'\''+sellerId+'\''+ 'AND Draft__c =True LIMIT 50000';
            system.debug(query);
 
	        for(SObject s : Database.query(query)){
	            RecordsData recordsData = new RecordsData();
	            recordsData.value = String.valueOf(s.get('id'));
	            recordsData.label = String.valueOf(s.get(filterField));
	            recordsDataList.add(recordsData);
	        } 
	    } catch (Exception err) {
	    	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
	    }
        
        return recordsDataList;  
    }
    
    public with sharing class RecordsData{
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String value {get;set;}
    }
}