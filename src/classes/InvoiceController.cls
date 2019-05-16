/**
 * Created by ociszek001 on 08.05.2019.
 */

public with sharing class InvoiceController {
    public Invoice__c inv { get; set; }
    public String logoURL { get; set;}

    public InvoiceController() {
        inv = getInvoice();
        logoURL = getLogos(inv.Seller__c);
    }

    public String getLogos(Id sellerId) {
        //sprawdz czy sellerId nie jest puste i obsłuzyć
       List<ContentDocumentLink> logoIds= [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = 'a012p00001DcpV5AAJ'];
        if(!logoIds.isEmpty()) {
            String env = URL.getSalesforceBaseUrl().toExternalForm();
            return env + '/sfc/servlet.shepherd/document/download/' + logoIds.get(0).ContentDocumentId;
        }

        return null;
        }


    public Invoice__c getInvoice() {
        //sprawdzic czy result nie jest puste i obsłuzyć. jesili puste stworzyc nowy obiekt        String result = pag;
        inv = [
                SELECT Delivery_Date__c, Issue_Date__c, Issue_Place__c, Name, Seller__r.Company_Name__c,Account__r.NIP__c,Account__r.BillingStreet,Account__r.BillingCity,Account__r.BillingPostalCode,
                        Account__r.Name, Seller__r.NIP__c, Seller__r.Bank_Account_Number__c, Gross_Total__c,
                        Net_Total__c, VAT_Total__c, Amount_in_words__c, Seller__r.Street__c, Seller__r.Street_No__c, Seller__r.Postal_Code__c,
                        Seller__r.City__c, Seller__r.Apt_No__c, Payment__c, Payment_Terms__c, Due_Date__c,Status__c, (SELECT Name_of_Service__c, Price_after_discount__c, Quantity__c, Unit__c, Net_Price__c, Discount__c, Net_Amount__c, VAT__r.Name, VAT_Amount__C, Gross_Amount__c FROM Services__r)
                FROM Invoice__c
                WHERE Id = 'a042p00000vDBK0AAO'
        ];
        return inv;
    }
}