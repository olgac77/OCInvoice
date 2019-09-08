({
    handleBack: function(component,event) {
        var appEvent = $A.get("e.c:InvoiceWizardEvent");                
        appEvent.setParam("Step", "4");
        appEvent.setParam("Account",component.get("v.accountId"));
        appEvent.setParam("Seller",component.get("v.sellerId"));
        appEvent.setParam("Invoice",component.get("v.invoiceId"));
        appEvent.setParam("Services",component.get("v.serviceId"));        
        appEvent.fire();
    },
    
    confirm: function(component,event){
        var invoiceId = component.get("v.invoiceId");
        var serviceId = component.get("v.serviceId");
        if(serviceId.length>0){
            var action = component.get("c.unmarkAsDraft");
            action.setParams({"invoiceId":invoiceId});
            action.setCallback(this, function(response) {
                var state = response.getState();            
                if (state === "SUCCESS") {   
                    component.find('notifLib').showToast({
                        "variant": "success",
                        "title": "Your invoice has been confirmed and you will be redirected to initial page"           
                    });
                }else{
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "title": "Unable to confirm your invoice"           
                    });
                }
            });       
            $A.enqueueAction(action);
            setTimeout(function(){ location.reload(true); }, 4000);
        }
        else{
            component.find('notifLib').showToast({
                "variant": "error",
                "title": "Please add services to your invoice"           
            });           
        }
    }
})