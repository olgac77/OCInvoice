({
	handleErrors : function(message, title, type) {
	 	var toastEvent = $A.get("e.force:showToast");
       	toastEvent.setParams({"title": title, "message":message, "type":type});
    	toastEvent.fire();
    },  
    getFile : function(component, event){  
        var recordId = component.get("v.recordId");
        var action = component.get("c.getFiles");
        action.setParams({"sellerId": recordId});       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.files", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);  
	},
    
    deleteFile : function(component, event){
		var fileId = event.getSource().get("v.value");
        var action = component.get('c.deleteContentFile'); 
        action.setParams({
            "contentDocumentId" : fileId 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state === 'SUCCESS') {
                this.handleErrors($A.get("$Label.c.DeleteSuccessLabel"), $A.get("$Label.c.SuccessLabel"),"success");                
                component.set("v.files",null);
            }else{
                this.handleErrors($A.get("$Label.c.DeleteErrorLabel"), $A.get("$Label.c.ErrorLabel"),"error");                       
            }
        });
        $A.enqueueAction(action);
    },    
})