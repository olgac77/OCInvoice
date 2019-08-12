({
    doInit: function(component) {
        component.set("v.invoiceId",null);
    },
    handleClick: function(component, event){
        var button = component.get("v.truthy");
        component.set("v.truthy",true);
    },
   
    handleNext: function(component, event){
        var appEvent = $A.get("e.c:InvoiceWizardEvent");
        appEvent.setParam("Step", "4");
        appEvent.setParam("Invoice",component.get("v.invoiceId"));            
        appEvent.fire();
    },
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Invoice Created",
            "message": "Record ID: " + event.getParam("id")
        });
        component.set("v.invoiceId",event.getParams().response.id);
        component.set("v.nextButton",false);
        component.set("v.truthy",false);        
    },
    handleCancel: function(component, event){
        var button = component.get("v.truthy");
        component.set("v.truthy",false); 
    },
    handleError: function(component,event){
        var error = event.getParams('error');
        console.log(JSON.stringify(error));
    },
    handleBack: function(component,event) {
        var accountId = component.get("v.accountId");
        var sellerId = component.get("v.sellerId");
        var invoiceId = component.get("v.invoiceId");
        var appEvent = $A.get("e.c:InvoiceWizardEvent");                
        appEvent.setParam("Step", "2");
        appEvent.setParam("Account",accountId);
        appEvent.setParam("Seller",sellerId);
        appEvent.setParam("Invoice", invoiceId);
        appEvent.fire();
    }   
})