({
    doInit: function(component,event,helper){            
        var action = component.get("c.getUnits");           
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {   
                component.set("v.units",response.getReturnValue());
            }
        });       
        $A.enqueueAction(action);
    },
    
    AddNewRow : function(component, event, helper){
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
})