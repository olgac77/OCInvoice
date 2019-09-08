({
    doInit: function(component, event, helper) {
        helper.createObjectData(component, event);
    },
    
    handleSteps: function(component, event, helper) {
        var step = event.getParam("Step");
        if(step === '4')
            helper.createObjectData(component, event);
    },
    
    Save: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {            
            if (helper.validateRequired(component, event)) {
                var action = component.get("c.saveServices");
                var listS = component.get("v.serviceList");
                action.setParams({
                    "ListServices": listS
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log(state);
                    if (state === "SUCCESS") {
                        component.set("v.serviceList", []);
                        helper.createObjectData(component, event);                    
                        component.find('notifLib').showToast({
                            "variant": "success",
                            "title": "Services have been created/updated"            
                        });                  
                    }       
                });
                $A.enqueueAction(action);
            }       
        }
    },
    
    addNewRow: function(component, event, helper) {
        var RowItemList = component.get("v.serviceList");
        RowItemList.push({
            'sobjectType': 'Service__c',
            'Name_of_Service__c': '',
            'Quantity__c': '',
            'Unit__c': '',
            'Net_Price__c': '',
            'VAT__c': null,
            'Invoice__c':component.get('v.invoiceId')
        });
        component.set("v.serviceList", RowItemList);    
    },
    
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.serviceList");
        var removedSerId = AllRowsList[index].Id;        
        AllRowsList.splice(index, 1);
        component.set("v.serviceList",AllRowsList);
        if($A.util.isEmpty(removedSerId)){
            return;
        }
        else{
            var action = component.get("c.deleteService");
            action.setParams({"serviceId":removedSerId});
            action.setCallback(this, function(response) {
                var state = response.getState();           
                if (state === "SUCCESS") {   
                    component.find('notifLib').showToast({
                        "variant": "success",
                        "title": "Service has been deleted"            
                    });
                }else{
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "title": "Unable to delete Service"            
                    });
                }
            });       
            $A.enqueueAction(action);
        }
    },
})