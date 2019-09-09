({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper ) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        if( !$A.util.isEmpty(component.get('v.value')) ) {
            helper.searchRecordsHelper( component, event, helper, component.get('v.value') );
        }
        if( !$A.util.isEmpty(component.get('v.recordId')) ){            
            helper.searchRecordByIdHelper(component, event, helper, component.get('v.recordId') );                
        }
    },
    handleValueChange: function (component,event,helper){
        if( !$A.util.isEmpty(component.get('v.recordId')) ){            
            helper.searchRecordByIdHelper(component, event, helper, component.get('v.recordId') );                
        }
    },
          
    searchRecords : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
            if(!$A.util.isEmpty(component.get('v.invoiceWizard'))){
                helper.searchInvoicesHelper(component,event, helper, '');
            }
            else{
                helper.searchRecordsHelper( component, event, helper, '' );
            }            
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    // When an item is selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get('v.recordsList');
            var index = recordsList.findIndex(x => x.value === event.currentTarget.id)
            if(index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set('v.selectedRecord',selectedRecord);
            component.set('v.value',selectedRecord.value);
            component.set('v.recordId',event.currentTarget.id);
            component.set('v.disabledButton',true);
            component.set('v.nextButton',false);
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
    },
    
    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedRecord','');
        component.set('v.value','');
        component.set('v.searchString','');
        component.set('v.recordId','');
        component.set('v.disabledButton',false);
        component.set('v.nextButton',true);
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
    },
    
})