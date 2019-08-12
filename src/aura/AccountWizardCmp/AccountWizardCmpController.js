({
    doInit: function(component) {
        component.set("v.accountId",null);
    },
    handleClick: function(component, event){
        var button = component.get("v.truthy");
        component.set("v.truthy",true);
    },
    handleSubmit: function(component, event){
        event.preventDefault();    
        const fields = event.getParam('fields');        
        component.find('myRecordForm').submit(fields);               
    },
    handleNext: function(component, event){
        var appEvent = $A.get("e.c:InvoiceWizardEvent");
        appEvent.setParam("Step", "2");
        appEvent.setParam("Account",component.get("v.accountId")); 
        appEvent.setParam("Seller",component.get("v.sellerId")); 
        appEvent.fire();
    },
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Account Created",
            "message": "Record ID: " + event.getParam("id")
        });
        component.set("v.accountId",event.getParam("id"));
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
    }
})