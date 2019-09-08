({
    createObjectData: function(component, event) {       
        var invoiceId = component.get("v.invoiceId");
        if($A.util.isEmpty(invoiceId)){
            return;
        }
        var action = component.get("c.fetchServices");
        action.setParams({"invoiceId":invoiceId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseValue = response.getReturnValue();  
            if (state === "SUCCESS") {   
                component.set("v.serviceList", responseValue);
            }else{
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "Unable to display related Services"           
                });
            }
        });       
        $A.enqueueAction(action);
    },
    
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.serviceList");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].Name_of_Service__c == '' ||allContactRows[indexVar].Quantity__c == '' || allContactRows[indexVar].Unit == '' ||allContactRows[indexVar].Net_Price__c == '' ||allContactRows[indexVar].VAT__c == '' ) {
                isValid = false;
                component.find('notifLib').showToast({
                    "variant": "error",
                    "title": "One or more fields are blank on row " + (indexVar + 1)           
                });               
            }
        }
        return isValid;
    },
})