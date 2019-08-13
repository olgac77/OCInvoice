@isTest
private class TestLogoValidation {
    
    @TestSetup
    static void loadData(){
        List<User> u = new List<User>();
        List<Seller__c> sel = new List<Seller__c>();        
        u = TestDataClass.insertUser();
        sel = TestDataClass.insertSeller();
        System.runAs(u.get(0)){
            ContentVersion contentVersion = new ContentVersion(
                    Title = 'Test',
                    PathOnClient = 'Test.jpg',
                    VersionData = Blob.valueOf('Test Content'),
                    IsMajorVersion = true
            );
            insert contentVersion;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Title = 'Test' LIMIT 1];
            System.assertEquals(1, documents.size());
    
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = sel.get(0).Id;
            cdl.ContentDocumentId = documents.get(0).Id;
            cdl.shareType = 'V';
            insert cdl;  
        }
     }
    
    @isTest
    static void testValidateLogoNegative(){
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        List<Seller__c> sel = [SELECT Id from Seller__c LIMIT 1];
		List<ContentDocumentLink> cdlUploaded = [SELECT ContentDocumentId from ContentDocumentLink WHERE LinkedEntityId=:sel.get(0).Id];       

        System.runAs(u.get(0)){
            Test.startTest();
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Test2',
                PathOnClient = 'Test2.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        	);
            insert contentVersion;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Title = 'Test2'];
    
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = sel.get(0).Id;
            cdl.ContentDocumentId = documents.get(0).Id;
            cdl.shareType = 'V';
            insert cdl; 
            Wrapper wr = LogoValidation.validateLogo(sel.get(0).Id, cdl.ContentDocumentId);
            Test.stopTest();   
            System.assertEquals(false, wr.Successful);
            System.assertEquals('Logo has been already uploaded for this Seller!', wr.Message);                     
        }
    }
    
    @isTest
     static void testValidateLogoPositive(){
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        List<Seller__c> sel = [SELECT Id from Seller__c LIMIT 1];
		List<ContentDocumentLink> cdl = [SELECT ContentDocumentId from ContentDocumentLink WHERE LinkedEntityId=:sel.get(0).Id];
        Wrapper wr = new Wrapper('Go', false);    
         System.runAs(u.get(0)){
            Test.startTest();
            LogoValidation.deleteContentFile(cdl.get(0).Id);
            wr = LogoValidation.validateLogo(sel.get(0).Id, cdl.get(0).ContentDocumentId); 
			System.debug(wr);            
			Test.stopTest();            
        }
         
		System.assert(true, wr.Successful);
        System.assertEquals('Logo has been uploaded for this Seller!', wr.Message);
    }    
    
   @isTest
    static void testGetFiles(){
        List<User> u = [SELECT Id from User WHERE Username = :TestDataClass.userName];
        List<Seller__c> sel = [SELECT Id from Seller__c LIMIT 1];
        List<ContentDocumentLink> cdl = [SELECT ContentDocumentId from ContentDocumentLink WHERE LinkedEntityId=:sel.get(0).Id];
        List<ContentDocumentLink> cdlTest = new List<ContentDocumentLink>();
        System.runAs(u.get(0)){
            Test.startTest();
            cdlTest=LogoValidation.getFiles(sel.get(0).Id);
            Test.stopTest();
        }
        System.assertEquals(cdl.get(0).Id, cdlTest.get(0).Id);        
    }    
}