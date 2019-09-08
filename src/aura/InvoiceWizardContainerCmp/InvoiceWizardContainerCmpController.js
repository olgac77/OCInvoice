({
    handleSteps : function(component, event, helper) {
        var step = event.getParam("Step");
        var accountId = event.getParam("Account");
        var sellerId = event.getParam("Seller");
        var invoiceId = event.getParam("Invoice");
        var serviceId = event.getParam("Services");
        component.set("v.Step",step);
        component.set("v.accountId",accountId);
        component.set("v.sellerId",sellerId)
        component.set("v.invoiceId",invoiceId);
        component.set("v.serviceId",serviceId);
    }
})