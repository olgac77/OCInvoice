({
    doInit: function(component) {
        component.set("v.sellerId",null);
    },
    handleClick: function(component, event){        
        component.set("v.truthy",true);
    }, 
    handleNext: function(component, event){
        var appEvent = $A.get("e.c:InvoiceWizardEvent");
        appEvent.setParam("Step", "3");
        appEvent.setParam("Seller",component.get("v.sellerId"));
        appEvent.setParam("Account",component.get("v.accountId"));
        appEvent.setParam("Invoice",component.get("v.invoiceId"));
        appEvent.setParam("Services",component.get("v.serviceId"));        
        appEvent.fire();
    },
    handleSuccess : function(component, event, helper) {
        var successSeller = $A.get("$Label.c.W_Seller_toaster_success");
        var recordIdLabel = $A.get("$Label.c.Record_ID"); 
        component.find('notifLib').showToast({
            "variant": "success",
            "title": successSeller,
            "message": recordIdLabel+" " + event.getParam("id")
        });
        component.set("v.sellerId",event.getParam("id"));
        component.set("v.nextButton",false);              
        component.set("v.truthy",false); 
    },
    handleCancel: function(component, event){
        var button = component.get("v.truthy");
        component.set("v.truthy",false); 
    },   
    handleError: function(component,event){
        var error = event.getParams('error');        
    },
    handleBack: function(component,event) {
        var appEvent = $A.get("e.c:InvoiceWizardEvent");                
        appEvent.setParam("Step", "1");
        appEvent.setParam("Account",component.get("v.accountId"));
        appEvent.setParam("Seller",component.get("v.sellerId"));
        appEvent.setParam("Invoice",component.get("v.invoiceId"));
        appEvent.setParam("Services",component.get("v.serviceId"));        
        appEvent.fire();
    }   
})