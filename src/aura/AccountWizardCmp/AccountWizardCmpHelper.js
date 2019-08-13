({
    handleEvent : function(component,event) {
        var appEvent = $A.get("e.c:InvoiceWizardEvent");                
        appEvent.setParam("Step", "2");
        appEvent.setParam("Account",component.get("v.accountId"));
        appEvent.fire();
    }
})