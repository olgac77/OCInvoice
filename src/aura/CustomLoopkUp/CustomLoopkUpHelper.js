({
    searchRecordsHelper : function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        component.set('v.message','');
        component.set('v.recordsList',null);
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setStorable();
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : component.get('v.searchString')
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                // To check if any records are found for searched keyword
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
                    } else {
                        var index = result.findIndex(x => x.value === value)
                        if(index != -1) {
                            var selectedRecord = result[index];
                        }                         
                        component.set('v.selectedRecord',selectedRecord);                                             
                    }
                } else {                    
                    component.set('v.message','No Records Found');
                }
            } else if(response.getState() === 'INCOMPLETE') {
                component.set('v.message','No Server Response or client is offline');
            } else if(response.getState() === 'ERROR') {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);       
    },
    searchInvoicesHelper : function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        component.set('v.message','');
        component.set('v.recordsList',null);
        // Calling Apex Method
        var action = component.get('c.fetchInvoices');
        action.setStorable();
        action.setParams({
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),
            'searchString' : component.get('v.searchString'),
            'accountId' : component.get('v.accountId'),
            'sellerId' :component.get('v.sellerId')
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            if(response.getState() === 'SUCCESS') {
                // To check if any records are found for searched keyword
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
                    } else {
                        var index = result.findIndex(x => x.value === value)
                        if(index != -1) {
                            var selectedRecord = result[index];
                        }                         
                        component.set('v.selectedRecord',selectedRecord);                                             
                    }
                } else {
                    component.set('v.message','No Records Found');
                }
            } else if(response.getState() === 'INCOMPLETE') {
                component.set('v.message','No Server Response or client is offline');
            } else if(response.getState() === 'ERROR') {
                // If server throws any error
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {                    
                    component.set('v.message', errors[0].message);
                }
            }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);       
    },
    
    searchRecordByIdHelper: function(component, event, helper, value){       
        var action = component.get('c.fetchRecordById');        
        action.setParams({
            'recordId' : value,
            'objectName' : component.get('v.objectName'),
            'filterField' : component.get('v.fieldName'),            
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();            
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();               
                component.set('v.selectedRecord',result);
                component.set('v.value',result.value);               
            }         
            else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!", "message":"Please contact with your Salesforce Administrator", "type":"error"});
                toastEvent.fire();
            } 
         });
        $A.enqueueAction(action);        	
    }
})