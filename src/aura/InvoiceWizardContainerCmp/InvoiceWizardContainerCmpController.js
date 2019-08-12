({
    handleSteps : function(component, event, helper) {
        var step = event.getParam("Step");
        var accountId = event.getParam("Account");
        var sellerId = event.getParam("Seller");
        component.set("v.Step",step);
        component.set("v.accountId",accountId);
        component.set("v.sellerId",sellerId)
    }
})