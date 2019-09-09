({
    doInit: function(component) {
        component.set("v.serviceId",null);        
    },
    handleSteps : function(component, event, helper) {
        var step = event.getParam("Step");
        var accountId = event.getParam("Account");
        var sellerId = event.getParam("Seller");
        component.set("v.Step",step);
        component.set("v.accountId",accountId);
        component.set("v.sellerId",sellerId);
    },
    handleBack: function(component,event) {
        var appEvent = $A.get("e.c:InvoiceWizardEvent");                
        appEvent.setParam("Step", "3");
        appEvent.setParam("Account",component.get("v.accountId"));
        appEvent.setParam("Seller",component.get("v.sellerId"));
        appEvent.setParam("Invoice", component.get("v.invoiceId"));
        appEvent.setParam("Services", component.get("v.serviceId"));
        appEvent.fire();
    },
    handleNext: function(component, event){        
        var childCmp = component.find("save");      
        childCmp.Save();      
        var appEvent = $A.get("e.c:InvoiceWizardEvent");
        appEvent.setParam("Step", "5");
        appEvent.setParam("Seller",component.get("v.sellerId"));
        appEvent.setParam("Account",component.get("v.accountId")); 
        appEvent.setParam("Invoice",component.get("v.invoiceId"));
        appEvent.setParam("Services",component.get("v.serviceId")); 
        appEvent.fire();  
        
    },
})