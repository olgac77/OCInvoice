({
    doInit: function(component,event){
        var action = component.get("c.getPDFURL");            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var result = response.getReturnValue();
                component.set("v.url",result);
                if (state === "ERROR") {  
                    var errorPdf = $A.get("$Label.c.W_Preview_error_Pdf");
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "title": errorPdf          
                    });
                }
            });       
            $A.enqueueAction(action);        
    },
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
                    var successConfirm = $A.get("$Label.c.W_Preview_toaster_success");
                    component.find('notifLib').showToast({
                        "variant": "success",
                        "title": successConfirm          
                    });
                }else{
                    var errorConfirm = $A.get("$Label.c.W_Preview_error");
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "title": errorConfirm           
                    });
                }
            });       
            $A.enqueueAction(action);
            setTimeout(function(){ location.reload(true); }, 4000);
        }
        else{
            var addService = $A.get("$Label.c.W_Preview_add_service");
            component.find('notifLib').showToast({
                "variant": "error",
                "title": addService           
            });           
        }
    }
})